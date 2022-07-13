import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/modelos.dart';

class PromocionVaciaVista extends StatelessWidget {
  const PromocionVaciaVista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child:
                    Image.asset('assets/el_pregonero_assets/lista_vacia.png'),
              ),
            ),
            const Text(
              'Agregue Promociones',
              style: TextStyle(fontSize: 21.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Para agragar promociones a la lista\n'
              'Toque el botón + para registrarlas',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
