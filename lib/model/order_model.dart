class OrderModel {
  List Productos;
  String fecha_creacion_pedido;
  int estado;

  OrderModel({
      required this.Productos,
      required this.fecha_creacion_pedido,
      required this.estado});

  factory OrderModel.fromJSON(Map<String, dynamic> json) {
    return OrderModel(
        Productos: json['productos'],
        fecha_creacion_pedido: json['fecha_creacion_pedido'],
        estado: json['estado']);
  }

  Map<String, dynamic> toJson() {
    return {
      'productos':Productos,
      'fecha_creacion_pedido':fecha_creacion_pedido,
      'estado':estado
    };
  }
}
