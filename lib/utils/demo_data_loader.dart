import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ruta.dart';
import '../services/firebase_service.dart';

class DemoDataLoader {
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> agregarRutasADocumentos() async {
    final bicis =
        await FirebaseFirestore.instance.collection('bicicletas').get();

    for (final doc in bicis.docs) {
      final idBici = doc.id;

      for (int i = 0; i < 5; i++) {
        final ruta = Ruta(
          idRuta: 'ruta_${i + 1}_${DateTime.now().millisecondsSinceEpoch}',
          descripcion: 'Ruta auto $i para $idBici',
          fecha: DateTime.now().subtract(Duration(minutes: i * 10)),
          lat: -16.5 + i * 0.001,
          lng: -68.15 + i * 0.001,
        );

        await _firebaseService.guardarRuta(ruta, idBici);
      }

      print('✅ Rutas añadidas a bicicleta: $idBici');
    }
  }
}
