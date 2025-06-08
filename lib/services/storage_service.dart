import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  Future<String> subirImagen(File archivo, String carpeta) async {
    final nombreArchivo = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance.ref().child(
      '$carpeta/$nombreArchivo.jpg',
    );
    await ref.putFile(archivo);
    return await ref.getDownloadURL();
  }
}
