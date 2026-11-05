import 'package:flutter_products/features/auth/auth.dart';
import 'package:flutter_products/features/products/products.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const CheckAuthStatusScreen(),
    ),

    ///* Auth Routes
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    ///* Product Routes
    GoRoute(path: '/', builder: (context, state) => const ProductsScreen()),
  ],

  ///! TODO: Bloquear si no se está autenticado de alguna manera
);
