abstract class MakeOrderEvent{}

class MakeOrder extends MakeOrderEvent{
  MakeOrder({required this.direccion, required this.aditional_description, required this.metodoPago});
  final String direccion;
  final String metodoPago;
  final String aditional_description;
}

class AddProduct extends MakeOrderEvent{
  AddProduct({required this.id, required this.price, required this.title});
  final int id;
  final String title;
  final double price;
}

class DeleteProduct extends MakeOrderEvent{
  DeleteProduct({required this.id});
  final int id;
}

class searchProduct extends MakeOrderEvent{
  searchProduct(this.query);
  final String query;
}

class CalculateTotal extends MakeOrderEvent{}

class loadProducts extends MakeOrderEvent{}