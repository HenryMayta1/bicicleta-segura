import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/storage_service.dart';
import '../services/firebase_service.dart';

class RegistrarUsuarioScreen extends StatefulWidget {
  const RegistrarUsuarioScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrarUsuarioScreenState createState() => _RegistrarUsuarioScreenState();
}

class _RegistrarUsuarioScreenState extends State<RegistrarUsuarioScreen> {
  final nombreCtrl = TextEditingController();
  final correoCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();
  File? imagen;
  final _firebaseService = FirebaseService();
  final _storageService = StorageService();

  Future<void> registrarUsuario() async {
    if (imagen == null) return;
    final urlImagen = await _storageService.subirImagen(imagen!, 'usuarios');

    final usuario = {
      'uid': 'uid_001',
      'nombre': nombreCtrl.text,
      'correo': correoCtrl.text,
      'telefono': telefonoCtrl.text,
      'imagenUrl': urlImagen,
      'fecha_registro': DateTime.now(),
    };

    await _firebaseService.crearUsuario(usuario, 'uid_001');
    ScaffoldMessenger.of(
      // ignore: use_build_context_synchronously
      context,
    ).showSnackBar(SnackBar(content: Text("Usuario registrado")));
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
      appBar: AppBar(title: Text('Registrar Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: correoCtrl,
              decoration: InputDecoration(labelText: 'Correo'),
            ),
            TextField(
              controller: telefonoCtrl,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: seleccionarImagen,
              child: Text("Seleccionar Imagen"),
            ),
            if (imagen != null) Image.file(imagen!, height: 120),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: registrarUsuario,
              child: Text("Guardar Usuario"),
            ),
          ],
        ),
      ),
    );
  }
}
