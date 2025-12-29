import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../firebase/firebase_auth_provider.dart';
import 'scaffold.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints.loose(Size.fromWidth(600)),
            child: const RegisterForm(),
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "REGISTRIEREN",
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 48,
              fontWeight: FontWeight.w300,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 16)),
          Text(
            "Registrieren Sie Ihre Feuerwehr, um alle Vorteile wie das Speichern der Personen und Funkrufnamen zu nutzen.",
          ),
          TextButton(
            onPressed: () {
              context.goNamed('login');
            },
            child: const Text("Schon einen Account? Hier geht's zum Login"),
          ),
          const Padding(padding: EdgeInsets.only(top: 16)),

          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte eine Email eingeben';
              }
              if (!value.contains('@')) {
                return 'Bitte eine gültige Email eingeben';
              }
              return null;
            },
          ),
          const Padding(padding: EdgeInsets.only(top: 16)),

          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte ein Passwort eingeben';
              }
              if (value.length < 8) {
                return 'Das Passwort muss mindestens 8 Zeichen lang sein';
              }
              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                return 'Das Passwort muss mindestens einen Großbuchstaben enthalten';
              }
              if (!RegExp(r'[a-z]').hasMatch(value)) {
                return 'Das Passwort muss mindestens einen Kleinbuchstaben enthalten';
              }
              if (!RegExp(r'[0-9]').hasMatch(value)) {
                return 'Das Passwort muss mindestens eine Zahl enthalten';
              }
              return null;
            },
          ),
          const Padding(padding: EdgeInsets.only(top: 16)),

          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(labelText: 'Password bestätigen'),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            validator: (value) {
              final pass = _passwordController.text;
              final confirmPass = _confirmPasswordController.text;
              if (pass != confirmPass) {
                return 'Die Passwörter stimmen nicht überein';
              }
              return null;
            },
          ),
          const Padding(padding: EdgeInsets.only(top: 32)),

          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() != true) {
                return;
              }
              final email = _emailController.text.trim();
              final password = _passwordController.text.trim();
              setState(() {
                _loading = true;
              });
              await ref
                  .read(firebaseAuthServiceProvider)
                  .signUpWithEmailAndPassword(email, password);
              setState(() {
                _loading = false;
              });
              if (!context.mounted) return;
              context.goNamed('post_register');
            },
            child: Text('Registrieren'),
          ),
          const Padding(padding: EdgeInsets.only(top: 16)),

          if (_loading) CircularProgressIndicator(),
        ],
      ),
    );
  }
}
