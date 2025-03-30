class OrderModel {
  List productos;
  String precio;
  String fecha;
  int estado;

  OrderModel(
      { required this.productos,
        required this.precio,
        required this.fecha,
        required this.estado});

  factory OrderModel.fromJSON(Map<String, dynamic> json) {
    return OrderModel(
        productos: json['productos'],
        precio: json['precio'],
        fecha: json['fecha'],
        estado: json['estado']);
  }

  Map<String, dynamic> toJson() {
    return {
      'productos': productos,
      'precio': precio,
      'fecha': fecha,
      'estado':estado
    };
  }
}