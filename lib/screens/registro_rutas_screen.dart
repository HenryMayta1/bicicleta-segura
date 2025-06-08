import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/firebase_service.dart';
import '../models/ruta.dart';
import '../utils/demo_data_loader.dart';

class RegistroRutasScreen extends StatelessWidget {
  const RegistroRutasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseService = FirebaseService();
    final loader = DemoDataLoader();
    const String idBici = 'bici_001';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de rutas'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => loader.agregarRutasADocumentos(),
            child: const Text('📥 Cargar rutas demo'),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 250,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: const LatLng(-16.5, -68.15),
                initialZoom: 14,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<List<Ruta>>(
              stream: firebaseService.obtenerRutas(idBici),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final rutas = snapshot.data!;
                if (rutas.isEmpty) {
                  return const Center(child: Text('No hay rutas registradas.'));
                }
                return ListView.builder(
                  itemCount: rutas.length,
                  itemBuilder: (context, index) {
                    final ruta = rutas[index];
                    return ListTile(
                      leading: const Icon(
                        Icons.route,
                        color: Colors.deepPurple,
                      ),
                      title: Text(ruta.descripcion),
                      subtitle: Text(
                        '🕒 ${ruta.fecha.toString().substring(0, 16)}\n📍 ${ruta.lat}, ${ruta.lng}',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
