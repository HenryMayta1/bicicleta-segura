// 📁 lib/screens/home.dart
import 'package:bicicleta_segura/screens/config_screen.dart';
import 'package:bicicleta_segura/screens/registro_alertas_screen.dart';
import 'package:bicicleta_segura/screens/registro_rutas_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'gps_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  String? biciSeleccionadaId = 'bici_001';
  String? biciSeleccionadaNombre = 'Bici por defecto';

  @override
  Widget build(BuildContext context) {
    final List<Widget> pantallas = [
      HomeContent(
        onSeleccionarBici: (id, nombre) {
          setState(() {
            biciSeleccionadaId = id;
            biciSeleccionadaNombre = nombre;
          });
        },
        biciSeleccionadaId: biciSeleccionadaId!,
        biciSeleccionadaNombre: biciSeleccionadaNombre!,
      ),
      GpsScreen(biciId: biciSeleccionadaId!, nombre: biciSeleccionadaNombre),
      const RegistroRutasScreen(),
      RegistroAlertasScreen(idBici: biciSeleccionadaId!),
      const ConfigScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Bicicleta segura'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: pantallas[_index],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          currentIndex: _index,
          onTap: (value) {
            setState(() => _index = value);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.location_on), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.pedal_bike), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.warning), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final Function(String, String) onSeleccionarBici;
  final String biciSeleccionadaId;
  final String biciSeleccionadaNombre;

  const HomeContent({
    super.key,
    required this.onSeleccionarBici,
    required this.biciSeleccionadaId,
    required this.biciSeleccionadaNombre,
  });

  Widget buildAlertaChart(String idBici) {
    final alertasRef = FirebaseFirestore.instance
        .collection('bicicletas')
        .doc(idBici)
        .collection('alertas')
        .orderBy('fecha');

    return StreamBuilder<QuerySnapshot>(
      stream: alertasRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final docs = snapshot.data!.docs;

        if (docs.isEmpty) return const Text('No hay alertas registradas');

        List<FlSpot> spots = [];
        for (int i = 0; i < docs.length; i++) {
          final data = docs[i].data() as Map<String, dynamic>;
          final double valor =
              double.tryParse(data['valor_detectado'].toString()) ?? 0.0;
          spots.add(FlSpot(i.toDouble(), valor));
        }

        return SizedBox(
          height: 150,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  gradient: const LinearGradient(colors: [Colors.deepPurple]),
                  barWidth: 2,
                  dotData: FlDotData(show: true),
                ),
              ],
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),
            ),
          ),
        );
      },
    );
  }

  Widget buildTablaDeAlertas(String idBici) {
    final alertasRef = FirebaseFirestore.instance
        .collection('bicicletas')
        .doc(idBici)
        .collection('alertas')
        .orderBy('fecha', descending: true)
        .limit(5);

    return StreamBuilder<QuerySnapshot>(
      stream: alertasRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final docs = snapshot.data!.docs;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
              docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final fecha = (data['fecha'] as Timestamp).toDate();
                final tipo = data['tipo'] ?? 'N/A';
                final valor = data['valor_detectado'] ?? '0';
                final lat =
                    data['ubicacion']?['lat']?.toStringAsFixed(4) ?? '-';
                final lng =
                    data['ubicacion']?['lng']?.toStringAsFixed(4) ?? '-';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 3),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "🕒 ${fecha.toString().substring(0, 16)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text("⚠️ Tipo: $tipo    📊 Valor: $valor"),
                        Text("📍 Lat: $lat    Lng: $lng"),
                      ],
                    ),
                  ),
                );
              }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('bicicletas')
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final docs = snapshot.data!.docs;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final bici = docs[index].data() as Map<String, dynamic>;
                    final biciId = docs[index].id;
                    return GestureDetector(
                      onTap: () => onSeleccionarBici(biciId, bici['nombre']),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                bici['imagenUrl'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 100,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bici['nombre'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  biciId == biciSeleccionadaId
                                      ? Colors.deepPurple
                                      : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '📌 Mostrando datos de: $biciSeleccionadaNombre',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          buildTablaDeAlertas(biciSeleccionadaId),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: buildAlertaChart(biciSeleccionadaId),
          ),
        ],
      ),
    );
  }
}
