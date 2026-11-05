import 'package:flutter/material.dart';
import 'package:flutter_products/config/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  await Environment.initEnvironment();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
