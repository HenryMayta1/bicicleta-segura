import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerAlertasScreen extends StatelessWidget {
  final String biciId = 'bici_001';

  const VerAlertasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alertasRef = FirebaseFirestore.instance
        .collection('bicicletas')
        .doc(biciId)
        .collection('alertas')
        .orderBy('fecha', descending: true);

    return Scaffold(
      appBar: AppBar(title: Text('Alertas de la Bicicleta')),
      body: StreamBuilder<QuerySnapshot>(
        stream: alertasRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: Icon(Icons.warning, color: Colors.red),
                title: Text('Tipo: ${data['tipo']}'),
                subtitle: Text(
                  'Valor: ${data['valor_detectado']}\nFecha: ${data['fecha']}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
