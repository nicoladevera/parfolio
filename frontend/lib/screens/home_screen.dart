import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/story_service.dart';
import '../models/user_model.dart';
import '../models/story_model.dart';
import '../core/theme.dart';
import '../widgets/welcome_header.dart';
import '../widgets/recording_cta.dart';
import '../widgets/tag_filter_bar.dart';
import '../widgets/stories_list.dart';
import '../widgets/export_button.dart';
import 'recording_screen.dart';
import 'story_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StoryService _storyService = StoryService();
  
  UserModel? _currentUser;
  List<StoryModel> _stories = [];
  bool _isLoading = true;
  String _selectedTag = 'All';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    // Fetch user profile first (separate try block so it always succeeds)
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = await authService.getCurrentUserProfile();
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
    
    // Fetch stories separately (can fail without affecting user profile)
    try {
      final stories = await _storyService.getStories(tag: _selectedTag);
      if (mounted) {
        setState(() {
          _stories = stories;
        });
      }
    } catch (e) {
      // Stories endpoint may not exist yet - that's ok
      print('Error loading stories: $e');
    }
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _onTagSelected(String tag) {
    setState(() {
      _selectedTag = tag;
    });
    _loadData();
  }

  Future<void> _deleteStory(String id) async {
    // Optimistic update
    final originalStories = List<StoryModel>.from(_stories);
    setState(() {
      _stories.removeWhere((s) => s.id == id);
    });

    try {
      await _storyService.deleteStory(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Story deleted')),
      );
    } catch (e) {
      // Revert if failed
      if (mounted) {
        setState(() {
          _stories = originalStories;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete story')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSoft,
      appBar: AppBar(
        title: Text(
          'PARfolio', 
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          )
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          ExportButton(
            onExport: (format) async {
             _storyService.startExport(format);
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text('Export started for $format format...')),
             );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: AppColors.textMain),
            onPressed: () => Provider.of<AuthService>(context, listen: false).signOut(),
            tooltip: 'Sign Out',
          ),
          SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppColors.primary,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeHeader(
                user: _currentUser,
                storyCount: _stories.length,
              ),
              SizedBox(height: 32),
              RecordingCTA(
                onRecordPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => RecordingScreen()),
                  );
                },
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Stories',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TagFilterBar(
                selectedTag: _selectedTag,
                onTagSelected: _onTagSelected,
              ),
              SizedBox(height: 16),
              StoriesList(
                stories: _stories,
                isLoading: _isLoading,
                onStoryTap: (story) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoryDetailScreen(
                        story: story,
                        onDelete: _deleteStory,
                      ),
                    ),
                  ).then((_) => _loadData()); // Refresh on return in case of changes
                },
                onStoryDelete: (id) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Story'),
                        content: Text('Are you sure you want to delete this story?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _deleteStory(id);
                            },
                            child: Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                },
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
