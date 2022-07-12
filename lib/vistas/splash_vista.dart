import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modelos/modelos.dart';

class SplashVista extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: ElPregoneroPaginas.splashPath,
      key: ValueKey(ElPregoneroPaginas.splashPath),
      child: const SplashVista(),
    );
  }

  const SplashVista({Key? key}) : super(key: key);

  @override
  _SplashVistaState createState() => _SplashVistaState();
}

class _SplashVistaState extends State<SplashVista> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<AppStateManager>(context, listen: false).initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              height: 200,
              image: AssetImage('assets/el_pregonero_assets/rw_logo.png'),
            ),
            const Text('Initializing...')
          ],
        ),
      ),
    );
  }
}
