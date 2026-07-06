// go_router 라우팅 — 하단 탭 셸(홈/테이블/히스토리) + 상세·세션은 전체화면 push, 미동의 시 온보딩 강제 (A4)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/database.dart';
import '../features/history/history_screen.dart';
import '../features/home/home_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/session/session_screen.dart';
import '../features/tables/table_detail_screen.dart';
import '../features/tables/table_edit_screen.dart';
import '../features/tables/table_list_screen.dart';
import '../l10n/app_localizations.dart';
import 'consent_state.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(AppDatabase db, ConsentState consent) => GoRouter(
      navigatorKey: _rootNavigatorKey,
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
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => _TabShell(shell: shell),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => HomeScreen(db: db),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/tables',
                builder: (context, state) => TableListScreen(db: db),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => HistoryScreen(db: db),
              ),
            ]),
          ],
        ),
        // 전체화면 push 라우트 — 탭바 없음. 정적 세그먼트가 :id보다 먼저.
        GoRoute(
          path: '/tables/new',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => TableEditScreen(db: db),
        ),
        GoRoute(
          path: '/tables/edit/:id',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => TableEditScreen(
            db: db,
            tableId: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/tables/:id',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => TableDetailScreen(
            db: db,
            tableId: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/session/:tableId',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => SessionScreen(
            db: db,
            tableId: int.parse(state.pathParameters['tableId']!),
          ),
        ),
      ],
    );

/// 하단 탭 셸 — 홈/테이블/히스토리.
class _TabShell extends StatelessWidget {
  final StatefulNavigationShell shell;

  const _TabShell({required this.shell});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(
          i,
          initialLocation: i == shell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.tabHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.list_alt_outlined),
            selectedIcon: const Icon(Icons.list_alt),
            label: l10n.tabTables,
          ),
          NavigationDestination(
            icon: const Icon(Icons.schedule_outlined),
            selectedIcon: const Icon(Icons.schedule),
            label: l10n.tabHistory,
          ),
        ],
      ),
    );
  }
}
