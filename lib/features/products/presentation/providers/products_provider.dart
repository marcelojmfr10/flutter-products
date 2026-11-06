import 'package:flutter_products/features/products/products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  new({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Product>? products,
  }) => ProductsState(
    isLastPage: isLastPage ?? this.isLastPage,
    limit: limit ?? this.limit,
    offset: offset ?? this.offset,
    isLoading: isLoading ?? this.isLoading,
    products: products ?? this.products,
  );
}

final productsProvider = NotifierProvider<ProductsNotifier, ProductsState>(
  ProductsNotifier.new,
);

class ProductsNotifier extends Notifier<ProductsState> {
  ProductsRepository get productsRepository =>
      ref.read(productsRepositoryProvider);

  @override
  ProductsState build() {
    Future.microtask(loadNextPage);
    return ProductsState();
  }

  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    final products = await productsRepository.getProductsByPage(
      limit: state.limit,
      offset: state.offset,
    );

    if (products.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPage: true);
      return;
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      products: [...state.products, ...products],
    );
  }
}
