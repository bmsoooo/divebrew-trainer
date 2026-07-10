# CLAUDE.md — divebrew trainer (가칭)

이 파일은 두 부분으로 구성된다. **Part A**는 프로젝트 전용 규칙, **Part B**는 범용 행동 가이드라인(원본 유지). 충돌 시 Part A가 우선한다.

---

## Part A. 프로젝트 규칙

### A1. 프로젝트 개요

프리다이빙 스태틱(숨참기) 훈련 앱 "divebrew trainer"(가칭).
**플랫폼 순서: 웹앱(Flutter Web) 선행 → iOS 앱 최우선 → Apple Watch → Android 후순위.** 현재 개발 대상은 웹 타깃이며, iOS/Android 전용 코드를 미리 작성하지 않는다 (플랫폼 분기 지점만 추상화 계층으로 준비).
기획서(`docs/freedive_static_app_plan_v1.md`)와 체크리스트(`checklist.md`)가 단일 진실 공급원이다. 범위 밖 기능을 임의로 추가하지 않는다.

- 완전 무료 앱 — **IAP/구독/결제 코드 절대 작성 금지**
- MVP는 로컬 완결 — 계정·서버·클라우드 동기화 코드 금지 (Phase 4 결정 전까지)
- 소셜/피드/대회 정보 기능은 v1 범위 밖

### A2. 기술 스택 (변경 시 context-notes.md에 근거 기록 후)

| 영역 | 확정 스택 |
|---|---|
| 웹+앱 | Flutter — 웹 타깃 선행, 동일 코드베이스로 iOS(M3)·Android(M6) 승격 |
| 로컬 DB | drift — 웹(sqlite3 WASM)/앱(SQLite) 동일 API |
| 차트 | fl_chart |
| 음성 | 추상화 계층 — 웹: Web Speech API / 앱: flutter_tts (ko/en) |
| 워치 앱 | SwiftUI 네이티브 (watchOS) — Flutter 미지원이므로 예외 없음 |
| 폰↔워치 | WatchConnectivity + MethodChannel 브릿지 |
| 생체 데이터 | HealthKit (HKWorkoutSession 심박) |
| 수심·수온 | CMWaterSubmersionManager (Apple Watch Ultra, watchOS 9+) |

### A3. 플랫폼 제약 — 코드 작성 전 반드시 인지

1. **웹 단계**: 모바일 브라우저는 화면 꺼짐 시 타이머·오디오를 보장하지 못한다 → 세션 중 Wake Lock으로 화면 유지가 공식 UX. 백그라운드 동작을 웹에서 억지로 구현하려 하지 말 것.
1-2. **iOS 단계(M3)**: 세션 타이머는 화면 꺼짐·백그라운드에서 동작해야 한다 (오디오 세션 유지). 실기기 화면 꺼짐 10분 세션 완주를 통과하지 못한 타이머 구현은 완료가 아니다.
2. SpO2 실시간 측정 API는 존재하지 않는다. 구현 시도 금지 (사후 HealthKit 샘플 조회만 가능).
3. 수심·수온 자동 기록은 Ultra 전용. 일반 기기 분기 처리 필수 — 기능 미노출이 아니라 "수동 입력 경로"로 자연스럽게 폴백.
4. 워치 단독 세션은 폰 없이 완결되어야 한다 (워치 로컬 저장 → 연결 시 동기화).

### A4. 안전 요구사항 = 기능 요구사항 (임의 완화 금지)

- 온보딩 안전 동의 게이트: 미동의 시 앱 진행 불가. "드라이 전용 · 과호흡 금지 · 앉아서 땅 위에서만 · 어지러우면 즉시 중단" 4항목 포함
- 세션 실행 화면: 중단 버튼 상시 노출, 확인 팝업 없이 1탭 종료
- 준비 호흡 가이드: 분당 호흡수 상한을 상수로 고정하고 그 이상 빠른 템포 설정 UI를 제공하지 않는다 (과호흡 유도 방지)
- 안전 문구 톤: 훈계형("~하면 안 됩니다") 금지, 1인칭 경험형("저도 ~합니다") 사용
- 물속·욕조 사용을 전제로 한 기능/문구 작성 금지

### A5. 개발 워크플로

