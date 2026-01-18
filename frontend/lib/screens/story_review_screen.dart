import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../core/spacing.dart';
import '../models/story_model.dart';
import '../services/story_service.dart';
import '../widgets/review/editable_par_section.dart';
import '../widgets/review/tag_editor.dart';
import '../widgets/review/coaching_display.dart';
import '../core/events.dart';

class StoryReviewScreen extends StatefulWidget {
  final String storyId;
  final bool isEditMode;

  const StoryReviewScreen({
    super.key,
    required this.storyId,
    this.isEditMode = false,
  });

  @override
  State<StoryReviewScreen> createState() => _StoryReviewScreenState();
}

class _StoryReviewScreenState extends State<StoryReviewScreen> {
  final StoryService _storyService = StoryService();
  
  StoryModel? _story;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  // Local state for edits
  late TextEditingController _titleController;
  String _problem = '';
  String _action = '';
  String _result = '';
  List<String> _tags = [];
  List<String> _warnings = [];
  late FocusNode _titleFocusNode;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _titleFocusNode = FocusNode();
    _loadStory();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadStory() async {
    try {
      final story = await _storyService.getStory(widget.storyId);
      if (mounted) {
        setState(() {
          _story = story;
          _titleController.text = story.title;
          _problem = story.problem;
          _action = story.action;
          _result = story.result;
          _tags = List<String>.from(story.tags);
          _warnings = List<String>.from(story.warnings);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveStory() async {
    setState(() => _isSaving = true);
    try {
      final updates = {
        'title': _titleController.text,
        'problem': _problem,
        'action': _action,
        'result': _result,
        'tags': _tags,
      };
      // Only set status to complete for new stories, not edit mode
      if (!widget.isEditMode) {
        updates['status'] = 'complete';
      }
      await _storyService.updateStory(widget.storyId, updates);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Story saved successfully!'),
            backgroundColor: Color(0xFF10B981), // Green 500
          ),
        );
        dashboardRefreshNotifier.notifyRefresh();
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save story: $e')),
        );
      }
    }
  }

  Future<void> _discardStory() async {
    if (_isSaving) return;

    // In edit mode, just go back without deleting
    if (widget.isEditMode) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard Changes?'),
          content: const Text('Your unsaved changes will be lost.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Keep Editing'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
              child: const Text('Discard'),
            ),
          ],
        ),
      );
      if (confirm == true && mounted) {
        Navigator.pop(context);
      }
      return;
    }

    // For new drafts, delete the story
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Story?'),
        content: const Text('This will permanently delete this draft. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep Editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isSaving = true);
      try {
        await _storyService.deleteStory(widget.storyId);
        if (mounted) {
          dashboardRefreshNotifier.notifyRefresh();
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete draft: $e')),
          );
        }
      }
    }
  }
  
  void _showWarningDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Analysis Warnings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _warnings
              .map((w) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('• $w'),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error loading story: $_error'),
              const SizedBox(height: Spacing.base),
              ElevatedButton(onPressed: _loadStory, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: () async {
        if (_isSaving) return false;
        await _discardStory();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 1),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withOpacity(0.5),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                onPressed: _isSaving ? null : _discardStory,
              ),
              title: Text(
                widget.isEditMode ? 'Edit Story' : 'Review Your Story',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section in Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.gray200),
                ),
                padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.md, Spacing.md, Spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TITLE',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                    TextFormField(
                      controller: _titleController,
                      focusNode: _titleFocusNode,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.gray900,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Enter a compelling title...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      maxLines: null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.xl),

              // PAR Sections
              EditablePARSection(
                label: 'Problem',
                content: _problem,
                onChanged: (val) => _problem = val,
              ),
              EditablePARSection(
                label: 'Action',
                content: _action,
                onChanged: (val) => _action = val,
              ),
              EditablePARSection(
                label: 'Result',
                content: _result,
                onChanged: (val) => _result = val,
              ),

              const SizedBox(height: Spacing.base),

              // Tags Section
              TagEditor(
                tags: _tags,
                onTagsChanged: (newTags) => setState(() => _tags = newTags),
              ),

              const SizedBox(height: Spacing.xl),
              const Divider(),
              const SizedBox(height: Spacing.xl),

              // Coaching Section
              Text(
                'COACHING INSIGHTS',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.gray600,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: Spacing.lg),
              CoachingDisplay(coaching: _story?.coaching),
              
              const SizedBox(height: 100), // Space for bottom bar
            ],
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_warnings.isNotEmpty)
              Container(
                color: const Color(0xFFF97316), // Orange 500
                padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Processed with ${_warnings.length} warning(s)',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showWarningDetails(context),
                      child: const Text(
                        'Details',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.all(Spacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSaving ? null : _discardStory,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        child: const Text('Discard'),
                      ),
                    ),
                    const SizedBox(width: Spacing.base),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveStory,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        child: _isSaving
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Save Story'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
