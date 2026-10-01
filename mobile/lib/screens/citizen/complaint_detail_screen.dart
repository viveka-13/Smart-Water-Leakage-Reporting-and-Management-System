import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../data/repositories/complaint_repository.dart';
import '../../models/complaint.dart';

class ComplaintDetailScreen extends StatefulWidget {
  ComplaintDetailScreen({
    super.key,
    required this.complaintId,
    this.initialComplaint,
    ComplaintRepository? repository,
  }) : repository = repository ?? ComplaintRepository();

  final int complaintId;
  final Complaint? initialComplaint;
  final ComplaintRepository repository;

  @override
  State<ComplaintDetailScreen> createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends State<ComplaintDetailScreen> {
  late Future<Complaint> _complaintFuture;

  @override
  void initState() {
    super.initState();
    _complaintFuture = widget.initialComplaint != null
        ? Future.value(widget.initialComplaint)
        : widget.repository.getMyComplaintById(widget.complaintId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complaint #${widget.complaintId}')),
      body: FutureBuilder<Complaint>(
        future: _complaintFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text(snapshot.error?.toString() ?? 'Complaint not found.'));
          }
          return _buildDetails(context, snapshot.data!);
        },
      ),
    );
  }

  Widget _buildDetails(BuildContext context, Complaint complaint) {
    final status = complaint.status ?? 'REPORTED';
    final createdDate = complaint.createdAt == null
        ? 'Date unavailable'
        : DateFormat('dd MMM yyyy, hh:mm a').format(complaint.createdAt!.toLocal());

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                complaint.title ?? 'Untitled complaint',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            _StatusPill(status: status),
          ],
        ),
        const SizedBox(height: 8),
        Text('Submitted $createdDate', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 24),
        _Section(
          title: 'Current status',
          child: _StatusTimeline(currentStatus: status),
        ),
        const SizedBox(height: 20),
        _Section(
          title: 'Issue details',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailRow(label: 'Category', value: complaint.category ?? 'Other'),
              _DetailRow(label: 'Priority', value: complaint.priority ?? 'MEDIUM'),
              _DetailRow(label: 'Description', value: complaint.description ?? 'No description provided.'),
              _DetailRow(label: 'Address', value: complaint.address ?? 'Location unavailable'),
            ],
          ),
        ),
        if (complaint.latitude != null && complaint.longitude != null) ...[
          const SizedBox(height: 20),
          _Section(
            title: 'Reported location',
            child: Text('${complaint.latitude}, ${complaint.longitude}'),
          ),
        ],
        if (complaint.id != null && (complaint.status == 'RESOLVED' || complaint.status == 'CLOSED')) ...[
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => context.push('/feedback/${complaint.id}'),
            icon: const Icon(Icons.star_outline),
            label: const Text('Rate Resolution'),
          ),
        ],
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: child)),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 3),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  const _StatusTimeline({required this.currentStatus});

  final String currentStatus;

  static const statuses = ['REPORTED', 'VERIFIED', 'ASSIGNED', 'IN_PROGRESS', 'RESOLVED'];

  @override
  Widget build(BuildContext context) {
    final currentIndex = statuses.indexOf(currentStatus);
    final progressIndex = currentIndex < 0 ? 0 : currentIndex;

    return Column(
      children: [
        for (var index = 0; index < statuses.length; index++)
          _TimelineRow(
            label: statuses[index],
            isComplete: index <= progressIndex,
            isLast: index == statuses.length - 1,
          ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.label,
    required this.isComplete,
    required this.isLast,
  });

  final String label;
  final bool isComplete;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = isComplete ? AppTheme.primaryBlue : Colors.grey.shade300;

    return SizedBox(
      height: 44,
      child: Row(
        children: [
          Column(
            children: [
              Icon(
                isComplete ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 20,
                color: color,
              ),
              if (!isLast) Expanded(child: Container(width: 2, color: color)),
            ],
          ),
          const SizedBox(width: 12),
          Text(
            label.replaceAll('_', ' '),
            style: TextStyle(
              color: isComplete ? AppTheme.textPrimary : AppTheme.textSecondary,
              fontWeight: isComplete ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _detailStatusColor(status);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          status.replaceAll('_', ' '),
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

Color _detailStatusColor(String status) {
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
