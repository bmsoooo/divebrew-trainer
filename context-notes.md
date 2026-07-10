# Context Notes — 프리다이빙 스태틱 훈련 앱

> 결정 사항과 그 근거를 시간순으로 기록. 다음 세션(사람/에이전트)이 재추론 없이 이어받기 위한 문서.

## 2026-07-04 — 기획 v1.0 수립

**D1. 폰 앱은 Flutter, 워치 앱은 SwiftUI 네이티브로 분리**
- 근거: Flutter/React Native 모두 watchOS 미지원. 워치 앱은 어떤 스택을 골라도 네이티브 필수 → 폰 쪽만 크로스플랫폼으로 비용 절감.
- 기각한 대안: 네이티브 2벌(iOS Swift + Android Kotlin) — 1인/소규모 개발에 유지비 2배. KMP — 워치 문제를 해결해주지 않으면서 생태계가 상대적으로 얇음.

**D2. 수심·수온 자동 기록은 Apple Watch Ultra 전용 기능으로 격리**
- 근거: 수심 센서(CMWaterSubmersionManager, watchOS 9+, 최대 40m)는 Ultra 계열에만 탑재. 일반 워치·안드로이드는 하드웨어가 없음.
- 결정: 수동 로그를 기본 경로로, 자동 캡처는 Phase 3의 프리미엄 경험으로 설계. "전 기기 지원"처럼 오해될 문구 금지.

**D3. SpO2 실시간 차트는 MVP에서 제외**
- 근거: 애플워치 SpO2는 서드파티 실시간 API가 없음 (사후 HealthKit 샘플 조회만 가능). 경쟁 앱의 실시간 SpO2는 외부 BLE 옥시미터 연동으로 추정.
- 결정: 심박수(HKWorkoutSession) 중심으로 설계. BLE 옥시미터 지원은 Phase 4 검토 항목.

**D4. MVP는 계정·클라우드 없이 로컬 완결**
- 근거: 단순함 우선(CLAUDE.md §2). 훈련 앱의 핵심 가치 검증에 서버는 불필요하고, 건강 데이터 미수집이 개인정보 요건도 단순화함.
- 후속: 다기기 동기화 수요가 확인되면 Phase 4에서 Supabase/Firebase 비교.

**D5. 소셜 피드·대회 정보 기능은 v1 범위에서 의도적 배제**
- 근거: 경쟁 앱(Freediving Ai Trainer)이 이미 제공하는 영역이고, 훈련 코어 경험과 독립적. 범위 확장은 검증 후.

**D6. 안전 설계를 기능 요구사항으로 승격**
- 근거: 스태틱 훈련은 과호흡 후 숨참기 → 블랙아웃 위험이 실재하는 카테고리. 텍스트 고지가 아닌 UX 구조(동의 게이트, 세션 리마인더, 1탭 중단, 호흡 템포 상한)로 내장.
- 톤: 훈계형이 아닌 1인칭 경험형 — divebrew 브랜드 안전 원칙과 동일 철학 적용.

**D7. 음성 가이드는 TTS로 시작**
- 근거: MVP 검증 속도. 본인 목소리 녹음은 브랜드 자산화 기회이므로 미결 사항(§9-5)으로 운영자에게 이관.

## 2026-07-04 — 운영자 결정 3건 확정

**D8. 개발 주체 = Claude Code 직접 개발**
- 근거: 운영자 답변. 프로젝트 루트에 CLAUDE.md(일반 행동 가이드라인 + 프로젝트 규칙 병합본) 배치. 마일스톤 단위로 checklist.md를 세분화하고, 세션마다 context-notes.md에 결정을 누적하는 방식으로 운용.

**D9. Apple Watch Ultra 보유 확인**
- Phase 3(수심·수온 자동 기록)의 실기기 검증 경로 확보. 로드맵 변경 없음.

**D10. 수익화 = 완전 무료**
- 결제/구독(IAP) 모듈 전면 제거. 프리미엄 격벽 없음 → 기능 접근 제어 로직 불필요, 아키텍처 단순화. 스토어 심사도 단순해짐.

## 2026-07-04 — 플랫폼 순서·앱 이름 확정 (기획 v1.2)

