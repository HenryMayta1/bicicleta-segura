// 📁 lib/screens/registro_alertas_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistroAlertasScreen extends StatelessWidget {
  final String idBici;

  const RegistroAlertasScreen({super.key, required this.idBici});

  @override
  Widget build(BuildContext context) {
    final alertasRef = FirebaseFirestore.instance
        .collection('bicicletas')
        .doc(idBici)
        .collection('alertas')
        .orderBy('fecha', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de alertas'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: alertasRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No hay alertas registradas.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final fecha = (data['fecha'] as Timestamp).toDate();
              final tipo = data['tipo'] ?? 'N/A';
              final valor = data['valor_detectado'] ?? '0';
              final lat = data['ubicacion']?['lat']?.toStringAsFixed(4) ?? '-';
              final lng = data['ubicacion']?['lng']?.toStringAsFixed(4) ?? '-';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🕒 ${fecha.toString().substring(0, 16)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text('⚠️ Tipo: $tipo    📊 Valor: $valor'),
                      Text('📍 Lat: $lat, Lng: $lng'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
