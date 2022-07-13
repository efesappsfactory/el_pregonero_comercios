import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/modelos.dart';
import 'promocion_vista.dart';

class Inicio extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: ElPregoneroPaginas.inicio,
      key: ValueKey(ElPregoneroPaginas.inicio),
      child: Inicio(),
    );
  }

  const Inicio({
    Key? key,
  }) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateManager>(
      builder: (
        context,
        appStateManager,
        child,
      ) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'El Pregonero',
              style: Theme.of(context).textTheme.headline6,
            ),
            actions: [
              profileButton(),
            ],
          ),
          body: const PromocionVista(),
        );
      },
    );
  }

  Widget profileButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        child: const CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/profile_pics/person_stef.jpeg'),
        ),
        onTap: () {
          Provider.of<PerfilManager>(context, listen: false).tapOnProfile(true);
        },
      ),
    );
  }
}
