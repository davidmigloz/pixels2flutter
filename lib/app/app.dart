import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';

import 'injection/injection.dart';

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
      color: const Color(0xFF5877F5),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4D6FF7),
          primary: const Color(0xFF4D6FF7),
          secondary: const Color(0xFF9E77ED),
          tertiary: const Color(0xFF00BBD3),
        ),
        useMaterial3: true,
      ),
    );
  }
}
