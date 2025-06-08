import 'package:flutter/material.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuraciones'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: true,
            onChanged: (val) {},
            title: const Text('Notificaciones'),
            secondary: const Icon(Icons.notifications),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Cuenta'),
            subtitle: const Text('Datos del usuario demo'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Acerca de'),
            subtitle: const Text('Versión 1.0.0'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
