import 'package:flutter/material.dart';

import '../../data/repositories/worker_repository.dart';
import '../../models/complaint.dart';
import '../../widgets/session_logout_button.dart';

class WorkerTasksScreen extends StatefulWidget {
  WorkerTasksScreen({super.key, WorkerRepository? repository})
      : repository = repository ?? WorkerRepository();

  final WorkerRepository repository;

  @override
  State<WorkerTasksScreen> createState() => _WorkerTasksScreenState();
}

class _WorkerTasksScreenState extends State<WorkerTasksScreen> {
  late Future<List<Complaint>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _tasksFuture = widget.repository.getAssignedComplaints();
  }

  Future<void> _refresh() async {
    setState(_reload);
    await _tasksFuture;
  }

  Future<void> _updateStatus(Complaint complaint) async {
    if (complaint.id == null) return;
    final result = await showDialog<_StatusUpdate>(
      context: context,
      builder: (context) => const _StatusDialog(),
    );
    if (!mounted || result == null) return;

    try {
      await widget.repository.updateStatus(
        complaint.id!,
        result.status,
        remarks: result.remarks,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Work progress updated.')),
      );
      setState(_reload);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Tasks'),
        actions: [
          const SessionLogoutButton(),
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh), tooltip: 'Refresh tasks'),
        ],
      ),
      body: FutureBuilder<List<Complaint>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final tasks = snapshot.data ?? const <Complaint>[];
          if (tasks.isEmpty) {
            return const Center(child: Text('No assigned tasks right now.'));
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _TaskCard(
                complaint: tasks[index],
                onUpdate: () => _updateStatus(tasks[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.complaint, required this.onUpdate});

  final Complaint complaint;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(complaint.title ?? 'Untitled complaint', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(complaint.address ?? 'Address unavailable'),
            const SizedBox(height: 8),
            Text(complaint.description ?? 'No description provided.'),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onUpdate,
                icon: const Icon(Icons.update),
                label: Text('Update ${complaint.status?.replaceAll('_', ' ') ?? 'task'}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusUpdate {
  const _StatusUpdate(this.status, this.remarks);

  final String status;
  final String? remarks;
}

class _StatusDialog extends StatefulWidget {
  const _StatusDialog();

  @override
  State<_StatusDialog> createState() => _StatusDialogState();
}

class _StatusDialogState extends State<_StatusDialog> {
  final _remarksController = TextEditingController();
  String _status = 'IN_PROGRESS';

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update work progress'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _status,
            items: const [
              DropdownMenuItem(value: 'IN_PROGRESS', child: Text('In progress')),
              DropdownMenuItem(value: 'RESOLVED', child: Text('Resolved')),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _status = value);
            },
            decoration: const InputDecoration(labelText: 'Status'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _remarksController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Remarks'),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () => Navigator.pop(
            context,
            _StatusUpdate(_status, _remarksController.text.trim().isEmpty ? null : _remarksController.text.trim()),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
