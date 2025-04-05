class CommentModel {
  String nombre, descripcion;
  double puntuacion;

  CommentModel({
      required this.nombre,
      required this.descripcion,
      required this.puntuacion});

  factory CommentModel.fromJSON(Map<String, dynamic> json) {
    return CommentModel(
        nombre: json['nombre_user'],
        descripcion: json['descripcion'],
        puntuacion: json['puntuacion']);
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre_user': nombre,
      'descripcion': descripcion,
      'puntuacion': puntuacion
    };
  }
}
