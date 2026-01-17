import 'dart:io';
import 'package:flutter/material.dart';
import '../services/memory_service.dart';
import '../models/memory_model.dart';
import '../widgets/memory/upload_cta.dart';
import '../widgets/memory/memory_entry_card.dart';
import '../widgets/empty_state_widget.dart';

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({Key? key}) : super(key: key);

  @override
  _MemoryScreenState createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  final MemoryService _memoryService = MemoryService();
  List<MemoryEntry> _memories = [];
  bool _isLoading = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadMemories();
  }

  Future<void> _loadMemories() async {
    setState(() => _isLoading = true);
    try {
      final memories = await _memoryService.getMemories();
      setState(() {
        _memories = memories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to load memories: $e');
    }
  }

  Future<void> _onFileSelected(File file) async {
    setState(() => _isProcessing = true);
    
    try {
      // 1. Start upload
      final result = await _memoryService.uploadDocument(file: file);
      _showSuccess('Upload started successfully.');

      // 2. Poll for the new entry to appear
      final previousCount = _memories.length;
      final newEntry = await _memoryService.pollForNewEntry(previousCount);

      if (newEntry != null) {
        _showSuccess('Document processed and added to your Memory Bank!');
        await _loadMemories(); // Refresh the list
      } else {
        _showWarning('Document is still being processed. It will appear shortly.');
      }
    } catch (e) {
      _showError('Upload failed: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _deleteMemory(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Memory'),
        content: const Text('Are you sure you want to permanently delete this memory document? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _memoryService.deleteMemory(id);
        _showSuccess('Memory deleted');
        _loadMemories();
      } catch (e) {
        _showError('Failed to delete memory: $e');
      }
    }
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showWarning(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.orange),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Memory Bank',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personalize Your Coaching',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Upload your resume, LinkedIn profile, or other career documents. Our AI agent uses this context to provide personalized coaching feedback tailored to your specific background and goals.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 32),
              UploadCTA(
                isProcessing: _isProcessing,
                currentCount: _memories.length,
                onFileSelected: _onFileSelected,
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stored Memories',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (_isLoading)
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const Divider(height: 32),
              if (_isLoading && _memories.isEmpty)
                const Center(child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircularProgressIndicator(),
                ))
              else if (_memories.isEmpty)
                EmptyStateWidget(
                  icon: Icons.psychology_outlined,
                  title: 'No memories yet',
                  message: 'Upload a document to give the AI context about your career.',
                  onGetStarted: () {}, // Handled by UploadCTA
                  actionLabel: '',
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _memories.length,
                  itemBuilder: (context, index) {
                    return MemoryEntryCard(
                      entry: _memories[index],
                      onDelete: () => _deleteMemory(_memories[index].id),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
