# 🪞 Layer 3: Reflection — 반성 엔진 (Oblivion Chamber 2.0)

> 매일 밤 **Nightshift**가 자동 실행되어 실패와 성공을 분석하고, 교훈을 추출하여 시스템을 자가 정화한다.

---

## 1. Nightshift Pipeline

매일 23:00에 자동 트리거되는 반성 사이클.

```
23:00 ──→ [1] COLLECT
              │ Perception 이벤트 로그 수집
              │ Cognition 스킬 메트릭 수집
              │ 오늘의 Git diff 요약
              ▼
         [2] ANALYZE
              │ 반복 실패 패턴 감지
              │ 성공 패턴 추출
              │ 미사용 리소스 식별
              ▼
         [3] DECIDE (Oblivion Decision)
              │ 정리할 것: anti_patterns.md에 등록
              │ 보존할 것: proven_patterns.md에 등록
              │ 아카이빙: oblivion_archive/에 이동
              ▼
         [4] EXTRACT WISDOM
              │ 교훈을 Zettelkasten 원자 노트로 변환
              │ QMD 인덱스에 추가
              ▼
         [5] REPORT
              │ nightshift_log_YYYY-MM-DD.md 생성
              │ 내일 아침 브리핑 준비
              ▼
00:30 ──→ Complete ✨
```

---

## 2. Nightshift Log Format

```markdown
# 🌙 Nightshift Log — 2026-03-23

## Today's Vital Signs
- **Active Projects**: 8/39
- **Commits Today**: 14 (oet-korea: 5, link-2-ink: 4, darlbit-claw: 3, bluel: 2)
- **Skills Used**: 23 executions, 21 successful (91.3%)
- **Build Failures**: 1 (bluel — TS2307)

## 🔴 Anti-Patterns Detected
1. **[REPEAT-3]** `bluel` 프로젝트에서 `TS2307: Cannot find module` 에러가 3일 연속 발생
   - 원인 추정: `tsconfig.json`의 paths 설정 미스매치
   - 조치 제안: baseUrl 및 paths 재설정

## 🟢 Proven Patterns Confirmed
1. `oet-korea`의 Stripe 결제 패턴이 안정적 (5일 연속 에러 0)
   - → `proven_patterns.md`에 "Stripe Integration Blueprint" 등록

## 🟡 Oblivion Candidates
1. `_temp_quote_app` — 45일간 미활동 → 아카이빙 권고
2. `manga-gong-bang-temp` — 38일간 미활동 → 아카이빙 권고

## 💎 Wisdom Extracted
- "Stripe webhook은 반드시 raw body parser를 사용해야 한다" → Zettelkasten 등록

## 📋 Tomorrow's Briefing
- [ ] bluel TS2307 에러 해결 (우선순위 HIGH)
- [ ] darlbit-claw Nightshift 스킬 검증
- [ ] 주간 Genesis 리포트 준비 (일요일)
```

---

## 3. Oblivion Chamber 2.0 Rules

| Condition | Action | Severity |
|:----------|:-------|:---------|
| 30일간 미사용 스킬 | `DORMANT` 마크 + 이유 기록 | 🟡 Low |
| 3회 연속 동일 실패 | `anti_patterns.md`에 등록 + 텔레그램 경고 | 🔴 High |
| 동일 에러 5회 반복 | **선제 경고** 자동 발동 + 해결책 탐색 | 🔴 Critical |
| 성공률 95%+ (10회 이상) | `proven_patterns.md`에 등록 | 🟢 Positive |
| 45일간 프로젝트 미활동 | 아카이빙 제안 (삭제 아님) | 🟡 Low |

### Anti-Pattern Catalog Structure
```markdown
## AP-001: TypeScript Module Resolution Failure
- **First Seen**: 2026-03-21
- **Frequency**: 3 occurrences
- **Projects**: bluel, connectedu-3
- **Root Cause**: tsconfig.json paths 미설정
- **Fix**: baseUrl을 "./src"로 설정, paths에 별칭 추가
- **Status**: ACTIVE
```

### Proven Pattern Structure
```markdown
## PP-001: Stripe Payment Integration Blueprint
- **Validated**: 2026-03-23 (5일 연속 에러 0)
- **Projects**: oet-korea
- **Pattern**: PaymentIntent + Elements + Webhook (raw body)
- **Reusable In**: 결제 기능이 필요한 모든 Next.js 프로젝트
- **Reference**: KI:stripe_next_firebase_integration
```

---

## 4. Output → Upper Layers

- **→ Genesis (L4)**: Proven Pattern들이 Cross-Pollination 엔진의 "재사용 가능 패턴 풀" 공급
- **→ Perception (L1)**: Oblivion 결정이 project_registry의 상태 업데이트에 반영
- **→ User**: Nightshift 로그 요약이 매일 아침 텔레그램 브리핑으로 발송

---
*Layer 3 | Reflection | v1.0*
