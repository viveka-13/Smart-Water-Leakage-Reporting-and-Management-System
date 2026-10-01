import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/repositories/complaint_repository.dart';
import '../../models/complaint.dart';
import '../../widgets/session_logout_button.dart';

class ComplaintsScreen extends StatefulWidget {
  ComplaintsScreen({super.key, ComplaintRepository? repository})
      : repository = repository ?? ComplaintRepository();

  final ComplaintRepository repository;

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  static const _filters = <String, String>{
    'ALL': 'All',
    'REPORTED': 'Reported',
    'VERIFIED': 'Verified',
    'ASSIGNED': 'Assigned',
    'IN_PROGRESS': 'In progress',
    'RESOLVED': 'Resolved',
    'CLOSED': 'Closed',
  };

  String _selectedFilter = 'ALL';
  late Future<List<Complaint>> _complaintsFuture;

  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  void _loadComplaints() {
    _complaintsFuture = widget.repository.getMyComplaints();
  }

  Future<void> _refresh() async {
    setState(_loadComplaints);
    await _complaintsFuture;
  }

  List<Complaint> _filteredComplaints(List<Complaint> complaints) {
    if (_selectedFilter == 'ALL') {
      return complaints;
    }
    return complaints.where((complaint) => complaint.status == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Complaints'),
        actions: [
          IconButton(
            tooltip: 'Report a complaint',
            onPressed: () => context.push('/report-complaint'),
            icon: const Icon(Icons.add_location_alt_outlined),
          ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Icons.notifications_none),
          ),
          const SessionLogoutButton(),
          IconButton(
            tooltip: 'Refresh complaints',
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<Complaint>>(
        future: _complaintsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _MessageState(
              icon: Icons.cloud_off_outlined,
              title: 'Could not load complaints',
              message: snapshot.error.toString(),
              actionLabel: 'Try again',
              onAction: _refresh,
            );
          }

          final complaints = _filteredComplaints(snapshot.data ?? const []);
          return RefreshIndicator(
            onRefresh: _refresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildFilterBar()),
                if (complaints.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _MessageState(
                      icon: Icons.water_drop_outlined,
                      title: 'No complaints here',
                      message: 'Submitted water issues will appear in this list.',
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    sliver: SliverList.separated(
                      itemCount: complaints.length,
                      itemBuilder: (context, index) => _ComplaintCard(
                        complaint: complaints[index],
                        onTap: () => context.push(
                          '/complaints/${complaints[index].id}',
                          extra: complaints[index],
                        ),
                      ),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterBar() {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters.entries.elementAt(index);
          return FilterChip(
            label: Text(filter.value),
            selected: _selectedFilter == filter.key,
            onSelected: (_) => setState(() => _selectedFilter = filter.key),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
      ),
    );
  }
}

class _ComplaintCard extends StatelessWidget {
  const _ComplaintCard({required this.complaint, required this.onTap});

  final Complaint complaint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = complaint.status ?? 'REPORTED';
    final statusColor = _statusColor(status);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      complaint.title ?? 'Untitled complaint',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusBadge(label: status, color: statusColor),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                complaint.description ?? 'No description provided.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.category_outlined, size: 16, color: AppTheme.primaryBlue),
                  const SizedBox(width: 6),
                  Expanded(child: Text(complaint.category ?? 'Other')),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label.replaceAll('_', ' '),
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: AppTheme.primaryBlue),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            if (actionLabel != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

Color _statusColor(String status) {
  switch (status) {
    case 'RESOLVED':
    case 'CLOSED':
      return AppTheme.successGreen;
    case 'IN_PROGRESS':
    case 'ASSIGNED':
      return AppTheme.primaryBlue;
    case 'REJECTED':
      return AppTheme.emergencyRed;
    default:
      return AppTheme.warningOrange;
  }
}
