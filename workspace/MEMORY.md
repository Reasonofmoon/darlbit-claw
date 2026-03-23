# Moltbot Long-Term Memory

> 이 파일은 Moltbot의 장기 기억 저장소입니다.
> Nightshift가 매일 밤 추출한 교훈(Wisdom)이 여기에 축적됩니다.

---

## Axioms (불변의 법칙)

1. **보안 최우선**: API 키, 토큰은 절대 커밋하지 않는다. `.env`와 `.gitignore`로 관리한다.
2. **Windows 방화벽**: 공용 네트워크 프로필은 Long Polling을 차단한다. Telegram 연동 시 반드시 확인.
3. **좀비 프로세스**: `Stop-Process -Name node -Force`로 포트 충돌을 해결한다.
4. **systemprofile Desktop**: `C:\Windows\System32\config\systemprofile\Desktop` 폴더가 필요하다.
5. **설정 경로 정확성**: CLI config의 키 경로는 스키마를 확인해야 한다 (예: `tools.web.search.provider`).

## Lessons Learned (경험에서 배운 것)

### 2026-03
- Stripe webhook은 반드시 raw body parser를 사용해야 한다 (oet-korea)
- `git pull --rebase`로 push 충돌을 깔끔하게 해결할 수 있다 (darlbit-claw)
- Gemini 2.5 Pro가 코드 생성에서 가장 안정적이다 (connectedu-3, oet-korea)

## Project Knowledge Map

| Project | Key Insight | Date |
|:--------|:-----------|:-----|
| oet-korea | Stripe PaymentIntent + Elements 패턴 검증 완료 | 2026-03-09 |
| kukbop-data-hak | CSV 전처리 시 OCR 노이즈 제거 필수 | 2026-03-17 |
| link-2-ink | Gemini + D3.js 2-phase 파이프라인 (분석 → 렌더링) | 2026-03-09 |
| darlbit-claw | Windows 환경 에이전트 배포 4가지 트러블슈팅 완료 | 2026-03-23 |

---
*Memory Version: 1.0 | Initialized: 2026-03-23*
*Updated by: Nightshift Pipeline*
