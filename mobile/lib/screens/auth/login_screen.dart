import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/errors/app_exception.dart';
import '../../core/routes/app_router.dart';
import '../../data/repositories/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key, AuthRepository? repository}) : repository = repository ?? AuthRepository();

  final AuthRepository repository;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      final user = await widget.repository.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      final role = user['role'];
      if (role == 'admin') {
        context.go(AppRoutes.adminHome);
      } else if (role == 'worker') {
        context.go(AppRoutes.workerHome);
      } else {
        context.go(AppRoutes.complaints);
      }
    } catch (error) {
      if (mounted) _showError(error);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showError(Object error) {
    final message = error is AppException ? error.message : error.toString();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(24),
            children: [
              Text('Welcome to AquaGuard', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text('Academic demo accounts', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              const Text('Citizen: citizen@aquaguard.demo'),
              const Text('Admin: admin@aquaguard.demo'),
              const Text('Worker: worker@aquaguard.demo'),
              const Text('Password for all: AquaGuard123!'),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) => value == null || !value.contains('@') ? 'Enter a valid email.' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (value) => value == null || value.isEmpty ? 'Password is required.' : null,
                      onFieldSubmitted: (_) => _login(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _login,
                        child: _isSubmitting
                            ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Sign in'),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.register),
                  child: const Text('Create a citizen account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}