**D11. 앱 이름 가칭 = divebrew trainer**
- divebrew 브랜드 확장 라인으로 확정. 스토어 등록(M3) 전 최종 확정 + 상표·스토어 중복 확인.

**D12. 플랫폼 순서 = 웹앱 선행 → iOS 최우선 → Android 후순위**
- 근거: 운영자 결정. 웹으로 빠르게 코어(테이블·타이머·기록) 검증 후 iOS를 첫 네이티브 타깃으로.
- 기술 선택: Flutter Web으로 선행 개발 — 동일 코드베이스가 iOS/Android까지 커버하므로 재작성 비용 0에 수렴. React 웹앱 대안은 iOS 단계 재작성 비용 때문에 기각.
- 수용한 웹 제약: 모바일 브라우저는 화면 꺼짐 시 타이머 보장 불가 → Wake Lock으로 화면 유지가 웹 UX 전제. 백그라운드 완전 동작·HealthKit·워치·수심은 전부 iOS 이후 단계로 이동.
- 데이터 이관: 웹 로컬 저장(브라우저 삭제 시 유실 리스크) 대비 JSON 내보내기/가져오기를 M2 필수 항목으로 — iOS 전환 시 사용자 기록 이관 경로.
- 음성 가이드는 추상화 계층 하나 두고 웹(Web Speech API)/앱(flutter_tts) 분기.

## 2026-07-04 — M1 착수: Flutter 환경 구축

**D13. Flutter 3.38.10 stable 고정 (최신 3.44.4 아님)**
- 근거: 개발 Mac이 macOS 13.6 — Flutter 3.41+(Dart 3.11+)의 VM은 macOS 14 이상을 요구해 실행 불가. macOS 13에서 도는 마지막 stable이 3.38.10(Dart 3.10.9)임을 독립 Dart SDK 실행 테스트로 확인.
- 설치 경로: `~/development/flutter` (zip 직접 설치 — Homebrew cask는 이 환경에서 오류). PATH는 `~/.zshrc`에 추가.
- 영향: 이후 패키지 버전은 Dart 3.10.9 제약으로 해석됨. macOS 업그레이드 전까지 Flutter 업그레이드 금지.

**D14. dart pub 네트워크 명령은 샌드박스 없이 + 시간 제한 필수**
- 증상: 샌드박스 환경에서 `flutter pub get`이 "Downloading packages..."에서 에러 없이 무한 대기 (3.5시간 멈춤 사고의 원인). curl은 정상이었으므로 dart HTTP 클라이언트만 차단된 상태였음.
- 운용 규칙: 네트워크를 쓰는 dart·flutter 명령은 (1) 샌드박스 비활성으로 실행, (2) 60~120초 안에 진행 없으면 kill 후 진단. 마냥 기다리지 않는다.

- 프로젝트 위치: `divebrew_trainer/` (프로젝트 루트 하위, `--platforms web --org com.divebrew`)

## 2026-07-05 — GitHub 연결 + dart HTTP hang 우회 확립

**D15. 이 개발 머신에서 dart HTTP 클라이언트는 신뢰 불가 — curl 프리페치 + `pub get --offline`이 공식 우회 경로**
- 증상: 샌드박스 여부와 무관하게 `pub get`(및 `--example` 하위 호출, sqlite3 훅 다운로드 등) dart HTTP를 쓰는 모든 다운로드가 소켓 0개·CPU 0% 상태로 무한 대기. curl은 항상 정상.
- 우회 절차: ① `curl https://pub.dev/api/archives/<pkg>-<ver>.tar.gz` 다운로드 → ② `~/.pub-cache/hosted/pub.dev/<pkg>-<ver>/`에 압축 해제 → ③ sha256을 `~/.pub-cache/hosted-hashes/pub.dev/<pkg>-<ver>.sha256`에 **줄바꿈 없이**(printf '%s') 기록 → ④ `flutter pub get --offline`.
- 주의: 해시 파일에 trailing newline이 있으면 "wrong hash - redownloading" 오류.
- hang된 `dart pub ... --example` 좀비 프로세스가 남으니 발견 시 kill.

