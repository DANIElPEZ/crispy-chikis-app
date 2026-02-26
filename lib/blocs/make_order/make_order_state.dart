class MakeOrderState {
  MakeOrderState({required this.totalWithoutIva,
    required this.total,
    required this.iva,
    required this.filteredProducts,
    required this.isMaked,
    required this.productsOrder,
    required this.orderError,
    required this.loading,
    required this.products});

  final double total;
  final double iva;
  final double totalWithoutIva;
  final bool isMaked;
  final bool loading;
  final bool orderError;
  final List products;
  final List productsOrder;
  final List filteredProducts;

  factory MakeOrderState.initial() {
    return MakeOrderState(
        filteredProducts: [],
        productsOrder: [],
        loading: true,
        totalWithoutIva: 0,
        orderError: false,
        total: 0,
        iva: 0,
        isMaked: false,
        products: []);
  }

  MakeOrderState copyWith({
    double? total,
    double? iva,
    double? totalWithoutIva,
    List? filteredProducts,
    bool? isMaked,
    bool? loading,
    bool? orderError,
    List? products,
    List? productsOrder
  }) {
    return MakeOrderState(
        productsOrder: productsOrder ?? this.productsOrder,
        totalWithoutIva: totalWithoutIva ?? this.totalWithoutIva,
        total: total ?? this.total,
        loading: loading ?? this.loading,
        orderError: orderError?? this.orderError,
        iva: iva ?? this.iva,
        filteredProducts: filteredProducts ?? this.filteredProducts,
        isMaked: isMaked ?? this.isMaked,
        products: products ?? this.products);
  }
}
