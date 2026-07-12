// go_router 라우팅 — 하단 탭 셸(홈/테이블/히스토리) + 상세·세션은 전체화면 push, 미동의 시 온보딩 강제 (A4)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/database.dart';
import '../features/guide/guide_screen.dart';
import '../features/history/history_screen.dart';
import '../features/home/home_screen.dart';
import '../features/logbook/logbook_edit_screen.dart';
import '../features/logbook/logbook_screen.dart';
import '../features/license/license_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/session/session_screen.dart';
import '../features/session/static_detail_screen.dart';
import '../features/session/static_session_screen.dart';
import '../features/settings/legal_page.dart';
import '../features/settings/settings_screen.dart';
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
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/logbook',
                builder: (context, state) => LogbookScreen(db: db),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => SettingsScreen(db: db),
              ),
            ]),
          ],
        ),
        // 훈련 가이드 — 전체화면 push (홈·설정에서 진입, 탭바 없음).
        GoRoute(
          path: '/guide',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const GuideScreen(),
        ),
        // 설정 하위 상세 페이지 — 전체화면 push (탭바 없음).
        GoRoute(
          path: '/settings/privacy',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            return LegalPage(
                title: l10n.settingsPrivacy, body: l10n.privacyBody);
          },
        ),
        GoRoute(
          path: '/settings/terms',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            return LegalPage(title: l10n.settingsTerms, body: l10n.termsBody);
          },
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
        GoRoute(
          path: '/static',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const StaticDetailScreen(),
        ),
        GoRoute(
          path: '/static/run',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => StaticSessionScreen(db: db),
        ),
        GoRoute(
          path: '/license',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => LicenseScreen(db: db),
        ),
        GoRoute(
          path: '/logbook/new',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => LogbookEditScreen(db: db),
        ),
        GoRoute(
          path: '/logbook/edit/:id',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => LogbookEditScreen(
            db: db,
            sessionId: int.parse(state.pathParameters['id']!),
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
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: l10n.tabLogbook,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.tabSettings,
          ),
        ],
      ),
    );
  }
}
