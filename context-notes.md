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

## 미해결 (착수 비차단)
- 앱 이름 최종 확정(가칭 유지 중) — M3 스토어 등록 전까지
- 음성 가이드 본인 녹음 교체 여부 — M2 테스터 피드백 후
