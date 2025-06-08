import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyBikesScreen extends StatelessWidget {
  const MyBikesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bicicleta segura'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('bicicletas')
                .where('uid', isEqualTo: uid)
                .snapshots(),
        builder: (context, snapshot) {
          // Mientras espera datos
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Si hay error
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar las bicicletas.'));
          }

          // Si no hay bicicletas registradas
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No tienes bicicletas registradas aún.',
                style: TextStyle(color: Colors.deepPurple),
              ),
            );
          }

          // Si hay bicicletas
          final bikes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bikes.length,
            itemBuilder: (context, index) {
              final data = bikes[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: const Icon(Icons.pedal_bike, color: Colors.deepPurple),
                title: Text(data['nombre'] ?? 'Bici sin nombre'),
                subtitle: Text('Modelo: ${data['modelo'] ?? 'Desconocido'}'),
              );
            },
          );
        },
      ),
    );
  }
}
