import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/routes/app_router.dart';
import '../services/secure_storage_service.dart';

class SessionLogoutButton extends StatelessWidget {
  const SessionLogoutButton({super.key});

  Future<void> _signOut(BuildContext context) async {
    const storage = SecureStorageService();
    await storage.deleteToken();
    await storage.deleteString('user_role');
    await storage.deleteString('user_email');
    if (context.mounted) context.go(AppRoutes.splash);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Sign out',
      onPressed: () => _signOut(context),
      icon: const Icon(Icons.logout),
    );
  }
}