**D16. sqlite3 3.x 네이티브 훅 = pubspec `hooks.user_defines.sqlite3.source: system`으로 다운로드 회피**
- drift 2.34 → sqlite3 ^3.1.5는 빌드 훅으로 GitHub에서 바이너리를 받는데 D15 증상으로 hang. `source: system` 지정 시 macOS 시스템 libsqlite3를 dlopen (dyld 공유 캐시라 ls로는 안 보여도 정상 로드).
- build_runner는 Dart 3.10에서 훅 있는 의존성의 AOT 컴파일 불가 → `--force-jit` 필수.

**D17. GitHub 저장소 연결 (2026-07-05)**
- `bmsoooo/divebrew-trainer` (public), gh CLI 인증 완료. 루트 `.gitignore`로 `.claude/settings.local.json`·`.DS_Store` 제외.

**D18. 데이터 모델 = M1 웹 범위 3종만 (TrainingTable/Session/PersonalBest)**
- DiveLog는 M5, heartRateSeries는 M4에서 추가 — 웹 단계 선행 구현 금지 원칙(A1) 적용.
- rounds/results는 JSON 문자열 컬럼 + drift TypeConverter (라운드 수 가변이라 정규화 테이블보다 단순). 컨트랙션은 홀드 시작 기준 ms 오프셋 리스트.
- PB는 type을 PK로 종류별 1건 upsert.

**D19. 프리셋 6종 초기값은 임시 — 운영자(프리다이버) 튜닝 대상**
- CO2 입문 45s 홀드 6R / 중급 90s 8R / 상급 120s 8R (준비 호흡 10s씩 점감), O2는 준비 120s 고정에 홀드 점증. 구조 규칙(CO2 홀드 고정·호흡 점감, O2 호흡 고정·홀드 점증)은 테스트로 고정, 수치는 `lib/data/presets.dart`에서 수정.
- 프리셋은 목록에서 편집 진입 불가(isPreset), 시드는 멱등.

**D20. l10n은 gen-l10n 직접 출력 방식 (lib/l10n/ 생성, synthetic package 아님)**
- Flutter 3.38에서 `flutter_gen` synthetic import 대신 `lib/l10n/app_localizations.dart` 상대 import. 생성 파일 3개는 커밋 대상.
- 상태 관리 패키지 없이 AppDatabase를 생성자 주입 (테스트에서 인메모리 교체 용이). 필요해지기 전까지 provider류 도입하지 않음.

**D21. M1 코드 항목 전체 구현 완료 + 데스크톱 브라우저 스모크 통과 (2026-07-05)**
- 실브라우저(데스크톱 Chrome)에서 확인: drift WASM 시드·조회, 라우팅, l10n(ko), 세션 타이머 카운트다운, 새로고침 후 목록 유지.
- 남은 M1 검증: 음성 가이드·Wake Lock **iOS Safari 실기기 검증 대기** (M2 배포 URL로 확인 예정). 마일스톤 M1 최종 verify(모바일 브라우저 1세션 완주)도 동일 시점.
- 음성/Wake Lock은 SessionScreen에 생성자 주입 — 테스트는 fake로 검증.

