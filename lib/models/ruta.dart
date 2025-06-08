import 'package:cloud_firestore/cloud_firestore.dart';

class Ruta {
  final String idRuta;
  final String descripcion;
  final DateTime fecha;
  final double lat;
  final double lng;

  Ruta({
    required this.idRuta,
    required this.descripcion,
    required this.fecha,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() => {
    'descripcion': descripcion,
    'fecha': fecha,
    'ubicacion': {'lat': lat, 'lng': lng},
  };

  factory Ruta.fromMap(Map<String, dynamic> map, String idDoc) {
    final ubicacion = map['ubicacion'] ?? {};
    return Ruta(
      idRuta: idDoc,
      descripcion: map['descripcion'] ?? '',
      fecha: (map['fecha'] as Timestamp).toDate(),
      lat: ubicacion['lat']?.toDouble() ?? 0.0,
      lng: ubicacion['lng']?.toDouble() ?? 0.0,
    );
  }
}
