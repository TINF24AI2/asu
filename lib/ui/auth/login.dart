import 'package:asu/firebase/firebase_auth_provider.dart';
import 'package:asu/ui/auth/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints.loose(Size.fromWidth(600)),
            child: const LoginForm(),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
            "LOGIN",
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 48,
              fontWeight: FontWeight.w300,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 16)),
          Text(
            "Loggen Sie sich ein, um alle Vorteile wie das Speichern der Personen und Funkrufnamen zu nutzen.",
          ),
          TextButton(
            onPressed: () {
              context.goNamed('register');
            },
            child: const Text(
              "Noch keinen Account? Registrieren Sie Ihre Feuerwehr jetzt hier",
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 16)),

          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          const Padding(padding: EdgeInsets.only(top: 16)),

          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
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
                  .signInWithEmailAndPassword(email, password);
              setState(() {
                _loading = false;
              });
              if (!context.mounted) return;
              context.goNamed('operation');
            },
            child: Text('Login'),
          ),
          const Padding(padding: EdgeInsets.only(top: 16)),

          if (_loading) CircularProgressIndicator(),
        ],
      ),
    );
  }
}
