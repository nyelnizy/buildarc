import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ardennes/features/drawings_catalog/drawings_catalog_event.dart'
as dc_event;
import 'package:ardennes/features/drawings_catalog/drawings_catalog_view.dart';
import 'package:ardennes/features/home_screen/view.dart';
import 'package:ardennes/injection.dart';
import 'package:ardennes/libraries/account_context/bloc.dart';
import 'package:ardennes/libraries/account_context/event.dart' as ac_event;
import 'auth_screen.dart';
import 'features/drawing_detail/drawing_detail_bloc.dart';
import 'features/drawing_detail/drawing_detail_view.dart';
import 'features/drawings_catalog/drawings_catalog_bloc.dart';

import 'features/drawing_detail/drawing_detail_event.dart' as dd_event;
import 'main_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();
final _drawingCatalogNavigatorKey = GlobalKey<NavigatorState>();

var router = GoRouter(
  // https://pub.dev/documentation/go_router/latest/go_router/ShellRoute-class.html
  // To display a child route on a different Navigator,
  // provide it with a parentNavigatorKey that matches the key provided
  // to either the GoRouter or ShellRoute constructor.
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MultiBlocProvider(providers: [
          BlocProvider<DrawingsCatalogBloc>(create: (BuildContext context) {
            return getIt<DrawingsCatalogBloc>()..add(dc_event.InitEvent());
          }),
          BlocProvider<AccountContextBloc>(
              create: (BuildContext context) =>
              getIt<AccountContextBloc>()..add(ac_event.InitEvent()))
        ], child: MainScreen(navigationShell: navigationShell));
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _drawingCatalogNavigatorKey,
          routes: [
            GoRoute(
                path: '/drawings',
                builder: (context, state) => const DrawingsCatalogScreen(),
                routes: [
                  GoRoute(
                    path: 'sheet',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final number = state.uri.queryParameters['number'] ?? '';
                      final collection =
                          state.uri.queryParameters['collection'] ?? '';
                      final projectId =
                          state.uri.queryParameters['projectId'] ?? '';
                      final versionId = int.tryParse(
                          state.uri.queryParameters['versionId'] ?? '') ??
                          0;
                      return MultiBlocProvider(
                          providers: [
                            BlocProvider<DrawingsCatalogBloc>(
                                create: (BuildContext context) {
                                  return getIt<DrawingsCatalogBloc>();
                                }),
                            BlocProvider<AccountContextBloc>(
                                create: (BuildContext context) =>
                                getIt<AccountContextBloc>()
                                  ..add(ac_event.InitEvent())),
                            BlocProvider<DrawingDetailBloc>(
                              create: (BuildContext context) =>
                              getIt<DrawingDetailBloc>()
                                ..add(dd_event.LoadSheet(
                                    number: number,
                                    collection: collection,
                                    versionId: versionId,
                                    projectId: projectId)),
                            )
                          ],
                          child: DrawingDetailScreen(
                              number: number,
                              collection: collection,
                              projectId: projectId,
                              versionId: versionId));
                    },
                  ),
                ]),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/signin',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/',
      redirect: (BuildContext context, GoRouterState state) async {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          return '/drawings';
        } else {
          return '/signin';
        }
      },
    ),

    // Other routes...
  ],
);