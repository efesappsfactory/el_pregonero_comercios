import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../componentes/circle_image.dart';
import '../modelos/modelos.dart';

class PerfilVista extends StatefulWidget {
  static MaterialPage page(Usuario user) {
    return MaterialPage(
      name: ElPregoneroPaginas.profilePath,
      key: ValueKey(ElPregoneroPaginas.profilePath),
      child: PerfilVista(usuario: user),
    );
  }

  final Usuario usuario;
  const PerfilVista({
    Key? key,
    required this.usuario,
  }) : super(key: key);

  @override
  _PerfilVistaState createState() => _PerfilVistaState();
}

class _PerfilVistaState extends State<PerfilVista> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Provider.of<PerfilManager>(context, listen: false)
                .tapOnProfile(false);
          },
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16.0),
            buildProfile(),
            Expanded(
              child: buildMenu(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMenu() {
    return ListView(
      children: [
        buildDarkModeRow(),
        ListTile(
          title: const Text('Cerrar Sesión'),
          onTap: () {
            // 1
            Provider.of<PerfilManager>(context, listen: false)
                .tapOnProfile(false);
            // 2
            Provider.of<AppStateManager>(context, listen: false).logout();
          },
        )
      ],
    );
  }

  Widget buildDarkModeRow() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Dark Mode'),
          Switch(
            value: widget.usuario.darkMode,
            onChanged: (value) {
              Provider.of<PerfilManager>(context, listen: false).darkMode =
                  value;
            },
          )
        ],
      ),
    );
  }

  Widget buildProfile() {
    return Column(
      children: [
        CircleImage(
          imageProvider: AssetImage(widget.usuario.profileImageUrl),
          imageRadius: 60.0,
        ),
        const SizedBox(height: 16.0),
        Text(
          widget.usuario.firstName,
          style: const TextStyle(fontSize: 21),
        ),
        Text(widget.usuario.role),
        Text(
          '${widget.usuario.points} points',
          style: const TextStyle(
            fontSize: 30,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
