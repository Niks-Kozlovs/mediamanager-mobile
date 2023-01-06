import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mediamanager_flutter/main.dart';
import 'package:mediamanager_flutter/queries/queries.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Mutation(
          options: MutationOptions(
            document: gql(Queries.login),
            onCompleted: (dynamic resultData) {
              if (resultData != null) {
                context.read<CookiesProvider>().isLoggedIn = true;
                context.pop();
              }
            },
          ),
          builder: (runMutation, result) {
            if (result != null && result.hasException) {
              return Text(result.exception.toString());
            }
            return Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    onChanged: (value) => _email = value,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    onChanged: (value) => _password = value,
                    decoration: const InputDecoration(
                      hintText: 'Enter your password',
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      runMutation({
                        'credentials': {
                          'email': _email,
                          'password': _password,
                        }
                      });
                    },
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.pushReplacement('/register'),
                    child: const Text('Register'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
