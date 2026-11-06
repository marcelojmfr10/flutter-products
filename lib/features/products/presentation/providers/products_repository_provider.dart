import 'package:flutter_products/features/auth/auth.dart';
import 'package:flutter_products/features/products/products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  return ProductsRepositoryImpl(
    ProductsDatasourceImpl(
      accessToken: ref.watch(authProvider).user?.token ?? '',
    ),
  );
});
