# 🔮 Layer 4: Genesis — 창발 엔진

> **아이디어가 자동으로 샘솟는 구조.** 연결되지 않은 것들 사이에서 새로운 것을 만들어낸다.

---

## 1. Three Genesis Mechanisms

### 1-1. 🐝 Cross-Pollination Engine (교차 수분)

프로젝트 간 **숨겨진 연결**을 자동 발견합니다.

```
Input:
  project_registry.json (39개 프로젝트)
  proven_patterns.md (검증된 패턴)
  skill_metrics.jsonl (스킬 사용 이력)
      ↓
Analysis:
  1. 도메인 간 기술 스택 겹침 탐색 (예: Next.js를 쓰는 EdTech 프로젝트들)
  2. 한 프로젝트에서 해결된 문제가 다른 프로젝트에도 존재하는지 탐색
  3. 성공한 스킬 조합을 다른 컨텍스트에 적용 가능한지 평가
      ↓
Output:
  💡 Insight Card → workspace/genesis/insights/
```

**Insight Card Format:**
```markdown
## INS-2026-03-23-001: Stripe Blueprint → Bluel 적용 가능성

- **Source**: oet-korea (PP-001: Stripe Payment Integration)
- **Target**: bluel (현재 결제 미구현)
- **Confidence**: 0.87
- **Rationale**: 두 프로젝트 모두 Next.js App Router + Firebase 사용.
  oet-korea의 결제 패턴을 bluel에 그대로 이식 가능.
- **Action**: "bluel에 Stripe 결제 추가" 태스크 생성 권고
- **Status**: PROPOSED
```

### 1-2. 🎲 Serendipity Engine (우연한 발견)

외부 세계에서 **의미 있는 우연**을 포착합니다.

```
Input:
  web_search (GitHub Trending, Hacker News, EdTech 블로그)
  RSS feeds (구독 중인 기술 블로그)
  bird/twitter (키워드 모니터링)
      ↓
Analysis:
  1. 외부 도구/기술/논문 수집
  2. QMD 벡터 유사도로 내 프로젝트와 관련성 측정
  3. 관련성 점수 > threshold → Opportunity Card 생성
      ↓
Output:
  🌟 Opportunity Card → workspace/genesis/opportunities/
```

**Opportunity Card Format:**
```markdown
## OPP-2026-03-23-001: Vercel AI SDK 4.0 출시

- **Source**: GitHub Trending (vercel/ai)
- **Relevance Score**: 0.92
- **Related Projects**: connectedu-3, oet-korea, bluel
- **Opportunity**: 현재 수동으로 구현한 Gemini streaming을
  Vercel AI SDK로 교체하면 코드 50% 감소 예상
- **Effort**: Medium (각 프로젝트 2-3시간)
- **Status**: DISCOVERED
```

### 1-3. 🔬 Synthesis Engine (주간 통합 창작)

매주 일요일 밤, 한 주의 모든 인사이트를 **통합 분석**합니다.

```
Input:
  이번 주의 모든 Insight Cards
  이번 주의 모든 Opportunity Cards
  이번 주의 Nightshift 로그 7개
  이번 주의 skill_metrics 통계
      ↓
Synthesis:
  1. 반복적으로 등장한 주제 클러스터링
  2. 가장 높은 영향력의 아이디어 3개 선정
  3. 각 아이디어에 대한 실행 가능성 평가
      ↓
Output:
  🌕 Weekly Genesis Report → workspace/genesis/weekly_reports/
  📢 텔레그램 발송: "이번 주의 3대 아이디어"
```

---

## 2. Weekly Genesis Report Format

```markdown
# 🌕 Weekly Genesis Report — Week 12, 2026

## 🏆 Top 3 Ideas This Week

### 1. 🎯 "EdTech 결제 통합 프레임워크" (Confidence: 0.91)
oet-korea의 검증된 Stripe 패턴을 bluel과 connectedu-3에 일괄 적용.
3개 프로젝트에서 개별 구현하는 대신, 공유 라이브러리로 추출.
- **Impact**: High | **Effort**: Medium | **Source**: INS-001 + PP-001

### 2. 💡 "AI 음성 피드백 시스템" (Confidence: 0.78)
kukbop-data-hak의 영어 문장 데이터 + Whisper + TTS를 결합하여
학생에게 발음 교정 피드백을 제공하는 모듈.
- **Impact**: High | **Effort**: High | **Source**: OPP-003 + Recipe #104

### 3. 🔧 "_temp 프로젝트 졸업식" (Confidence: 0.95)
5개 _temp 프로젝트 중 2개는 발전 가능성 높음 (studymap, math_teacher).
나머지 3개는 아카이빙하여 workspace 정리.
- **Impact**: Medium | **Effort**: Low | **Source**: Nightshift AP-005

## 📊 Week Summary
- Insights Generated: 7
- Opportunities Found: 4
- Anti-Patterns Resolved: 2
- Skills Evolved: 3
- Projects Touched: 12/39
```

---

## 3. Idea Backlog

모든 아이디어는 `workspace/genesis/idea_backlog.md`에 우선순위와 함께 축적됩니다.

```markdown
# 💡 Idea Backlog

## Priority: HIGH ⭐
- [ ] EdTech 결제 통합 프레임워크 (INS-001, Week 12)
- [ ] Motion Graphic 자동 생성 파이프라인 (INS-003, Week 11)

## Priority: MEDIUM
- [ ] AI 음성 피드백 시스템 (OPP-003, Week 12)
- [ ] 프로젝트 간 공유 컴포넌트 라이브러리 (INS-005, Week 10)

## Priority: LOW
- [ ] Lofi 비디오 + Suno 앨범 자동 통합 (OPP-007, Week 9)

## Archived (Rejected/Completed)
- [x] Stripe 결제 기본 연동 (INS-002, Week 8) → oet-korea에 구현 완료
```

---

## 4. Feedback Loop

Genesis의 결과는 하위 Layer들에 다시 영향을 줍니다.

```
Genesis Idea → User Approval → Cognition (PDCA Cycle 생성)
                                    ↓
                              Perception (새 프로젝트 또는 변경 감지)
                                    ↓
                              Reflection (결과 평가 및 반성)
                                    ↓
                              Genesis (다음 주기에 반영)
```

**완전한 자가 학습 순환 달성** 🔄

---
*Layer 4 | Genesis | v1.0*
