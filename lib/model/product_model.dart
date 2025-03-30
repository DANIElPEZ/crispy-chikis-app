class ProductModel {
  int id;
  String nombre;
  String descripcion;
  double precio;
  String imagen;
  int tipo_producto;

  ProductModel(
      {required this.id,
        required this.nombre,
        required this.descripcion,
        required this.precio,
        required this.imagen,
        required this.tipo_producto});

  factory ProductModel.fromJSON(Map<String, dynamic> json) {
    return ProductModel(
        id: json['producto_id'],
        nombre: json['nombre'],
        descripcion: json['descripcion'],
        precio: json['precio'],
        imagen: json['imagen'],
        tipo_producto: json['tipo_producto']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'imagen': imagen,
      'tipo_producto':tipo_producto
    };
  }
}