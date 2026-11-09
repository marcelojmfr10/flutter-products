import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:flutter_products/config/config.dart';
import 'package:flutter_products/features/products/products.dart';
import 'package:flutter_products/features/shared/shared.dart';

class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.isFormValid = false,
    this.id,
    this.title = const Title.dirty(''),
    this.slug = const Slug.dirty(''),
    this.price = const Price.dirty(0),
    this.sizes = const [],
    this.gender = 'men',
    this.inStock = const Stock.dirty(0),
    this.description = '',
    this.tags = '',
    this.images = const [],
  });

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }) => ProductFormState(
    isFormValid: isFormValid ?? this.isFormValid,
    id: id ?? this.id,
    title: title ?? this.title,
    slug: slug ?? this.slug,
    price: price ?? this.price,
    sizes: sizes ?? this.sizes,
    gender: gender ?? this.gender,
    inStock: inStock ?? this.inStock,
    description: description ?? this.description,
    tags: tags ?? this.tags,
    images: images ?? this.images,
  );
}

final productFormProvider = NotifierProvider.autoDispose
    .family<ProductFormNotifier, ProductFormState, Product>(
      ProductFormNotifier.new,
    );

class ProductFormNotifier extends Notifier<ProductFormState> {
  ProductFormNotifier(this.product);

  final Product product;

  Future<bool> Function(Map<String, dynamic> productLike) get _onSubmit =>
      ref.read(productsProvider.notifier).createOrUpdateProduct;

  @override
  ProductFormState build() => ProductFormState(
    id: product.id,
    title: Title.dirty(product.title),
    slug: Slug.dirty(product.slug),
    price: Price.dirty(product.price),
    inStock: Stock.dirty(product.stock),
    sizes: product.sizes,
    gender: product.gender,
    description: product.description,
    tags: product.tags.join(', '),
    images: product.images,
  );

  Future<bool> onFormSubmit() async {
    _touchedEverything();
    if (!state.isFormValid) return false;

    final productLike = {
      'id': (state.id == 'new') ? null : state.id,
      'title': state.title.value,
      'price': state.price.value,
      'description': state.description,
      'slug': state.slug.value,
      'stock': state.inStock.value,
      'sizes': state.sizes,
      'gender': state.gender,
      'tags': state.tags.split(','),
      'images': state.images
          .map(
            (image) =>
                image.replaceAll('${Environment.apiURL}/files/product/', ''),
          )
          .toList(),
    };

    try {
      return await _onSubmit(productLike);
    } catch (e) {
      return false;
    }
  }

  bool _validate({Title? title, Slug? slug, Price? price, Stock? stock}) {
    return Formz.validate([
      title ?? Title.dirty(state.title.value),
      slug ?? Slug.dirty(state.slug.value),
      price ?? Price.dirty(state.price.value),
      stock ?? Stock.dirty(state.inStock.value),
    ]);
  }

  void _touchedEverything() {
    state = state.copyWith(isFormValid: _validate());
  }

  void onTitleChanged(String value) {
    final title = Title.dirty(value);
    state = state.copyWith(
      title: title,
      isFormValid: _validate(title: title),
    );
  }

  void onSlugChanged(String value) {
    final slug = Slug.dirty(value);
    state = state.copyWith(
      slug: slug,
      isFormValid: _validate(slug: slug),
    );
  }

  void onPriceChanged(double value) {
    final price = Price.dirty(value);
    state = state.copyWith(
      price: price,
      isFormValid: _validate(price: price),
    );
  }

  void onStockChanged(int value) {
    final stock = Stock.dirty(value);
    state = state.copyWith(
      inStock: stock,
      isFormValid: _validate(stock: stock),
    );
  }

  void onSizeChanged(List<String> sizes) {
    state = state.copyWith(sizes: sizes);
  }

  void onGenderChanged(String gender) {
    state = state.copyWith(gender: gender);
  }

  void onDescriptionChanged(String description) {
    state = state.copyWith(description: description);
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(tags: tags);
  }
}
