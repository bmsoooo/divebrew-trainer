// 안전 동의 상태 홀더 — 라우터 redirect가 동기적으로 참조 (시작 시 DB에서 1회 로드)
class ConsentState {
  bool consented;

  ConsentState({required this.consented});
}
