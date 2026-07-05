// go_router 기반 앱 라우팅 정의 (MVP 6화면의 뼈대)
import 'package:go_router/go_router.dart';

import '../data/database.dart';
import '../features/home/home_screen.dart';
import '../features/session/session_screen.dart';
import '../features/tables/table_edit_screen.dart';
import '../features/tables/table_list_screen.dart';

GoRouter createRouter(AppDatabase db) => GoRouter(
      routes: [
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
