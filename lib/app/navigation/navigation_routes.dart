import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:pixels2flutter/app/navigation/transitions.dart';

import '../pages/gist/gist_screen.dart';
import '../pages/home/home_page.dart';
import 'navigation_urls.dart';

@injectable
class NavigationRoutes {
  List<RouteBase> build({
    required final GlobalKey<NavigatorState> rootNavigatorKey,
  }) {
    return [
      GoRoute(
        name: 'home',
        path: NavUrl.home,
        parentNavigatorKey: rootNavigatorKey,
        builder: (final _, final __) => const HomePage(),
        routes: [
          GoRoute(
            name: 'gist',
            path: NavUrl.gist().subrouteFrom(NavUrl.home),
            parentNavigatorKey: rootNavigatorKey,
            pageBuilder: (final _, final state) => noTransitionPage(
              state: state,
              child: GistScreen(
                gistId: state.pathParameters['gistId'] ?? '',
              ),
            ),
          ),
        ],
      ),
    ];
  }
}

extension _NavigationPathX on String {
  String subrouteFrom(final String parentRoute) {
    return replaceFirst('$parentRoute/'.replaceAll('//', '/'), '');
  }
}
