// go_router 기반 앱 라우팅 정의 — 안전 미동의 시 온보딩으로 강제 리다이렉트 (A4)
import 'package:go_router/go_router.dart';

import '../data/database.dart';
import '../features/home/home_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/session/session_screen.dart';
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
          path: '/tables',
          builder: (context, state) => TableListScreen(db: db),
        ),
        GoRoute(
          path: '/tables/new',
          builder: (context, state) => TableEditScreen(db: db),
        ),
        GoRoute(
          path: '/session/:tableId',
          builder: (context, state) => SessionScreen(
            db: db,
            tableId: int.parse(state.pathParameters['tableId']!),
          ),
        ),
        GoRoute(
          path: '/tables/edit/:id',
          builder: (context, state) => TableEditScreen(
            db: db,
            tableId: int.parse(state.pathParameters['id']!),
          ),
        ),
      ],
    );
