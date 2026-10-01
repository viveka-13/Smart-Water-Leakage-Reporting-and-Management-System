import 'package:flutter/material.dart';

import '../../data/repositories/feedback_repository.dart';

class FeedbackScreen extends StatefulWidget {
  FeedbackScreen({super.key, required this.complaintId, FeedbackRepository? repository})
      : repository = repository ?? FeedbackRepository();

  final int complaintId;
  final FeedbackRepository repository;

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _commentController = TextEditingController();
  int _rating = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a rating first.')));
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await widget.repository.submitFeedback(
        complaintId: widget.complaintId,
        rating: _rating,
        comment: _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thank you for your feedback.')));
      Navigator.pop(context);
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Resolution')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('How was complaint #${widget.complaintId} handled?', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final value = index + 1;
              return IconButton(
                tooltip: '$value stars',
                onPressed: () => setState(() => _rating = value),
                icon: Icon(value <= _rating ? Icons.star : Icons.star_border, size: 42, color: Colors.amber.shade700),
              );
            }),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _commentController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Comment (optional)',
              hintText: 'Tell us about the resolution',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _isSubmitting ? null : _submit,
            icon: _isSubmitting ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send),
            label: const Text('Submit Feedback'),
          ),
        ],
      ),
    );
  }
}
