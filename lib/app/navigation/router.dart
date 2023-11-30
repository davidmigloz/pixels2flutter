import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import 'navigation_routes.dart';
import 'navigation_urls.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

@injectable
class RouterFactory {
  RouterFactory(this.navigationRoutes);

  final NavigationRoutes navigationRoutes;

  GoRouter build() {
    GoRouter.optionURLReflectsImperativeAPIs = true;
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      routes: navigationRoutes.build(rootNavigatorKey: _rootNavigatorKey),
      debugLogDiagnostics: true,
      initialLocation: NavUrl.home,
    );
  }
}
