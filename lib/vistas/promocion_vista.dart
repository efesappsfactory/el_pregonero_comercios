import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modelos/modelos.dart';
import 'promocion_vacia_vista.dart';
import 'promocion_lista_vista.dart';

class PromocionVista extends StatelessWidget {
  const PromocionVista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final manager = Provider.of<PromocionManager>(
            context,
            listen: false,
          );
          manager.createNewItem();
        },
      ),
      body: buildGroceryScreen(),
    );
  }

  Widget buildGroceryScreen() {
    return Consumer<PromocionManager>(
      builder: (context, manager, child) {
        if (manager.promocionItems.isNotEmpty) {
          return PromocionListaVista(manager: manager);
        } else {
          return const PromocionVaciaVista();
        }
      },
    );
  }
}
