// go_router 기반 앱 라우팅 정의 — 안전 미동의 시 온보딩으로 강제 리다이렉트 (A4)
import 'package:go_router/go_router.dart';

import '../data/database.dart';
import '../features/history/history_screen.dart';
import '../features/home/home_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/session/session_screen.dart';
import '../features/tables/table_detail_screen.dart';
import '../features/tables/table_edit_screen.dart';
import '../features/tables/table_list_screen.dart';
import 'consent_state.dart';

GoRouter createRouter(AppDatabase db, ConsentState consent) => GoRouter(
      redirect: (context, state) {
        final atOnboarding = state.matchedLocation == '/onboarding';
        if (!consent.consented && !atOnboarding) return '/onboarding';
        if (consent.consented && atOnboarding) return '/';
        return null;
      },
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) =>
              OnboardingScreen(db: db, consent: consent),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/history',
          builder: (context, state) => HistoryScreen(db: db),
        ),
        GoRoute(
          path: '/tables',
          builder: (context, state) => TableListScreen(db: db),
        ),
        // 정적 세그먼트(new, edit/:id)는 동적 :id 라우트보다 먼저 선언해 우선 매칭한다.
        GoRoute(
          path: '/tables/new',
          builder: (context, state) => TableEditScreen(db: db),
        ),
        GoRoute(
          path: '/tables/edit/:id',
          builder: (context, state) => TableEditScreen(
            db: db,
            tableId: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/tables/:id',
          builder: (context, state) => TableDetailScreen(
            db: db,
            tableId: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/session/:tableId',
          builder: (context, state) => SessionScreen(
            db: db,
            tableId: int.parse(state.pathParameters['tableId']!),
          ),
        ),
      ],
    );
