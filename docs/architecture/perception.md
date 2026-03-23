# 📡 Layer 1: Perception — 감지 신경계

> MoonWorkspace 39개 프로젝트의 변화를 **자동으로 감지**하여 상위 계층에 신호를 공급한다.

---

## 1. Project Registry

모든 프로젝트의 메타데이터를 `workspace/perception/project_registry.json`에 기록합니다.

### Schema
```json
{
  "projects": [
    {
      "name": "connectedu-3",
      "path": "F:\\MoonWorkspace\\MoonWorkspace\\projects\\connectedu-3",
      "domain": "edtech",
      "tags": ["next.js", "gemini", "education"],
      "status": "active",
      "lastCommit": "2026-03-20T15:30:00Z",
      "healthScore": 85
    }
  ],
  "lastScan": "2026-03-23T23:00:00+09:00",
  "totalProjects": 39
}
```

### Domain Classification
| Domain | Projects (예시) |
|:-------|:---------------|
| `edtech` | connectedu-3, oet-korea, kukbop-data-hak, bluel, fill-blank |
| `creative` | remo-motion-graphic, textdna, link-2-ink, poetly, lofi-video-factory |
| `agent` | darlbit-claw, claude-curri-skills, paperclip |
| `data` | fashion-secretary, sports-video-archiver, subtitle-generator |
| `prototype` | _temp_* 프로젝트들 |

---

## 2. Signal Types

| Signal | Collection Method | Meaning | Frequency |
|:-------|:-----------------|:--------|:----------|
| Git 커밋 빈도 | `git log --since="24 hours ago" --oneline` | 프로젝트 활성도 | Daily |
| 빌드 성공/실패 | `npm run build` exit code | 코드 건강도 | On-change |
| 의존성 나이 | `package.json` 분석 | 기술 부채 | Weekly |
| README 완성도 | 파일 존재여부 + 길이 | 문서 건강도 | Weekly |
| 에러 로그 패턴 | `grep -r "Error\|WARN"` | 반복 문제 | Daily |
| 디스크 사용량 | `du -sh` (node_modules 제외) | 리소스 효율 | Weekly |

---

## 3. Event Log Format

모든 감지된 이벤트는 `workspace/perception/event_log.jsonl`에 append-only로 기록됩니다.

```jsonl
{"ts":"2026-03-23T23:00:00Z","type":"commit","project":"oet-korea","detail":"3 commits today","score":1}
{"ts":"2026-03-23T23:00:00Z","type":"build_fail","project":"bluel","detail":"TS2307: Cannot find module","score":-2}
{"ts":"2026-03-23T23:00:00Z","type":"stale","project":"_temp_quote_app","detail":"No commits in 30 days","score":-1}
```

### Health Score Calculation
```
healthScore = 50 (기본)
  + (최근 7일 커밋 수 × 5)     최대 +25
  + (빌드 성공 ? +10 : -10)
  + (README 존재 ? +5 : -5)
  + (의존성 최신 비율 × 10)     최대 +10
  범위: 0 ~ 100
```

---

## 4. Output → Upper Layers

- **→ Cognition (L2)**: 활성 프로젝트 목록 + 건강 점수로 스킬 우선순위 결정
- **→ Reflection (L3)**: 에러 패턴 및 비활성 프로젝트를 Nightshift 분석 대상으로 전달
- **→ Genesis (L4)**: 도메인 간 유사성 맵을 Cross-Pollination 엔진에 공급

---
*Layer 1 | Perception | v1.0*
