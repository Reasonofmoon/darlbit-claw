# 🌕 Reflective Intelligence: 4-Layer Cognitive Architecture

> **Mission**: Darlbit-Claw는 단순한 CLI 에이전트가 아닌, MoonWorkspace 전체를 관통하는 **자가 학습 반성적 지능(Reflective Intelligence)** 중추 신경계이다.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                   🔮 GENESIS (Layer 4)                          │
│         Cross-Pollination · Serendipity · Synthesis             │
│              → idea_backlog.md, weekly_reports/                 │
├─────────────────────────────────────────────────────────────────┤
│                   🪞 REFLECTION (Layer 3)                       │
│         Nightshift · Oblivion Chamber 2.0 · Pattern Catalog     │
│          → nightshift_logs/, anti_patterns.md, proven_patterns  │
├─────────────────────────────────────────────────────────────────┤
│                   🧠 COGNITION (Layer 2)                        │
│         PDCA Loop · Skill Lifecycle · Skill Evals               │
│            → skill_metrics.jsonl, active_pdca_cycles.json       │
├─────────────────────────────────────────────────────────────────┤
│                   📡 PERCEPTION (Layer 1)                       │
│         Git Monitor · Build Health · Dependency Audit           │
│           → project_registry.json, event_log.jsonl              │
└─────────────────────────────────────────────────────────────────┘
                              ↕
              ┌───────────────────────────────┐
              │  MoonWorkspace (39 Projects)  │
              └───────────────────────────────┘
```

## Data Flow

```
Perception (감지)
    │ project_registry.json
    │ event_log.jsonl
    ▼
Cognition (실행)
    │ skill_metrics.jsonl
    │ PDCA cycles
    ▼
Reflection (반성)  ←── 매일 23:00 Nightshift 트리거
    │ anti_patterns.md
    │ proven_patterns.md
    ▼
Genesis (창발)     ←── 매주 일요일 Synthesis 트리거
    │ insights/
    │ weekly_reports/
    ▼
💡 아이디어 · 경고 · 제안 → Telegram / Dashboard
```

## Layer Documents

| Layer | Document | Purpose |
|:------|:---------|:--------|
| L1 | [perception.md](./perception.md) | MoonWorkspace 변화 감지 신경계 |
| L2 | [cognition.md](./cognition.md) | 스킬 실행 및 PDCA 인지 엔진 |
| L3 | [reflection.md](./reflection.md) | Nightshift 반성 및 Oblivion 2.0 |
| L4 | [genesis.md](./genesis.md) | 창발 엔진 — 아이디어가 샘솟는 구조 |

## Integration Points

- **Paperclip**: Control Plane으로 L2 Cognition의 태스크를 관리
- **Zettelkasten/QMD**: L3 Reflection의 Wisdom Extraction 결과 저장
- **Telegram**: L4 Genesis의 인사이트 및 주간 리포트 발송
- **Dashboard (index.html)**: 전 Layer의 실시간 상태 시각화

---
*Architecture Version: 1.0 | 2026-03-23*
