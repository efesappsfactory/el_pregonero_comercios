import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'el_pregonero_tema.dart';
import 'modelos/modelos.dart';
import 'navegacion/app_route_parser.dart';
import 'navegacion/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ElPregoneroComercios(),
  );
}

class ElPregoneroComercios extends StatefulWidget {
  const ElPregoneroComercios({Key? key}) : super(key: key);

  @override
  _ElPregoneroComerciosState createState() => _ElPregoneroComerciosState();
}

class _ElPregoneroComerciosState extends State<ElPregoneroComercios> {
  final _promocionManager = PromocionManager();
  final _perfilManager = PerfilManager();
  final _appStateManager = AppStateManager();
  final _usuarioDao = UsuarioDao();
  late AppRouter _appRouter;
  final routeParser = AppRouteParser();

  @override
  void initState() {
    _appRouter = AppRouter(
      appStateManager: _appStateManager,
      promocionManager: _promocionManager,
      perfilManager: _perfilManager,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _promocionManager),
        ChangeNotifierProvider(
          create: (context) => _appStateManager,
        ),
        ChangeNotifierProvider(
          create: (context) => _perfilManager,
        ),
        Provider(
          create: (context) => _usuarioDao,
          lazy: false,
        )
      ],
      child: Consumer<PerfilManager>(
        builder: (context, profileManager, child) {
          ThemeData theme;
          if (profileManager.darkMode) {
            theme = ElPregoneroTema.dark();
          } else {
            theme = ElPregoneroTema.light();
          }
          return MaterialApp.router(
            theme: theme,
            title: 'El Pregonero Comercios',
            backButtonDispatcher: RootBackButtonDispatcher(),
            // 1
            routeInformationParser: routeParser,
            // 2
            routerDelegate: _appRouter,
          );
        },
      ),
    );
  }
}
