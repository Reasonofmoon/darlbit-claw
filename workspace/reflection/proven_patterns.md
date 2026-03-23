# Proven Pattern Catalog

> 검증된 베스트 프랙티스 카탈로그. 성공률 95% 이상의 패턴이 여기에 등록됩니다.
> Cross-Pollination 엔진이 이 패턴들을 다른 프로젝트에 적용할 기회를 탐색합니다.

---

## Proven Patterns

### PP-001: Stripe Payment Integration Blueprint
- **Validated**: 2026-03-23
- **Projects**: oet-korea
- **Pattern**: PaymentIntent + Payment Elements + Webhook (raw body parser)
- **Stack**: Next.js App Router + Firebase Auth + Stripe
- **Reusable In**: 결제 기능이 필요한 모든 Next.js 프로젝트
- **Reference**: KI:stripe_next_firebase_integration

### PP-002: Gemini Streaming with D3.js Visualization
- **Validated**: 2026-03-23
- **Projects**: link-2-ink
- **Pattern**: 2-Phase Pipeline (Analysis → Rendering)
- **Stack**: Gemini 2.5 Pro + D3.js + TypeScript
- **Reusable In**: AI 분석 결과를 시각화하는 프로젝트
- **Reference**: KI:multimodal_ai_infographic_studio

### PP-003: Windows Agent Deployment Checklist
- **Validated**: 2026-03-23
- **Projects**: darlbit-claw
- **Pattern**: 방화벽(Private) → 좀비프로세스 정리 → systemprofile Desktop → Config 스키마 확인
- **Reusable In**: Windows 환경에서 Node.js 에이전트 배포 시
- **Reference**: Moltbot_Deployment_Log.md

---

## Template

```markdown
### PP-XXX: [제목]
- **Validated**: YYYY-MM-DD (N일 연속 에러 0)
- **Projects**: [출처 프로젝트]
- **Pattern**: [패턴 요약]
- **Stack**: [기술 스택]
- **Reusable In**: [적용 가능 대상]
- **Reference**: [참조 문서/KI]
```

---
*Last Updated: 2026-03-23*
