import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../pages/gist/gist_screen.dart';
import '../pages/home/home_screen.dart';
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
        builder: (final _, final __) => const HomeScreen(),
        routes: [
          GoRoute(
            name: 'gist',
            path: NavUrl.gist().subrouteFrom(NavUrl.home),
            parentNavigatorKey: rootNavigatorKey,
            builder: (final _, final state) => GistScreen(
              gistId: state.pathParameters['gistId'] ?? '',
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
