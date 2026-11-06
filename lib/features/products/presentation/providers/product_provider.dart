import 'package:flutter_products/features/products/products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    required this.id,
    this.product,
    this.isLoading = true,
    this.isSaving = false,
  });

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) => ProductState(
    id: id ?? this.id,
    product: product ?? this.product,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
  );
}

final productProvider = NotifierProvider.autoDispose
    .family<ProductNotifier, ProductState, String>(ProductNotifier.new);

class ProductNotifier extends Notifier<ProductState> {
  ProductNotifier(this.productId);

  final String productId;

  ProductsRepository get productsRepository =>
      ref.read(productsRepositoryProvider);

  @override
  ProductState build() {
    Future.microtask(loadProduct);
    return ProductState(id: productId);
  }

  Future<void> loadProduct() async {
    try {
      final product = await productsRepository.getProductById(state.id);

      state = state.copyWith(isLoading: false, product: product);
    } catch (e) {
      print(e);
    }
  }
}