- 마일스톤(M1~M5)은 기획서 §8의 완료 판정(verify) 문장을 기준으로만 완료 처리한다
- 작업 시작 전 `checklist.md`에서 해당 항목 확인, 완료 시 체크. 새 결정은 `context-notes.md`에 즉시 append
- 실기기 검증이 필요한 항목(Wake Lock/iOS Safari 동작, 백그라운드 타이머, 햅틱, 심박, 수심)은 시뮬레이터·데스크톱 브라우저 통과만으로 완료 표시 금지 — "실기기 검증 대기" 상태로 명시
- 웹 기록은 유실 가능(브라우저 데이터 삭제) — JSON 내보내기/가져오기 기능을 M2에서 생략하지 말 것 (iOS 이관 경로)
- 테스트: 타이머 상태 머신·테이블 생성 로직·데이터 모델은 단위 테스트 필수. `flutter test` 통과 없이 done 금지

### A6. 언어·네이밍

- UI 문자열은 처음부터 l10n 구조로 (ko 기본, en 병행). 하드코딩 금지
- 파일·디렉토리·커밋 메시지 본문은 영문 파일명 + 한국어 설명 조합 가능. 소스 파일 첫 줄 한국어 역할 주석은 Part B §6 그대로 적용
- 사용자 노출 문구(안전 고지 포함)는 해요체

### A7. 자동 배포 프로세스 (Deployment Process)
앞으로 사용자가 배포를 요청할 때마다 반드시 다음 단계를 순서대로 수행한다.
1. `pubspec.yaml`의 `version` 파싱 (현재 버전 읽기)
2. Patch 버전만 1단계 올리기 (예: `1.0.x+y` → `1.0.(x+1)+y`)
3. `CHANGELOG.md` 파일에 새 버전과 배포 날짜, 그리고 변경된 내역을 기록하기
4. Git 커밋(`chore(release): v버전`), `git tag v버전` 생성 후 origin에 push 및 tag push 수행

---

## Part B. 범용 행동 가이드라인 (원본)

Behavioral guidelines to reduce common LLM coding mistakes.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

### 5. No Closing Colons (Korean Output)

**End Korean sentences with a period, not a colon.**

When the user writes in Korean, your output is also Korean:
- Don't end sentences with `:` even if the next line is a list or example.
- LLMs trained on English docs leak the colon habit into Korean. Catch it.
- The test: every Korean sentence terminator should be `.`, `?`, or `!` — not `:`.
- Colons are fine inside code, key-value pairs, or labels. Not as sentence enders.

### 6. File Header Comments in Korean

**First line of every new source file: a one-line Korean comment stating its role.**

When creating a new file:
- TypeScript/JavaScript: `// 사용자 인증 상태를 관리하는 Context Provider`
- Python: `# KIS API 호출을 비동기로 래핑하는 클라이언트`
- Dart: `// CO2 테이블 세션의 상태 머신을 관리하는 컨트롤러`
- Swift: `// 워치 세션 심박 기록을 담당하는 HKWorkoutSession 매니저`
- Place it directly under required directives (`'use client'`, shebang 등).
- Skip config files (`*.config.ts`, `pubspec.yaml`, `package.json`, etc.).

Why: agents read files selectively, not whole codebases. A one-line Korean header gives instant context so the next session (human or agent) can navigate without re-reading the entire file.

### 7. Plan + Checklist + Context Notes

**Before any non-trivial task, produce three artifacts. Don't start coding without them.**

- **Plan** — what we're building and why. (본 프로젝트: `docs/freedive_static_app_plan_v1.md`)
- **Checklist** (`checklist.md`) — concrete tasks as checkboxes. Tick as you go.
- **Context Notes** (`context-notes.md`) — decisions made during the work and the reasoning behind them. Append continuously.

If the user gives only a plan and asks you to start coding, stop and ask: "Should I create the checklist and context notes first?"

### 8. Run Tests Before Marking Complete

**If you touched code, run the tests before saying "done".**

- `flutter test`, `xcodebuild test`, whatever the target uses — run it.
- If tests pass, report results. If they fail, fix and re-run.
- No test setup? At minimum, verify the project builds/compiles.
- Run tests proactively, before the user signals "끝", "완료", "다 됐어" — not after.

This is the step LLMs skip most often. Treat it as non-negotiable.

### 9. Semantic Commits

**Commit when one logical change is complete. Don't wait for the user to ask.**

- The test: "Can I describe this commit in one sentence?" If yes, commit. If no, split.
- Good: "세션 타이머 상태 머신 추가". Bad: "타이머 추가하고 UI도 고치고 버그도 수정" (split into 3).
- Don't accumulate 20 unrelated edits and lose the ability to roll back individually.

### 10. Read Errors, Don't Guess

**Read the actual error/log line. Don't pattern-match from memory.**

When something fails:
- Read the full error message and stack trace.
- Check the actual log output, not what you assume it should say.
- Don't apply a "common fix" before confirming the cause.
- If unclear, add a print/log to verify state — then fix.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.
