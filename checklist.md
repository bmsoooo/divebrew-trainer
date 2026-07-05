# 체크리스트 — divebrew trainer (가칭)

> 기획서 v1.2 기준 (웹 선행 → iOS → 워치 → 다이브 로그 → Android 후순위). 개발 착수 전 M0 항목부터 순서대로. 완료 시 체크.

## M0. 기획 확정
- [x] 기획서 검토 및 확정 — v1.2 (웹 선행, 가칭 divebrew trainer)
- [x] 확정 — 수익화(무료) / Ultra(보유) / 개발 주체(Claude Code) / 앱 이름(가칭)
- [ ] 안전 고지 카피 초안 작성 (온보딩 동의문 + 세션 리마인더 로테이션 문구)
- [ ] "divebrew trainer" 스토어·상표 중복 확인 (M3 전까지)

## M1. 웹 MVP 코어 (Flutter Web)
- [x] Flutter 프로젝트 셋업 (웹 타깃 우선, drift WASM, 라우팅) — flutter test·build web 통과 (2026-07-05)
- [ ] 데이터 모델 구현 → verify: 모델 단위 테스트 통과
- [ ] CO2/O2 프리셋 테이블 + 커스텀 편집 화면 → verify: 라운드 추가/삭제/저장 테스트
- [ ] PB 기반 테이블 자동 생성 로직 → verify: PB 입력값별 산출 테스트
- [ ] 세션 타이머 엔진 (준비→홀드→회복 상태 머신) → verify: 상태 전이 단위 테스트
- [ ] 음성 가이드 추상화 계층 + 웹 구현(Web Speech API, 한/영) → verify: iOS Safari·Android Chrome 재생 확인
- [ ] Wake Lock 세션 중 화면 유지 → verify: iOS Safari에서 10분 세션 동안 화면 꺼지지 않음
- [ ] 컨트랙션 탭 기록 → verify: 세션 결과에 타임스탬프 저장 확인
- [ ] 세션 완료·기록 저장 → verify: 브라우저 새로고침·재방문 후 히스토리 유지

## M2. 웹 MVP 마감·배포
- [ ] 온보딩 + 안전 동의 게이트 → verify: 미동의 시 진행 불가
- [ ] 세션 시작 안전 리마인더 로테이션
- [ ] 히스토리 목록 + PB 추이 그래프 (fl_chart)
- [ ] 기록 JSON 내보내기/가져오기 (iOS 전환 시 이관 경로) → verify: 내보낸 파일 재가져오기 왕복 테스트
- [ ] PWA 매니페스트 + 홈 화면 추가 동작 확인
- [ ] 다국어 (ko/en)
- [ ] 정적 호스팅 배포 (URL 공유 가능 상태)
- [ ] 테스터 5인 1주 사용 → 피드백 반영 (변경은 한 번에 변수 1개 원칙)

## M3. iOS 앱 출시
- [ ] iOS 타깃 활성화 + 플랫폼 분기 (TTS→flutter_tts, DB→SQLite)
- [ ] 백그라운드 타이머 (오디오 세션 유지) → verify: 실기기 화면 꺼짐 10분 세션 완주 ★최우선 검증
- [ ] 웹 기록 JSON 가져오기 → verify: 웹에서 내보낸 기록이 앱 히스토리에 표시
- [ ] 앱 아이콘·스크린샷·스토어 문구 (안전 고지 포함) — 앱 이름 최종 확정
- [ ] 개인정보처리방침 (건강 데이터 미수집 명시 — 로컬 저장)
- [ ] App Store 심사 제출 → 통과

## M4. Apple Watch 컴패니언 (iOS 출시 후)
- [ ] watchOS 타깃 추가 (SwiftUI) + WatchConnectivity 브릿지
- [ ] 워치 단독 세션 실행 (테이블 선택 → 타이머) → verify: 폰 없이 1세션 완주
- [ ] 햅틱 패턴 4종 설계·구현 → verify: 눈 감고 단계 구분 가능한지 테스터 확인
- [ ] HKWorkoutSession 심박 기록 → verify: 세션 심박 시계열 저장
- [ ] 워치→폰 동기화 + 심박 차트 → verify: 라운드 오버레이 차트 렌더링

## M5. 다이브 로그
- [ ] 수동 다이브 로그 입력 폼 (30초 내 입력 목표) + 통합 타임라인
- [ ] (Ultra) CMWaterSubmersionManager 자동 캡처 → verify: 실측 1회 수심·수온 기록

## M6. Android 출시 (후순위 — 착수 여부 별도 결정)
- [ ] Android 타깃 QA (Foreground Service 백그라운드 타이머, Doze 대응)
- [ ] Play Store 심사 제출 → 통과
- [ ] Health Connect 심박 조회 검토
