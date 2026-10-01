import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/repositories/admin_repository.dart';
import '../../models/analytics_summary.dart';
import '../../widgets/session_logout_button.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  AdminAnalyticsScreen({super.key, AdminRepository? repository})
      : repository = repository ?? AdminRepository();

  final AdminRepository repository;

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  late Future<AnalyticsSummary> _summaryFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _summaryFuture = widget.repository.getAnalyticsSummary();
  }

  Future<void> _refresh() async {
    setState(_reload);
    await _summaryFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operations Overview'),
        actions: [
          const SessionLogoutButton(),
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh), tooltip: 'Refresh analytics'),
        ],
      ),
      body: FutureBuilder<AnalyticsSummary>(
        future: _summaryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return Center(child: Text(snapshot.error.toString()));
          final summary = snapshot.data;
          if (summary == null) return const Center(child: Text('Analytics are unavailable.'));
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                _buildMetricGrid(summary),
                const SizedBox(height: 20),
                _Breakdown(title: 'Complaints by status', buckets: summary.byStatus, color: AppTheme.primaryBlue),
                const SizedBox(height: 16),
                _Breakdown(title: 'Complaints by priority', buckets: summary.byPriority, color: AppTheme.warningOrange),
                const SizedBox(height: 16),
                _Breakdown(title: 'Complaints by category', buckets: summary.byCategory, color: AppTheme.secondaryTeal),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () => context.push('/admin-complaints'),
                  icon: const Icon(Icons.fact_check_outlined),
                  label: const Text('Open Complaint Queue'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricGrid(AnalyticsSummary summary) {
    final metrics = [
      ('Total', '${summary.totalComplaints}', Icons.inbox_outlined),
      ('Open', '${summary.openComplaints}', Icons.pending_actions),
      ('Resolved', '${summary.resolvedComplaints}', Icons.check_circle_outline),
      ('Avg. rating', summary.averageRating.toStringAsFixed(1), Icons.star_outline),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 104,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(metric.$3, color: AppTheme.primaryBlue),
                const Spacer(),
                Text(metric.$2, style: Theme.of(context).textTheme.titleLarge),
                Text(metric.$1, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Breakdown extends StatelessWidget {
  const _Breakdown({required this.title, required this.buckets, required this.color});

  final String title;
  final List<AnalyticsBucket> buckets;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final maximum = buckets.fold<int>(0, (max, item) => item.count > max ? item.count : max);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 14),
            if (buckets.isEmpty) const Text('No data yet.')
            else for (final bucket in buckets) ...[
              Row(
                children: [
                  Expanded(child: Text(bucket.label.replaceAll('_', ' '))),
                  Text('${bucket.count}', style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 5),
              LinearProgressIndicator(
                value: maximum == 0 ? 0 : bucket.count / maximum,
                color: color,
                backgroundColor: color.withValues(alpha: 0.12),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}