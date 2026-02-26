class OrdersState {
  OrdersState({required this.data, required this.loading, required this.products, required this.resume});

  final List data;
  final bool loading;
  final List products;
  final List resume;

  factory OrdersState.initial() {
    return OrdersState(data: [], loading: true, products: [], resume: []);
  }

  OrdersState copyWith({List? data, bool? loading, List? products, List? resume}) {
    return OrdersState(
      resume:resume ?? this.resume,
        data: data ?? this.data, loading: loading ?? this.loading, products: products ?? this.products,);
  }
}
