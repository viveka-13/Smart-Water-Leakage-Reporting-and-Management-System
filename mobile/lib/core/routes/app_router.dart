import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/complaint.dart';
import '../../screens/admin/admin_complaints_screen.dart';
import '../../screens/admin/admin_analytics_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/citizen/complaint_detail_screen.dart';
import '../../screens/citizen/complaints_screen.dart';
import '../../screens/citizen/feedback_screen.dart';
import '../../screens/citizen/notifications_screen.dart';
import '../../screens/citizen/report_complaint_screen.dart';
import '../../screens/worker/worker_tasks_screen.dart';
import '../../services/secure_storage_service.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String citizenHome = '/citizen-home';
  static const String workerHome = '/worker-home';
  static const String adminHome = '/admin-home';
  static const String adminComplaints = '/admin-complaints';
  static const String reportComplaint = '/report-complaint';
  static const String complaints = '/complaints';
  static const String notifications = '/notifications';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) async {
      final location = state.matchedLocation;
      if (location == AppRoutes.splash ||
          location == AppRoutes.login ||
          location == AppRoutes.register) {
        return null;
      }

      final token = await const SecureStorageService().readToken();
      return token == null || token.isEmpty ? AppRoutes.login : null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const _SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.citizenHome,
        builder: (context, state) => const _PlaceholderScreen(title: 'Citizen Home'),
      ),
      GoRoute(
        path: AppRoutes.workerHome,
        builder: (context, state) => WorkerTasksScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminHome,
        builder: (context, state) => AdminAnalyticsScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminComplaints,
        builder: (context, state) => AdminComplaintsScreen(),
      ),
      GoRoute(
        path: AppRoutes.reportComplaint,
        builder: (context, state) => const ReportComplaintScreen(),
      ),
      GoRoute(
        path: AppRoutes.complaints,
        builder: (context, state) => ComplaintsScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.complaints}/:id',
        builder: (context, state) {
          final complaintId = int.tryParse(state.pathParameters['id'] ?? '');
          if (complaintId == null) {
            return const _PlaceholderScreen(title: 'Complaint Not Found');
          }

          return ComplaintDetailScreen(
            complaintId: complaintId,
            initialComplaint: state.extra is Complaint ? state.extra as Complaint : null,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => NotificationsScreen(),
      ),
      GoRoute(
        path: '/feedback/:complaintId',
        builder: (context, state) {
          final complaintId = int.tryParse(state.pathParameters['complaintId'] ?? '');
          if (complaintId == null) {
            return const _PlaceholderScreen(title: 'Feedback Not Found');
          }
          return FeedbackScreen(complaintId: complaintId);
        },
      ),
    ],
  );
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AquaGuard Demo')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Water service, connected.', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Choose a workflow to explore.', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          _DemoRouteTile(
            icon: Icons.login,
            title: 'Sign in',
            subtitle: 'Continue with a citizen, admin, or worker account',
            onTap: () => context.go(AppRoutes.login),
          ),
          _DemoRouteTile(
            icon: Icons.person_add_alt_1,
            title: 'Create citizen account',
            subtitle: 'Register and sign in to report issues',
            onTap: () => context.go(AppRoutes.register),
          ),
          const SizedBox(height: 8),
          _DemoRouteTile(
            icon: Icons.add_location_alt_outlined,
            title: 'Report a water issue',
            subtitle: 'Citizen complaint form',
            onTap: () => context.go(AppRoutes.reportComplaint),
          ),
          _DemoRouteTile(
            icon: Icons.track_changes_outlined,
            title: 'Track complaints',
            subtitle: 'Citizen complaint list and status details',
            onTap: () => context.go(AppRoutes.complaints),
          ),
          _DemoRouteTile(
            icon: Icons.analytics_outlined,
            title: 'Admin operations',
            subtitle: 'Analytics summary',
            onTap: () => context.go(AppRoutes.adminHome),
          ),
          _DemoRouteTile(
            icon: Icons.fact_check_outlined,
            title: 'Admin complaint queue',
            subtitle: 'Status and worker assignment controls',
            onTap: () => context.go(AppRoutes.adminComplaints),
          ),
          _DemoRouteTile(
            icon: Icons.handyman_outlined,
            title: 'Worker tasks',
            subtitle: 'Assigned field work and progress updates',
            onTap: () => context.go(AppRoutes.workerHome),
          ),
          _DemoRouteTile(
            icon: Icons.notifications_none,
            title: 'Notifications',
            subtitle: 'Complaint updates and read state',
            onTap: () => context.go(AppRoutes.notifications),
          ),
        ],
      ),
    );
  }
}

class _DemoRouteTile extends StatelessWidget {
  const _DemoRouteTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: ListTile(
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: Text('This screen will be implemented in later phases.'),
      ),
    );
  }
}