**D22. M2 구현 완료 + GitHub Pages 배포 (2026-07-05)**
- 배포 URL: https://bmsoooo.github.io/divebrew-trainer/ (gh-pages 브랜치, base-href /divebrew-trainer/). 배포 절차: `flutter build web --base-href "/divebrew-trainer/"` → build/web을 gh-pages에 force push.
- Pages는 COOP/COEP 헤더가 없어 drift가 IndexedDB 스토리지로 폴백 — 기록 유지에 문제 없음.
- 디자인 시스템 적용: Deep Ocean(#0A2342)/Espresso(#3C2A21)/Snorkel Yellow(#FFC300), Pretendard 4웨이트(assets/fonts, OFL), 그라데이션 금지, 문구는 1인칭 경험형 해요체.
- fl_chart 1.2.0 — D15 curl 프리페치로 설치. drift watch()를 쓰는 위젯 테스트는 종료 전 `pumpWidget(SizedBox()) + pump(1s)`로 keep-alive 타이머 소진 필수 (안 하면 "Timer still pending" 실패).
- 남은 실기기 검증(아이폰 Safari에서 배포 URL로): 음성 가이드 재생, Wake Lock 10분, PWA 홈 화면 추가, M1 마일스톤 verify(1세션 완주+새로고침 기록 유지).
- 웹 배포처 = GitHub Pages로 결정 (미해결 항목 해소).

## 2026-07-06 — 테이블 상세 화면 + 세션 일시정지/재개 + 라운드 타임라인

**D23. 사용자 피드백 반영: 탭→즉시 시작 대신 상세 미리보기, 뒤로가기 버튼, 일시정지 기능**
- 근거: 배포 URL 사용 피드백 — (1) 뒤로가기 버튼 없음, (2) 테이블 탭 시 확인 없이 바로 세션 시작, (3) 세션 중 일시정지 없음, (4) 라운드별 진행 상황을 미리·실행 중 모두 보고 싶음.
- 네비게이션을 `context.go()`(위치 교체) → `context.push()`(스택 쌓기)로 전환 — go_router push 시 Scaffold AppBar가 시스템 뒤로가기 화살표를 자동으로 그림(별도 구현 불필요). 최상위(`/`, `/history`, `/onboarding`)만 go 유지.
- 새 흐름: 테이블 목록 탭 → `TableDetailScreen`(라운드 미리보기 + 총 시간 + "시작하기" 버튼) → 세션 화면. 세션은 여전히 진입 즉시 자동 시작(추가 확인 탭 없음) — "시작하기" 버튼 자체가 명시적 확인 단계.
- `SessionEngine`에 `paused` phase 추가. `isRunning`(타이머 흐름 여부)과 `isActive`(세션 종료 안 됨, paused 포함) getter를 분리 — 화면은 `isActive`로 결과화면 전환 여부를 판단. `stop()`은 `isActive` 기준으로 동작 변경(일시정지 중에도 안전 중단 가능해야 함, A4).
- `RoundTimeline` 공용 위젯 신설(`lib/features/tables/round_timeline.dart`) — 완료(✓ 실제시간)/진행중(▶ 강조)/예정(○ 흐림) 3상태를 아이콘+텍스트로. 텍스트 라벨 없이 아이콘 위주 설계(안전 카피 원칙과 별개로 단순함 우선). 테이블 상세(전부 예정)와 세션 실행 화면(실시간 상태) 양쪽에서 재사용.
- 일시정지 시 타이머는 `cancel()`, 재개 시 새 `Timer.periodic` 시작(틱 스킵 방식 대신) — WakeLock은 일시정지 중에도 유지(화면은 계속 보고 있으므로), 음성은 `stop()`으로 끊음.

## 2026-07-06 — Claude Design 핸드오프 UI/UX 전면 적용

**D24. 디자인 핸드오프(`Dive breath training app.zip`)를 5개 화면에 반영**
- 출처: 운영자가 Claude Design에서 생성한 고정밀 핸드오프(HTML 프로토타입 + 토큰 + 스크린샷 5장 + README 스펙). `design-system/`은 브랜드 3색을 앱용으로 확장한 값.
- 수심 팔레트 확정(theme.dart): Abyss #061527 / Deep Ocean #0A2342 / Mid-water #12325C / Mist #B8C7D9 / Foam #F2F6FA + Snorkel Yellow 악센트. Espresso는 UI에서 제외(브루잉 콘텐츠 전용).
- "깊이 스테이징": 홈/테이블/히스토리=Deep Ocean, 상세=Mid-water, 세션=Abyss. 화면이 깊어질수록 배경이 어두워짐.
- 타이포 3역할: Display(타이머·PB, ExtraBold 800 + tabular figures), Body, Utility(칩·라벨 SemiBold+자간). Pretendard-ExtraBold.otf(weight 800) 추가.
- 시그니처 `DiveProfileLine`(CustomPaint): 라운드를 다이브컴퓨터 수심 그래프로. 홀드=하강(최대 홀드 대비 비율), 호흡=수면 복귀. 상세=풀 프로파일(옐로+트로프 도트), 세션=미니(Mist 40% + 옐로 플레이헤드, engine.progress 기반). 기존 RoundTimeline은 이걸로 대체·삭제.
- 라우터: `StatefulShellRoute.indexedStack`로 하단 탭(홈/테이블/히스토리) 셸 도입. 상세·세션·편집은 rootNavigator로 전체화면 push(탭바 없음). 세션 화면은 탭바 없이 몰입.
- 홈: 인사말+PB카드(옐로 세로바 악센트)+오늘의 훈련 제안(지난 세션과 다른 타입 추천). 세션 카운트/최근 타입으로 제안 로직.
- 세션: 88px 타이머, 펄스 도트(연속 애니메이션은 pumpAndSettle과 충돌 → 틱 토글 Opacity로 구현), 컨트랙션 카운터 뱃지, 하단 안전 리마인더 상시 1줄.
- 주의: drift `watch()`를 쓰는 위젯 테스트는 종료 전 `pumpWidget(SizedBox())+pump(1s)`로 keep-alive 타이머 소진 필수(기존 D22와 동일).
- 테스트 69건 유지·통과. 문구는 핸드오프 카피(1인칭 해요체) 채택.

## 2026-07-06 — 설정 화면(6번째) 추가 + 데이터 관리 액션 실제 동작

**D25. 설정 탭 추가 — 하단 탭 4개(홈/테이블/히스토리/설정), 기존 5화면 미변경**
- 핸드오프(`Dive breath/divebrew training`)의 6번째 화면. README 스펙 그대로: 인스타 링크 카드 + 데이터 관리 그룹 카드 + 앱 정보 그룹 카드. 배경은 Deep Ocean(깊이 스테이징에서 홈과 같은 층 — 설정은 "더 깊이" 흐름 아님).
- 프로토타입에선 데이터 액션이 inert였지만, 운영자 요청대로 **실제 동작**하게 구현:
  - `restoreDefaultTables` — 프리셋 라운드를 seed 기본값으로 되돌림(이름 매칭, 커스텀·기록 미변경, 참조 무결성 유지). 프리셋이 편집 불가라 사실상 멱등이지만 삭제된 프리셋 복구 포함.
  - `clearHistory` — 세션+PB만 삭제, 테이블 유지.
  - `resetAll` — 세션·PB·모든 테이블 삭제 후 프리셋 재시드. 안전 동의(Settings 테이블)는 유지 → 재온보딩 강제 안 함.
  - 세 함수 모두 `presets.dart`에 배치(database.dart와 순환 import 회피, seedPresetsIfEmpty 재사용). 파괴적 액션은 SettingsScreen에서 확인 다이얼로그 필수.
- 링크 열기: `link_launcher.dart` 조건부 import(웹=window.open 새 탭, 비웹=no-op 스텁, M3에서 url_launcher). 인스타·문의가 이걸 사용.
- 오픈소스 라이선스 = Flutter 내장 `showLicensePage()`. 개인정보처리방침·이용약관 = 앱 내 `LegalPage`(정적 텍스트, 로컬 저장·건강데이터 미수집·드라이 전용 안전 고지 반영 — M3 개인정보처리방침 초안 겸용).
- 버전 문자열 `_appVersion = '1.0.0 (1)'`은 pubspec `1.0.0+1`과 수동 동기화(package_info_plus 미도입 — 의존성 최소화).
- 테스트: 데이터 관리 단위 7건 + 설정 화면 위젯 4건(확인 다이얼로그 게이트 검증). 전체 유지.

## 2026-07-06 — 훈련 가이드 화면 + 홈 화면 아이콘 여백 수정

**D26. 훈련 가이드(교육 콘텐츠) 신설 — 진입점 2곳(홈 카드 + 설정 행)**
- 운영자 요청: 초보자 가이드, CO2/O2 테이블 설명, 왜 숨참기가 느는지. 배치는 판단에 위임됨.
- 배치 결정: 다이빙 흐름과 분리된 별도 전체화면(`/guide`, Deep Ocean 배경). 진입점 = 홈 화면 하단 아웃라인 카드(신규 사용자 발견성) + 설정 상단 행(상시 접근). 탭바에는 추가 안 함(4탭 유지, 가이드는 참조 콘텐츠).
- 5개 섹션(GuideScreen): 스태틱이란 / CO2 테이블 / O2 테이블 / 왜 늘어나는지 / 안전(옐로 강조 카드). 생리학 설명은 정확하게: 숨참기 한계는 산소가 아니라 CO2 축적 신호(air hunger) → CO2 테이블=회복 단축으로 CO2 내성, O2 테이블=홀드 연장으로 저산소 적응, 증가 원리 3가지(CO2 내성/이완/저산소 적응). 안전 섹션은 과호흡 금지·블랙아웃 위험을 명시해 앱 안전 원칙(A4)과 일관.
- 문구 1인칭 해요체, l10n(ko/en) 양쪽. 개인정보처리방침/이용약관과 같은 정적 텍스트 패턴.

**D27. PWA 아이콘 흰 여백 제거 — 원형 크롭을 Deep Ocean 정사각형에 합성**
- 증상: 아이콘이 원형+투명 모서리(hasAlpha)라 iOS 홈 화면 추가 시 모서리가 흰색으로 보임.
- 해결: `youtube-profile-800x800.png`(원형 소스)를 Deep Ocean(#0A2342) 불투명 정사각형 위에 합성 → 모서리가 네이비로 채워짐. maskable은 사진을 14% 확대해 safe zone까지 채움. 도구는 Node `jimp`(PIL/ImageMagick 부재, npm은 dart hang과 무관). 스크립트: scratchpad/composite.js.
- 정사각형 풀블리드 원본이 없어 색 채우기로 처리 — 네이티브 앱 아이콘(M3)은 풀블리드 이미지로 재제작 권장.

## 2026-07-06 — 단발 스테틱 + 3→2→1 카운트다운 + 자격증 사진

**D28. 홈 = 단발 스테틱 중심으로 재편, 홈 PB = 스테틱 최고 기록**
- 요청: CO2/O2 테이블 시작 시 3→2→1 카운트다운, 홈 PB는 테이블이 아닌 단발성 스테틱 기록, 홈에 스테틱 시작 메뉴, 카드 문구는 동기부여형("오늘도 나의 PB를 갱신해보세요").
- 홈 카드를 "오늘의 훈련 제안"(테이블) → "단발 스테틱" 카드로 교체(→ /static). 홈 PB 카드는 `personalBests` where type=static_만 표시. 하단 CTA는 /tables(테이블 목록)로.
- 홈이 카드가 늘어 짧은 화면에서 오버플로우 → 콘텐츠를 ListView로 감싸고 CTA만 하단 고정.

**D29. 단발 스테틱 = 열린 숨참기(카운트업), static_ 시드 테이블에 귀속**
- `presets.dart`에 `staticPreset`(name '단발 스테틱', type static_) 추가 → 시드 대상이 6→7개. 테이블 목록엔 노출 안 함(custom 섹션은 type==custom만). `findStaticTable(db)`로 세션이 참조할 테이블 조회.
- StaticSessionScreen: 카운트다운 → 카운트업 타이머(열린 숨참기, 무제한) → "완료" 1탭 종료 → static_ PB 갱신 + 결과(새 PB 여부). saveSession(type static_)이 PB upsert.
- FK 유지 위해 별도 스키마 변경 없이 static_ 시드 테이블 tableId 사용(nullable 마이그레이션 회피).

**D30. 3→2→1 카운트다운 — 세션 시작 전 공용, 주입 가능**
- SessionScreen·StaticSessionScreen에 `countdownSeconds`(기본 3, 테스트는 0으로 건너뜀) 파라미터. CountdownView 공용 위젯. 시드 테이블 추가·카운트다운 도입으로 기존 테스트 다수 갱신(시드 count 6→7, 세션 테스트에 countdownSeconds:0).
- 주의: _beginSession에서 초기 preparing 단계는 음성 안내 안 함(기존 동작 유지, 전환 시에만).

**D31. 내 자격증 사진 — 로컬 저장(다이빙 센터 제시용)**
- 홈 상단 우측 badge 아이콘 → /license. 업로드/보기/교체/삭제. base64로 Settings 테이블(key licenseImageBase64)에 저장, Image.memory로 렌더. 웹 이미지 선택은 `image_picker.dart` 조건부 import(FileReader.readAsArrayBuffer). 비웹 스텁은 M3에서 image_picker로 교체.

## 2026-07-06 — 단발 스테틱 흐름 변경: 상세 화면 + 준비 호흡 1분

**D32. 단발 스테틱도 테이블처럼 상세 화면 경유, 시작 시 준비 호흡 60초 추가**
- 요청: 홈 스테틱 카드 → 바로 카운트다운 ❌ → 상세 화면 → "시작하기" → 카운트다운. 그리고 카운트다운 뒤 준비 호흡 1분 → 실제 스테틱.
- 라우팅: `/static` = StaticDetailScreen(상세, 설명+시작하기), `/static/run` = StaticSessionScreen(세션). 홈 카드는 /static 유지(이제 상세로 감).
- StaticSessionScreen 단계: countdown(3→2→1) → preparing(준비 호흡 60초 카운트다운, "지금 참기 시작"으로 건너뛰기 가능) → holding(열린 숨참기 카운트업) → done. `_StaticPhase` enum으로 관리.
- 파라미터: `countdownSeconds`(기본 3), `prepSeconds`(기본 60). 테스트는 0으로 각 단계 건너뜀. 준비 호흡 상수 = 60초, 과호흡 유도 UI 없음(A4 준수 — 템포 설정 없이 고정).
- 준비 중 하단 버튼은 "중단"(pop 복귀), 숨참기 중엔 "완료"(기록). 준비 중 음성 voiceBreathe, 숨참기 시작 voiceHoldStart.

## 2026-07-09 — 설정 개선: 문의 이메일 + 법률 문서 규정 준수

**D33. 문의 = divebrew@gmail.com (mailto), 설정 행에 이메일 상시 표시**
- 문의 행이 인스타 링크였던 것을 mailto:divebrew@gmail.com(제목 프리필)으로 교체. mailto가 동작하지 않는 환경 대비 trailing에 이메일 주소를 항상 노출.

**D34. 개인정보처리방침·이용약관을 개인정보 보호법 제30조 목차로 전면 재작성**
- 근거 확인: 법 제30조 필수 기재사항(처리 목적/보유 기간/제3자 제공/위탁·국외이전/파기/정보주체 권리/자동수집장치/안전성 확보조치/보호책임자 연락처/변경 고지) + 개인정보 미수집 로컬 앱 실제 사례("기기 외 별도 보유하지 않음" 명시 관행).
- 처리방침 v2: 제1~10조 + 부칙(시행일 2026-07-09). 미수집·로컬 저장 명시, GitHub Pages 호스팅의 접속 로그(IP) 가능성 정직 고지, 파기=앱 내 삭제 경로 안내, 정보주체 권리=열람(히스토리)/이동(JSON 내보내기)/삭제, KISA 118 안내, 보호책임자 이메일.
- 이용약관 v2: 제1~9조 + 부칙. 안전 고지(제5조: 드라이 전용·과호흡 금지·블랙아웃 위험·의료기기 아님)를 독립 조항으로 격상, 데이터 백업 책임(제6조), 면책(제8조), 준거법=대한민국(제9조). 문체는 A6 규칙대로 해요체 유지(법정 문체 요구 없음).
- 필수 항목 포함 여부를 테스트로 고정(test/features/legal_test.dart) — 문서 수정 시 항목 누락을 CI에서 잡음.
- LegalPage: 조 제목(제n조/Article n/부칙/핵심 요약) 볼드+여백 렌더링으로 가독성 개선.

**D35. 오픈소스 라이선스 페이지 보완 — 수동 번들 자산 등록**
- showLicensePage(LicenseRegistry) 방식은 실제 업계 표준이라 유지. 누락돼 있던 수동 번들 자산 2건을 main에서 LicenseRegistry.addLicense로 등록: Pretendard(SIL OFL 1.1 전문), sqlite3.wasm(SQLite public domain 고지). drift_worker.js 등 패키지 유래 자산은 패키지 라이선스로 자동 커버.

## 미해결 (착수 비차단)
- 다이빙 컨디션 위젯의 기본 포인트는 서귀포이며, 포항·부산으로 전환 가능하게 구현 중 (2026-07-10). 실제 입수 포인트와 모델 격자가 다를 수 있으므로 예보는 참고용이며 현장·버디 확인을 대체하지 않는다는 고지를 유지한다.
- 앱 이름 최종 확정(가칭 유지 중) — M3 스토어 등록 전까지
- 음성 가이드 본인 녹음 교체 여부 — M2 테스터 피드백 후
