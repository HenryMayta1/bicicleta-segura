import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ruta.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> crearUsuario(Map<String, dynamic> data, String uid) async {
    await _db.collection('usuarios').doc(uid).set(data);
  }

  Future<void> crearBicicleta(Map<String, dynamic> data, String idBici) async {
    await _db.collection('bicicletas').doc(idBici).set(data);
  }

  Future<void> agregarAlerta(String idBici, Map<String, dynamic> alerta) async {
    await _db
        .collection('bicicletas')
        .doc(idBici)
        .collection('alertas')
        .add(alerta);
  }

  Future<void> guardarRuta(Ruta ruta, String idBici) async {
    await _db
        .collection('bicicletas')
        .doc(idBici)
        .collection('rutas')
        .doc(ruta.idRuta)
        .set(ruta.toMap());
  }

  Stream<List<Ruta>> obtenerRutas(String idBici) {
    return _db
        .collection('bicicletas')
        .doc(idBici)
        .collection('rutas')
        .orderBy('fecha', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Ruta.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }
}
