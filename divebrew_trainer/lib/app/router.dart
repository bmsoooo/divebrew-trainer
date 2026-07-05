// go_router 기반 앱 라우팅 정의 (MVP 6화면의 뼈대, 현재는 홈만 구현)
import 'package:go_router/go_router.dart';

import '../features/home/home_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
