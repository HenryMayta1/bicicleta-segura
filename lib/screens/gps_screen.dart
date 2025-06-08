import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GpsScreen extends StatefulWidget {
  final String biciId;
  final String? nombre; // ✅ Nuevo parámetro opcional

  const GpsScreen({super.key, required this.biciId, this.nombre});

  @override
  State<GpsScreen> createState() => _GpsScreenState();
}

class _GpsScreenState extends State<GpsScreen> {
  LatLng? ubicacion;

  @override
  void initState() {
    super.initState();
    cargarUbicacion();
  }

  Future<void> cargarUbicacion() async {
    // Solo usamos biciId para sacar la última ubicación
    // El nombre ya viene por parámetro
    // 🔥 Solo necesitas firestore si no usas el nombre directamente
    final doc =
        await FirebaseFirestore.instance
            .collection('bicicletas')
            .doc(widget.biciId)
            .get();

    final data = doc.data();
    if (data != null && data['ultimaUbicacion'] != null) {
      final lat = data['ultimaUbicacion']['lat'];
      final lng = data['ultimaUbicacion']['lng'];
      setState(() {
        ubicacion = LatLng(lat, lng);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rastreo GPS'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body:
          ubicacion == null
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                options: MapOptions(initialCenter: ubicacion!, initialZoom: 15),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: ubicacion!,
                        width: 80,
                        height: 80,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.nombre ?? 'Bicicleta',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
    );
  }
}
