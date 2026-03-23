---
name: yt-dlp
description: "Gradio + Faster-Whisper + Gemini + FFmpeg + yt-dlp 기술 스택을 조합하여 로컬 데스크탑 AI 앱을 만드는 스킬. 영상/음성 → AI 전사 → LLM 구조화 → 인터랙티브 웹 UI 파이프라인 구축 시 사용. 유튜브 다운로드, 자막 생성, 노트 정리, 스크린샷 캡쳐, Obsidian 내보내기 등의 기능을 조합할 때 적합."
homepage: https://github.com/Reasonofmoon/moonscribe
metadata: { "openclaw": { "emoji": "🌕", "requires": { "bins": ["ffmpeg", "python"] } } }
---

# Moonscribe Builder Skill

Gradio 웹 UI 위에 Faster-Whisper(음성→텍스트), Google Gemini(텍스트→구조화 노트), FFmpeg(영상 프레임 추출), yt-dlp(유튜브 다운로드)를 결합한 **로컬 AI 데스크탑 앱**을 만드는 전체 파이프라인 스킬.

## When to Use

✅ **USE this skill when:**

- "유튜브 영상을 다운받아서 자막을 뽑고 싶어"
- "강의 영상을 AI가 정리해주는 노트 앱을 만들어줘"
- "영상에서 특정 시간대의 스크린샷을 캡쳐하는 기능이 필요해"
- "Gradio로 로컬 AI 웹 앱을 빠르게 만들고 싶어"
- "Whisper + LLM + FFmpeg 파이프라인을 구축해야 해"
- "결과물을 Obsidian 마크다운으로 내보내고 싶어"

## When NOT to Use

❌ **DON'T use this skill when:**

- 실시간 스트리밍 음성 인식이 필요할 때 (WebRTC/Socket 기반 별도 아키텍처 필요)
- 프로덕션 SaaS 배포가 목적일 때 (Gradio는 프로토타입용, 프로덕션은 Next.js 등 사용)
- GPU가 없는 환경에서 large-v3 모델을 돌려야 할 때 (base 이하 모델만 가능)

---

## Tech Stack

| 라이브러리 | 역할 | pip 이름 |
|-----------|------|---------|
| **Faster-Whisper** | AI 음성 인식 (CTranslate2 최적화 Whisper) | `faster-whisper` |
| **Gradio** | Python 기반 웹 UI 프레임워크 | `gradio` |
| **Google Gemini** | LLM 텍스트 구조화/요약 | `google-genai` |
| **FFmpeg** | 영상 처리, 프레임 추출, 자막 합성 | `imageio-ffmpeg` |
| **yt-dlp** | 유튜브 영상/자막 다운로드 | `yt-dlp` |
| **markdown** | Markdown → HTML 변환 | `markdown` |

### requirements.txt

```
faster-whisper
gradio
imageio-ffmpeg
yt-dlp
google-genai
markdown
```

---

## Architecture: 5-Stage Pipeline

```
[Input]           [Stage 1]          [Stage 2]          [Stage 3]          [Output]
YouTube URL  -->  yt-dlp          --> Faster-Whisper --> Gemini LLM    --> Gradio UI
Local File   -->  (download/copy) --> (transcribe)   --> (structure)   --> (interactive HTML)
                                                                       --> Obsidian .md
                                                                       --> FFmpeg (screenshots)
```

### Stage 1: Media Acquisition

```python
import yt_dlp

def download_youtube_video(url):
    ydl_opts = {
        'format': 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best',
        'outtmpl': str(TEMP_DIR / 'yt_%(id)s.%(ext)s'),
        'restrictfilenames': True,
        'noplaylist': True,
    }
    # FFmpeg location for merging video+audio
    if FFMPEG_OK:
        ydl_opts['ffmpeg_location'] = os.path.dirname(FFMPEG_EXE)
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(url, download=True)
        return ydl.prepare_filename(info), info.get('title', 'Video')
```

**주의사항:**
- `restrictfilenames=True`: 한글/특수문자 파일명 오류 방지
- `noplaylist=True`: 재생목록 전체 다운로드 방지
- 일부 보호된 유튜브 영상은 Node.js 런타임이 필요함 (`WARNING: No supported JavaScript runtime`)

### Stage 2: AI Transcription (Faster-Whisper)

```python
from faster_whisper import WhisperModel

def transcribe_audio(file_path):
    # GPU 있으면 "cuda"+"float16", 없으면 "cpu"+"int8"
    model = WhisperModel("base", compute_type="int8")
    segments, _ = model.transcribe(str(file_path), vad_filter=True)
    
    lines = []
    for seg in segments:
        text = seg.text.strip()
        if text:
            # [MM:SS] 형식 타임스탬프 + 텍스트
            lines.append(f"[{format_timestamp(seg.start)}] {text}")
    return "\n".join(lines)
```

