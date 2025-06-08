import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmarController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  void _registrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      try {
        // 1. Crear cuenta en Firebase Auth
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: _correoController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // 2. Guardar datos adicionales en Firestore
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(cred.user!.uid)
            .set({
              'uid': cred.user!.uid,
              'nombre': _nombreController.text,
              'correo': _correoController.text,
              'telefono': _telefonoController.text,
              'imagenUrl': '',
              'fecha_registro': DateTime.now(),
            });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Cuenta creada exitosamente!')),
        );

        // 3. Redirigir al login o home
        Navigator.pushReplacementNamed(context, '/auth');
      } on FirebaseAuthException catch (e) {
        String msg = 'Error al registrar: ${e.message}';
        if (e.code == 'email-already-in-use') {
          msg = 'Este correo ya está registrado.';
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Regístrate',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 20),
                buildTextField('Nombre Completo', _nombreController),
                buildTextField(
                  'Correo Electrónico',
                  _correoController,
                  email: true,
                ),
                buildTextField('Número de Teléfono', _telefonoController),
                buildTextField(
                  'Contraseña',
                  _passwordController,
                  isPassword: true,
                ),
                buildTextField(
                  'Confirmar Contraseña',
                  _confirmarController,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registrarUsuario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size.fromHeight(40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Registrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
    bool email = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(label),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo requerido';
            }
            if (email && !value.contains('@')) {
              return 'Correo inválido';
            }
            if (label == 'Confirmar Contraseña' &&
                value != _passwordController.text) {
              return 'Las contraseñas no coinciden';
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.deepPurple.shade300,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
