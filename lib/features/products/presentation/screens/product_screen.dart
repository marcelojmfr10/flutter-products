import 'package:flutter/material.dart';
import 'package:flutter_products/features/products/presentation/providers/product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductScreen extends ConsumerStatefulWidget {
  final String productId;
  const new({super.key, required this.productId});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(productProvider(widget.productId).notifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Producto')),
      body: Center(child: Text(widget.productId)),
    );
  }
}
