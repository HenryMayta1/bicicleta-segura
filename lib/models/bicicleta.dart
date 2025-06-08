class Bicicleta {
  final String idBici;
  final String nombre;
  final String modelo;
  final String color;
  final String usuarioUid;
  final String imagenUrl;
  final String estado;

  Bicicleta({
    required this.idBici,
    required this.nombre,
    required this.modelo,
    required this.color,
    required this.usuarioUid,
    required this.imagenUrl,
    this.estado = 'activo',
  });

  Map<String, dynamic> toMap() => {
    'id_bici': idBici,
    'nombre': nombre,
    'modelo': modelo,
    'color': color,
    'usuario_uid': usuarioUid,
    'imagenUrl': imagenUrl,
    'estado': estado,
    'fecha_registro': DateTime.now(),
  };
}
