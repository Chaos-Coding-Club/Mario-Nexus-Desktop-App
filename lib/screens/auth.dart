import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:mario_nexus/providers/providers.dart';

class Auth extends ConsumerStatefulWidget {
  const Auth({super.key});

  @override
  AuthState createState() => AuthState();
}

class AuthState extends ConsumerState<Auth> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  String _email = "";
  String _password = "";
  bool _login = true;

  @override
  Widget build(BuildContext context) {
    return MacosWindow(
      titleBar: const TitleBar(
        title: Text("Mario Nexus"),
      ),
      child: Center(
        child: SizedBox(
          width: 600,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to Mario Nexus!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                CupertinoFormSection.insetGrouped(
                  backgroundColor: MacosColors.transparent,
                  children: [
                    CupertinoFormRow(
                      child: CupertinoTextFormFieldRow(
                        controller: _controller,
                        prefix: const Icon(CupertinoIcons.mail),
                        placeholder: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => _email = value.trim(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email is required';
                          } else if (!value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ),
                    CupertinoFormRow(
                      child: CupertinoTextFormFieldRow(
                        prefix: const Icon(CupertinoIcons.lock),
                        placeholder: 'Password',
                        obscureText: true,
                        onChanged: (value) => _password = value.trim(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is required';
                          } else if (value.length < 4) {
                            return 'Password must be at least 4 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                CupertinoButton.filled(
                  child: Text(_login ? 'Log In' : "Register",
                      style: const TextStyle(color: MacosColors.white)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login
                          ? ref
                              .watch(authNotifierProvider.notifier)
                              .signIn(email: _email, password: _password)
                          : ref
                              .watch(authNotifierProvider.notifier)
                              .register(email: _email, password: _password);
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_login
                        ? "Don't have an account?"
                        : "Already have an account?"),
                    TextButton(
                      onPressed: () => setState(() {
                        _login = !_login;
                      }),
                      style: const ButtonStyle(
                        overlayColor:
                            MaterialStatePropertyAll(MacosColors.transparent),
                      ),
                      child: Text(_login ? "Create one here." : "Login here."),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
