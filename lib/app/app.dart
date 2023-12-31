import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';

import 'injection/injection.dart';
import 'theme/theme.dart';

Future<void> runApplication() async {
  usePathUrlStrategy();
  registerDependencies();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return MaterialApp.router(
      routerConfig: getIt<GoRouter>(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
    );
  }
}
