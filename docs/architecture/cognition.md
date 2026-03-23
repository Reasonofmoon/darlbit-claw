# 🧠 Layer 2: Cognition — 인지 엔진

> 97개 스킬을 **PDCA 루프** 안에서 체계적으로 실행하고, 각 스킬의 생명주기를 자동 관리한다.

---

## 1. Skill Lifecycle

```
DORMANT ──trigger──→ TRIGGERED ──exec──→ EXECUTING
   ↑                                        │
   │                                    eval result
   │                                        ↓
   └──── Skill Eval ←──── EVALUATED ←── success/fail
              │
              ↓
         EVOLVED (더 나은 버전으로 자동 업데이트)
```

### State Definitions
| State | Description | Action |
|:------|:-----------|:-------|
| `DORMANT` | 설치됨, 미사용 상태 | 30일 후 Oblivion 후보 |
| `TRIGGERED` | 사용자 또는 cron에 의해 트리거됨 | 실행 대기열 진입 |
| `EXECUTING` | 현재 실행 중 | 타임아웃 모니터링 |
| `EVALUATED` | 실행 완료, 결과 평가 중 | 메트릭 기록 |
| `EVOLVED` | 이전보다 개선된 버전으로 업데이트됨 | 변경 이력 기록 |

---

## 2. PDCA Execution Loop

모든 중요 태스크는 PDCA 사이클로 실행됩니다.

```json
{
  "cycleId": "pdca-2026-03-23-001",
  "plan": {
    "goal": "OET-Korea 결제 시스템 Stripe 연동",
    "skills": ["web_search", "coding-agent", "github"],
    "estimatedTime": "4h"
  },
  "do": {
    "startTime": "2026-03-23T14:00:00Z",
    "steps": ["API route 생성", "BuyButton 컴포넌트 구현", "Webhook 처리"],
    "status": "in_progress"
  },
  "check": {
    "gapAnalysis": "webhook 엔드포인트 미구현",
    "skillEvalScore": 0.85
  },
  "act": {
    "actions": ["webhook route 추가 구현", "에러 핸들링 보강"],
    "nextCycleId": "pdca-2026-03-23-002"
  }
}
```

---

## 3. Skill Metrics

모든 스킬 실행은 `workspace/cognition/skill_metrics.jsonl`에 기록됩니다.

```jsonl
{"ts":"2026-03-23T14:30:00Z","skill":"coding-agent","project":"oet-korea","duration":1200,"success":true,"quality":0.9}
{"ts":"2026-03-23T15:00:00Z","skill":"web_search","project":"link-2-ink","duration":30,"success":true,"quality":0.8}
{"ts":"2026-03-23T16:00:00Z","skill":"github","project":"darlbit-claw","duration":15,"success":true,"quality":1.0}
```

### Aggregated Metrics (주간)
```
Top 5 Most Used Skills:
1. coding-agent    — 42회 (성공률 91%)
2. web_search      — 38회 (성공률 97%)
3. read/write      — 35회 (성공률 100%)
4. github          — 28회 (성공률 96%)
5. summarize       — 15회 (성공률 88%)

Dormant Skills (30일+ 미사용): 12개 → Oblivion 후보
```

---

## 4. Model Parity Test

새 모델(예: Gemini 3.0)이 출시되면 자동으로 기존 스킬의 필요성을 재평가합니다.

```
For each skill in Living Grimoire:
  1. 같은 태스크를 새 모델 Baseline으로 실행
  2. 스킬 사용 시 결과와 비교
  3. IF 차이 < threshold → 스킬을 DEPRECATED로 마크
  4. ELSE → 스킬 유지, 새 모델에 맞게 EVOLVED
```

---

## 5. Output → Upper Layers

- **→ Reflection (L3)**: 실행 메트릭 + 실패 로그를 Nightshift 분석 대상으로 전달
- **→ Genesis (L4)**: 스킬 조합 패턴에서 새로운 자동화 기회 발굴

---
*Layer 2 | Cognition | v1.0*
