import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/modelos.dart';

class LoginVista extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: ElPregoneroPaginas.loginPath,
      key: ValueKey(ElPregoneroPaginas.loginPath),
      child: const LoginVista(),
    );
  }

  final String? nombreUsuario;

  const LoginVista({
    Key? key,
    this.nombreUsuario,
  }) : super(key: key);

  @override
  State<LoginVista> createState() => _LoginVistaState();
}

class _LoginVistaState extends State<LoginVista> {
  final _nombreUsuarioController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Color rwColor = const Color.fromRGBO(64, 143, 77, 1);
  final TextStyle focusedStyle = const TextStyle(color: Colors.green);
  final TextStyle unfocusedStyle = const TextStyle(color: Colors.grey);

  @override
  void dispose() {
    _nombreUsuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioDao = Provider.of<UsuarioDao>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 200,
              child: Image(
                image: AssetImage(
                    'assets/el_pregonero_assets/el_pregonero_logo.png'),
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(height: 80),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'Nombre de usuario o email'),
                            autofocus: false,
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            autocorrect: false,
                            controller: _nombreUsuarioController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'No ha ingresado el usuario.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(height: 20),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'Contraseña',
                            ),
                            autofocus: false,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            textCapitalization: TextCapitalization.none,
                            autocorrect: false,
                            controller: _passwordController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'No ha ingresado la contraseña.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
<<<<<<< HEAD
                    const SizedBox(height: 20),
=======
                    const Spacer(),
>>>>>>> c537a58a5b586e563a0dc297480174541dba6ff9
                    Row(
                      children: [
                        const SizedBox(height: 20),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
<<<<<<< HEAD
                              /* usuarioDao.login(
                                _nombreUsuarioController.text,
                                _passwordController.text,
                              ); */
=======
                              usuarioDao.login(
                                _nombreUsuarioController.text,
                                _passwordController.text,
                              );
>>>>>>> c537a58a5b586e563a0dc297480174541dba6ff9
                              Provider.of<AppStateManager>(context,
                                      listen: false)
                                  .login('mockUsername', 'mockPassword');
                            },
                            child: const Text('Login'),
                          ),
                        )
                      ],
                    ),
<<<<<<< HEAD
                    const Spacer(),
=======
>>>>>>> c537a58a5b586e563a0dc297480174541dba6ff9
                    Row(
                      children: [
                        const SizedBox(height: 20),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              usuarioDao.signup(
                                _nombreUsuarioController.text,
                                _passwordController.text,
                              );
                              Provider.of<AppStateManager>(context,
                                      listen: false)
                                  .login('mockUsername', 'mockPassword');
                            },
                            child: const Text('Registrate'),
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ],
<<<<<<< HEAD
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
=======
                ),
              ),
            ),
          ],
        ),

        /* Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 200,
                child: Image(
                  image: AssetImage(
                      'assets/el_pregonero_assets/el_pregonero_logo.png'),
                ),
              ),
              const SizedBox(height: 16),
              buildTextfield(widget.nombreUsuario ?? '🍔 username'),
              const SizedBox(height: 16),
              buildTextfield('🎹 password'),
              const SizedBox(height: 16),
              buildButton(context),
            ],
          ),
        ), */
      ),
    );
  }

/*   Widget buildButton(BuildContext context) {
    return SizedBox(
      height: 55,
      child: MaterialButton(
        color: rwColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          Provider.of<UsuarioDao>(context, listen: false)
              .login('mockUsername', 'mockPassword');
          Provider.of<AppStateManager>(context, listen: false)
              .login('mockUsername', 'mockPassword');
        },
      ),
    );
  }

  Widget buildTextfield(String hintText) {
    return TextField(
      cursorColor: rwColor,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
            width: 1.0,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(height: 0.5),
      ),
    );
  } */
>>>>>>> c537a58a5b586e563a0dc297480174541dba6ff9
}
