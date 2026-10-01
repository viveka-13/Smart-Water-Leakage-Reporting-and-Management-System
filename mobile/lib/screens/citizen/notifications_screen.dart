import 'package:flutter/material.dart';

import '../../data/repositories/notification_repository.dart';
import '../../models/notification.dart';
import '../../widgets/session_logout_button.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({super.key, NotificationRepository? repository})
      : repository = repository ?? NotificationRepository();

  final NotificationRepository repository;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<AppNotification>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _notificationsFuture = widget.repository.getNotifications();
  }

  Future<void> _refresh() async {
    setState(_reload);
    await _notificationsFuture;
  }

  Future<void> _openNotification(AppNotification notification) async {
    if (notification.id != null && notification.isRead != true) {
      await widget.repository.markAsRead(notification.id!);
      if (mounted) setState(_reload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          const SessionLogoutButton(),
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh), tooltip: 'Refresh'),
        ],
      ),
      body: FutureBuilder<List<AppNotification>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return Center(child: Text(snapshot.error.toString()));
          final notifications = snapshot.data ?? const <AppNotification>[];
          if (notifications.isEmpty) {
            return const Center(child: Text('You have no notifications.'));
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  color: notification.isRead == true ? null : Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                  child: ListTile(
                    onTap: () => _openNotification(notification),
                    leading: Icon(notification.isRead == true ? Icons.notifications_none : Icons.notifications_active),
                    title: Text(notification.title ?? 'AquaGuard update'),
                    subtitle: Text(notification.message ?? 'Your complaint has been updated.'),
                    trailing: notification.isRead == true ? null : const Icon(Icons.circle, size: 10),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
