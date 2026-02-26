abstract class ProductEvent{}

class loadProducts extends ProductEvent{}

class loadCommentsByProduct extends ProductEvent{
  loadCommentsByProduct(this.id);
  final int id;
}

class searchProduct extends ProductEvent{
  searchProduct(this.query);
  final String query;
}

class canOrder extends ProductEvent{}