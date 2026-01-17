import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_picker/file_picker.dart';

class UploadCTA extends StatelessWidget {
  final bool isProcessing;
  final int currentCount;
  final Function(File) onFileSelected;

  const UploadCTA({
    Key? key,
    required this.isProcessing,
    required this.currentCount,
    required this.onFileSelected,
  }) : super(key: key);

  static const int maxFiles = 5;

  Future<void> _pickFile(BuildContext context) async {
    if (currentCount >= maxFiles) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Memory Bank is full. Please delete an entry to upload more.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'txt', 'md'],
      );

      if (result != null && result.files.single.path != null) {
        if (!context.mounted) return;
        onFileSelected(File(result.files.single.path!));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFull = currentCount >= maxFiles;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 48,
            color: isFull ? Colors.grey : Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            isFull ? 'Memory Bank Full' : 'Upload Context Document',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isFull ? Colors.grey : null,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Supported formats: PDF, DOCX, TXT, MD',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '$currentCount of $maxFiles slots used',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isFull ? Colors.orange : Colors.grey[600],
                  fontWeight: isFull ? FontWeight.bold : null,
                ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: (isProcessing || isFull) ? null : () => _pickFile(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 2,
              ),
              child: isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 200,
                      child: Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : const Text(
                      'Select File',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
