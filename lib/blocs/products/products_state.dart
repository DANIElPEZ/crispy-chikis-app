class ProductsState {
  ProductsState(
      {required this.userExist, required this.products, required this.filteredProducts, required this.comments, required this.loading, required this.canOrder});

  final List products;
  final List filteredProducts;
  final bool loading;
  final List comments;
  final bool canOrder;
  final bool userExist;

  factory ProductsState.initial() {
    return ProductsState(products: [], comments:[], filteredProducts: [], loading: true, canOrder: false, userExist: false);
  }

  ProductsState copyWith({List? products, List? comments, List? filteredProducts, bool? loading, bool? canOrder, bool? userExist}) {
    return ProductsState(
        canOrder: canOrder ?? this.canOrder,
        products: products ?? this.products,
        filteredProducts: filteredProducts ?? this.filteredProducts,
        comments: comments ?? this.comments,
        userExist:userExist ?? this.userExist,
        loading: loading ?? this.loading);
  }
}