**모델 선택 가이드:**

| 모델 | 속도 | 정확도 | VRAM | 용도 |
|------|------|--------|------|------|
| `tiny` | 매우 빠름 | 낮음 | ~1GB | 빠른 테스트 |
| `base` | 빠름 | 보통 | ~1GB | **일반 사용 (추천)** |
| `small` | 보통 | 좋음 | ~2GB | 더 정확한 결과 |
| `medium` | 느림 | 높음 | ~5GB | 높은 정확도 |
| `large-v3` | 매우 느림 | 최고 | ~10GB | 최고 품질 |

**핵심 옵션:**
- `vad_filter=True`: 침묵 구간 자동 스킵 (속도↑, 노이즈↓)
- `beam_size=5`: 정확도와 속도의 균형
- GPU 자동 감지: `torch.cuda.is_available()` 체크

### Stage 3: LLM Structuring (Gemini)

```python
from google import genai

def generate_lecture_notes(transcript, api_key):
    client = genai.Client(api_key=api_key)
    prompt = """당신은 대학의 전문 노트 테이커입니다.
    
[출력 구조]
## Summary (3-5문장 요약)
## Concept Map (Mermaid 다이어그램)
## Detailed Notes (타임스탬프 유지, 주제별 헤더)
## Key Terms (용어/정의 테이블)
## Review Questions (시험 문제 3-5개)
## Action Items (실천 과제 2-3개)

[규칙]
- 원본 타임스탬프 [MM:SS]를 절대 빼지 말 것
- 타임스탬프를 지어내지 말 것
- 전사 데이터와 동일한 언어로 작성할 것

[전사 데이터]
""" + transcript
    
    response = client.models.generate_content(
        model='gemini-2.5-flash',
        contents=prompt,
    )
    return response.text
```

**프롬프트 설계 핵심:**
- "타임스탬프를 지어내지 말 것" — LLM이 없는 타임스탬프를 만들어내는 것을 방지
- Mermaid 다이어그램 노드 라벨에 특수문자가 있으면 반드시 `"쌍따옴표"` 사용
- 응답 언어를 입력 언어와 동일하게 유지

### Stage 4: Interactive HTML (Gradio + Custom JS)

```python
import markdown

def inject_interactive_buttons(md_text):
    """타임스탬프 [MM:SS]를 클릭 가능한 스크린샷 캡쳐 버튼으로 변환"""
    pattern = r'\[(\d{2}:\d{2}(?::\d{2})?)\]'
    html = markdown.markdown(md_text, extensions=['fenced_code', 'tables'])
    
    uid_counter = [0]
    def replacer(m):
        ts = m.group(1)
        uid = f"ts_{uid_counter[0]}"
        uid_counter[0] += 1
        return f"<span id='{uid}' class='hn-timestamp'>"
               f"<span class='hn-ts-badge'>[{ts}]</span>"
               f"<button onclick='triggerCapture(\"{ts}\",\"{uid}\")'>📷</button>"
               f"</span>"
    return re.sub(pattern, replacer, html)
```

**Gradio에서 Custom JS 실행하는 패턴:**

```python
CUSTOM_JS = """
<script>
function triggerCapture(ts, uid) {
    // hidden Textbox의 textarea를 찾아 값을 주입하고 input 이벤트 발생
    const el = document.querySelector('#hidden_capture_data textarea');
    el.value = ts + '|||' + uid;
    el.dispatchEvent(new Event('input', {bubbles: true}));
}
</script>
"""

# Gradio 앱 내부
hidden_input = gr.Textbox(elem_id="hidden_capture_data", visible=False)
hidden_input.change(python_handler, inputs=[...], outputs=[...])
```

**핵심 패턴:** JavaScript → hidden Textbox 값 변경 → Gradio `.change()` 이벤트 → Python 핸들러 호출

### Stage 5: Frame Extraction (FFmpeg)

```python
import subprocess, base64

def capture_frame(video_path, seconds):
    out = str(TEMP_DIR / f"frame_{int(seconds*1000)}.jpg")
    subprocess.run([
        FFMPEG_EXE, "-y",
        "-ss", str(seconds),    # 시작 시간 (초)
        "-i", str(video_path),  # 입력 파일
        "-vframes", "1",        # 1프레임만 추출
        "-q:v", "2",            # 품질 (1=최고, 31=최저)
        out
    ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    
    if os.path.exists(out):
        with open(out, "rb") as f:
            return f"data:image/jpeg;base64,{base64.b64encode(f.read()).decode()}"
    return None
```

**FFmpeg 자동 세팅 패턴:**

