import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/errors/app_exception.dart';
import '../../services/complaint_submission_service.dart';
import '../../services/offline_sync_service.dart';

class ReportComplaintScreen extends StatefulWidget {
  const ReportComplaintScreen({super.key});

  @override
  State<ReportComplaintScreen> createState() => _ReportComplaintScreenState();
}

class _ReportComplaintScreenState extends State<ReportComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final List<String> _categories = [
    'PIPE_LEAKAGE',
    'TANK_OVERFLOW',
    'DAMAGED_PIPELINE',
    'DRAINAGE_BLOCKAGE',
    'CONTAMINATED_WATER',
    'LOW_WATER_PRESSURE',
    'ILLEGAL_CONNECTION',
    'OTHER',
  ];
  final List<String> _priorities = ['LOW', 'MEDIUM', 'HIGH', 'EMERGENCY'];

  String _selectedCategory = 'PIPE_LEAKAGE';
  String _selectedPriority = 'MEDIUM';
  bool _isSubmitting = false;
  bool _isGettingLocation = false;

  @override
  void initState() {
    super.initState();
    unawaited(OfflineSyncService().syncPendingComplaints().catchError((_) => 0));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final reportData = {
        'title': _titleController.text.trim(),
        'category': _selectedCategory,
        'description': _descriptionController.text.trim(),
        'priority': _selectedPriority,
        'address': _addressController.text.trim(),
        'latitude': double.parse(_latitudeController.text.trim()),
        'longitude': double.parse(_longitudeController.text.trim()),
      };

      setState(() => _isSubmitting = true);
      try {
        final result = await ComplaintSubmissionService().submit(reportData);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result.queuedOffline
              ? 'No network. Complaint saved and will retry automatically.'
              : 'Complaint submitted successfully.'),
        ));
      } catch (error) {
        if (!mounted) return;
        final message = error is AppException ? error.message : error.toString();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isGettingLocation = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception('Enable location services and try again.');
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw Exception('Location permission was not granted.');
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      _latitudeController.text = position.latitude.toStringAsFixed(6);
      _longitudeController.text = position.longitude.toStringAsFixed(6);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not get your location: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGettingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Complaint')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report a water issue',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Complaint Title',
                    hintText: 'e.g. Pipe burst near market',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title is required.';
                    }
                    if (value.trim().length < 5) {
                      return 'Title must be at least 5 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: _categories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedCategory = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedPriority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: _priorities
                      .map((priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedPriority = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe the water problem in detail',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description is required.';
                    }
                    if (value.trim().length < 10) {
                      return 'Description must be at least 10 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    hintText: 'Enter exact location or nearest landmark',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Address is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _latitudeController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        decoration: const InputDecoration(labelText: 'Latitude'),
                        validator: (value) {
                          final latitude = double.tryParse(value?.trim() ?? '');
                          if (latitude == null || latitude < -90 || latitude > 90) {
                            return 'Enter a valid latitude.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _longitudeController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        decoration: const InputDecoration(labelText: 'Longitude'),
                        validator: (value) {
                          final longitude = double.tryParse(value?.trim() ?? '');
                          if (longitude == null || longitude < -180 || longitude > 180) {
                            return 'Enter a valid longitude.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isGettingLocation ? null : _useCurrentLocation,
                        icon: _isGettingLocation
                            ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.location_on_outlined),
                        label: Text(_isGettingLocation ? 'Getting location...' : 'Use Current Location'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitForm,
                    icon: _isSubmitting
                        ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.upload_file),
                    label: Text(_isSubmitting ? 'Submitting...' : 'Submit Complaint'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
