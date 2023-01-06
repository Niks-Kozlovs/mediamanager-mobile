import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mediamanager_flutter/main.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedin = context.watch<CookiesProvider>().isLoggedin;
    if (!isLoggedin) {
      return const _NotLogedInView();
    }

    return Column(
      children: [
        const Text('Logged in'),
        ElevatedButton(
          onPressed: () {
            context.read<CookiesProvider>().clearCookies();
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}

class _NotLogedInView extends StatelessWidget {
  const _NotLogedInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Not logged in'),
        ElevatedButton(
          onPressed: () {
            context.push('/login');
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}
