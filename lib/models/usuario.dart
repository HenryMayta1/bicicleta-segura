class Usuario {
  final String uid;
  final String nombre;
  final String correo;
  final String telefono;
  final String imagenUrl;

  Usuario({
    required this.uid,
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.imagenUrl,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'nombre': nombre,
    'correo': correo,
    'telefono': telefono,
    'imagenUrl': imagenUrl,
    'fecha_registro': DateTime.now(),
  };
}
