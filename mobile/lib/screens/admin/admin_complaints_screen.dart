import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/repositories/admin_repository.dart';
import '../../models/complaint.dart';
import '../../widgets/session_logout_button.dart';

class AdminComplaintsScreen extends StatefulWidget {
  AdminComplaintsScreen({super.key, AdminRepository? repository})
      : repository = repository ?? AdminRepository();

  final AdminRepository repository;

  @override
  State<AdminComplaintsScreen> createState() => _AdminComplaintsScreenState();
}

class _AdminComplaintsScreenState extends State<AdminComplaintsScreen> {
  static const statuses = ['ALL', 'REPORTED', 'VERIFIED', 'ASSIGNED', 'IN_PROGRESS', 'RESOLVED', 'CLOSED', 'REJECTED'];
  String _status = 'ALL';
  late Future<List<Complaint>> _complaintsFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _complaintsFuture = widget.repository.getComplaints(status: _status);
  }

  Future<void> _refresh() async {
    setState(_reload);
    await _complaintsFuture;
  }

  Future<void> _changeStatus(Complaint complaint) async {
    final selectedStatus = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Update status'),
        children: [
          for (final status in statuses.skip(1))
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, status),
              child: Text(status.replaceAll('_', ' ')),
            ),
        ],
      ),
    );

    if (!mounted || selectedStatus == null || complaint.id == null) return;
    try {
      await widget.repository.updateStatus(complaint.id!, selectedStatus);
      if (!mounted) return;
      _showMessage('Status updated successfully.');
      setState(_reload);
    } catch (error) {
      if (mounted) _showMessage(error.toString());
    }
  }

  Future<void> _assignWorker(Complaint complaint) async {
    if (complaint.id == null) return;
    try {
      final workers = await widget.repository.getWorkers();
      if (!mounted) return;
      final worker = await showDialog<AdminWorker>(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('Assign field worker'),
          children: [
            for (final item in workers)
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, item),
                child: Text(item.name),
              ),
          ],
        ),
      );
      if (!mounted || worker == null) return;
      await widget.repository.assignWorker(complaint.id!, worker.id);
      if (!mounted) return;
      _showMessage('Complaint assigned to ${worker.name}.');
      setState(_reload);
    } catch (error) {
      if (mounted) _showMessage(error.toString());
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Complaints'),
        actions: [
          const SessionLogoutButton(),
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh), tooltip: 'Refresh'),
        ],
      ),
      body: Column(
        children: [
          _buildFilter(),
          Expanded(
            child: FutureBuilder<List<Complaint>>(
              future: _complaintsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                final complaints = snapshot.data ?? const <Complaint>[];
                if (complaints.isEmpty) {
                  return const Center(child: Text('No complaints match this filter.'));
                }
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: complaints.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _ComplaintAdminCard(
                      complaint: complaints[index],
                      onStatus: () => _changeStatus(complaints[index]),
                      onAssign: () => _assignWorker(complaints[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: DropdownButtonFormField<String>(
        initialValue: _status,
        decoration: const InputDecoration(labelText: 'Filter by status'),
        items: statuses
            .map((status) => DropdownMenuItem(value: status, child: Text(status.replaceAll('_', ' '))))
            .toList(),
        onChanged: (value) {
          if (value == null) return;
          setState(() {
            _status = value;
            _reload();
          });
        },
      ),
    );
  }
}

class _ComplaintAdminCard extends StatelessWidget {
  const _ComplaintAdminCard({required this.complaint, required this.onStatus, required this.onAssign});

  final Complaint complaint;
  final VoidCallback onStatus;
  final VoidCallback onAssign;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(complaint.title ?? 'Untitled complaint', style: Theme.of(context).textTheme.titleLarge)),
                Text(complaint.status?.replaceAll('_', ' ') ?? 'REPORTED', style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 8),
            Text(complaint.address ?? 'Address unavailable'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: OutlinedButton.icon(onPressed: onStatus, icon: const Icon(Icons.sync), label: const Text('Status'))),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton.icon(onPressed: onAssign, icon: const Icon(Icons.person_add_alt_1), label: const Text('Assign'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
