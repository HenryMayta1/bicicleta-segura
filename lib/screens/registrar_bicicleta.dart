import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/firebase_service.dart';
import '../services/storage_service.dart';

class RegistrarBicicletaScreen extends StatefulWidget {
  const RegistrarBicicletaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrarBicicletaScreenState createState() =>
      _RegistrarBicicletaScreenState();
}

class _RegistrarBicicletaScreenState extends State<RegistrarBicicletaScreen> {
  final nombreCtrl = TextEditingController();
  final modeloCtrl = TextEditingController();
  final colorCtrl = TextEditingController();
  File? imagen;
  final _firebaseService = FirebaseService();
  final _storageService = StorageService();

  Future<void> registrarBicicleta() async {
    if (imagen == null) return;
    final urlImagen = await _storageService.subirImagen(imagen!, 'bicicletas');

    final bici = {
      'id_bici': 'bici_001',
      'nombre': nombreCtrl.text,
      'modelo': modeloCtrl.text,
      'color': colorCtrl.text,
      'usuario_uid': 'uid_001',
      'imagenUrl': urlImagen,
      'estado': 'activo',
      'fecha_registro': DateTime.now(),
    };

    await _firebaseService.crearBicicleta(bici, 'bici_001');
    ScaffoldMessenger.of(
      // ignore: use_build_context_synchronously
      context,
    ).showSnackBar(SnackBar(content: Text("Bicicleta registrada")));
  }

  Future<void> seleccionarImagen() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => imagen = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Bicicleta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: modeloCtrl,
              decoration: InputDecoration(labelText: 'Modelo'),
            ),
            TextField(
              controller: colorCtrl,
              decoration: InputDecoration(labelText: 'Color'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: seleccionarImagen,
              child: Text("Seleccionar Imagen"),
            ),
            if (imagen != null) Image.file(imagen!, height: 120),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: registrarBicicleta,
              child: Text("Guardar Bicicleta"),
            ),
          ],
        ),
      ),
    );
  }
}