```python
def setup_media_tools():
    """imageio-ffmpeg에서 바이너리를 bin/ 폴더로 자동 복사"""
    bin_dir = Path("bin").absolute()
    bin_dir.mkdir(exist_ok=True)
    ffmpeg_dst = bin_dir / "ffmpeg.exe"
    
    if not ffmpeg_dst.exists():
        import imageio_ffmpeg
        src = imageio_ffmpeg.get_ffmpeg_exe()
        shutil.copy2(src, ffmpeg_dst)
    
    os.environ["PATH"] = str(bin_dir) + os.pathsep + os.environ.get("PATH", "")
```

---

## Obsidian Export Pattern

```python
from datetime import datetime

def export_to_obsidian(raw_markdown, vault_path, title):
    safe_title = re.sub(r'[\\/:*?"<>|]', '_', title)
    today = datetime.now().strftime("%Y-%m-%d")
    
    frontmatter = f"""---
title: "{safe_title}"
date: {today}
type: lecture-note
tags:
  - moonscribe
  - lecture
  - ai-generated
---

"""
    out_path = Path(vault_path) / f"{today}_{safe_title}.md"
    out_path.parent.mkdir(parents=True, exist_ok=True)
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(frontmatter + raw_markdown)
```

---

## Gradio CSS: Dark/Light Theme Survival Pattern

Gradio 6.0에서 다크/라이트 테마 토글 시 CSS가 깨지는 문제 해결법:

```css
/* 반드시 .dark 선택자를 병기하고 모든 속성에 !important */
.my-container, .dark .my-container, body.dark .my-container {
    background-color: #ffffff !important;
    color: #1a1a1a !important;
}
.my-container *, .dark .my-container * {
    color: #1a1a1a !important;
}
```

**원칙:** 노트 패널처럼 항상 흰 배경이어야 하는 영역은 `*` 와일드카드 + `.dark` 프리픽스 조합으로 완전히 격리.

---

## Mermaid Diagram Rendering in Gradio

```javascript
// CDN 로드
<script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>

// MutationObserver로 동적 콘텐츠 감지 → 자동 렌더링
const observer = new MutationObserver(() => {
    document.querySelectorAll('code.language-mermaid').forEach(block => {
        const pre = block.parentElement;
        if (!pre.dataset.rendered) {
            pre.dataset.rendered = '1';
            const div = document.createElement('div');
            div.innerHTML = '<div class="mermaid">' + block.textContent + '</div>';
            pre.replaceWith(div);
            mermaid.run({nodes: [div.querySelector('.mermaid')]});
        }
    });
});
observer.observe(container, {childList: true, subtree: true});
```

---

## Desktop Shortcut (Windows .bat)

```batch
@echo off
title Moonscribe
cd /d "%~dp0"
python -m pip install --upgrade pip -q
pip install -r requirements.txt -q
python app.py
pause
```

**주의:** `.bat` 파일에 이모지(🌕, 📝 등)를 넣으면 Windows CMD가 인코딩을 인식 못하고 깨짐. **순수 ASCII만 사용할 것.**

바로가기 생성 (PowerShell):
```powershell
$WshShell = New-Object -comObject WScript.Shell
$Desktop = [Environment]::GetFolderPath('Desktop')
$Shortcut = $WshShell.CreateShortcut("$Desktop\Moonscribe.lnk")
$Shortcut.TargetPath = "path\to\run_moonscribe.bat"
$Shortcut.WorkingDirectory = "path\to\project"
$Shortcut.Save()
```

---

## Troubleshooting

| 문제 | 원인 | 해결 |
|------|------|------|
| `[Errno 10048] port in use` | 이전 앱이 아직 실행 중 | `Ctrl+C`로 종료 후 재실행, 또는 PowerShell: `Stop-Process -Id (Get-NetTCPConnection -LocalPort 7861).OwningProcess -Force` |
| `No supported JavaScript runtime` | yt-dlp가 보호된 유튜브 영상을 처리할 때 Node.js 필요 | [nodejs.org](https://nodejs.org/) LTS 설치 |
| 흰 배경에 흰 글자 | Gradio 다크 테마가 CSS 덮어씀 | `.dark .container *` 선택자 + `!important` 사용 |
| `.bat` 파일 깨짐 (`윁?...`) | CMD가 UTF-8 이모지 미지원 | `.bat` 파일에서 이모지 제거, ASCII만 사용 |
| `ffprobe not found` | 메타데이터 읽기 실패 (핵심 기능 영향 없음) | 무시 가능, 또는 ffprobe도 bin/에 복사 |

---

## Notes

- **API 키**: Gemini API 키가 필요. [Google AI Studio](https://aistudio.google.com/)에서 무료 발급.
- **모든 처리는 로컬**: 영상/음성 데이터는 외부로 전송되지 않음 (LLM 프롬프트에 텍스트만 전송).
- **참고 프로젝트**: 원본 자막 생성기(`subtitle-generator`)에서 포크하여 진화시킨 구조.
- **실제 레포**: https://github.com/Reasonofmoon/moonscribe
