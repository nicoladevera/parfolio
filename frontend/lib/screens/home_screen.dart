import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/shadows.dart';
import '../services/auth_service.dart';
import '../services/story_service.dart';
import '../services/tag_service.dart';
import '../models/user_model.dart';
import '../models/story_model.dart';
import '../widgets/profile_card.dart';
import '../widgets/recording_cta.dart';
import '../widgets/tag_filter_bar.dart';
import '../widgets/welcome_header.dart';
import '../widgets/stories_list.dart';
import '../widgets/auth/sunburst_decoration.dart';
import '../widgets/auth/wavy_line_decoration.dart';
import '../widgets/export_button.dart';
import 'recording_screen.dart';
import 'story_detail_screen.dart';
import 'story_review_screen.dart';
import 'user_profile_screen.dart';
import 'memory_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StoryService _storyService = StoryService();
  final TagService _tagService = TagService();
  
  UserModel? _currentUser;
  List<StoryModel> _stories = [];
  List<String> _tags = ['All'];
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
      final stories = await _storyService.getStories(
        tag: _selectedTag,
        status: 'complete', // Only show completed stories on dashboard
      );
      if (mounted) {
        setState(() {
          _stories = stories;
        });
      }
    } catch (e) {
      // Stories endpoint may not exist yet - that's ok
      print('Error loading stories: $e');
    }

    // Fetch tags
    try {
      final tags = await _tagService.getTags();
      if (mounted) {
        setState(() {
          _tags = ['All', ...tags];
        });
      }
    } catch (e) {
      print('Error loading tags: $e');
      if (mounted) {
        setState(() {
          _tags = TagFilterBar.defaultTags;
        });
      }
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
    final screenWidth = MediaQuery.of(context).size.width;
    final showDecorations = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white, // Clean white background
      body: Stack(
        children: [
          // Static background decorations (desktop only)
          if (showDecorations) ...[
            // Bottom-right: Wavy line
            Positioned(
              bottom: 40,
              right: -10,
              child: Opacity(
                opacity: 0.5,
                child: WavyLineDecoration(
                  color: const Color(0xFFA3E635), // Lime 300
                  width: 180,
                  height: 80,
                ),
              ),
            ),
          ],

          // Main Layout
          Column(
            children: [
              // Fixed Navigation Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xFFE5E7EB), // Gray 200
                      width: 1,
                    ),
                  ),
                  boxShadow: Shadows.md,
                ),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PARfolio',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.psychology_outlined,
                                color: Theme.of(context).colorScheme.onSurface),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => MemoryScreen()),
                              ).then((_) => _loadData());
                            },
                            tooltip: 'Memory Bank',
                          ),
                          ExportButton(
                            onExport: (format) async {
                              _storyService.startExport(format);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Export started for $format format...')),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.logout,
                                color: Theme.of(context).colorScheme.onSurface),
                            onPressed: () =>
                                Provider.of<AuthService>(context, listen: false).signOut(),
                            tooltip: 'Sign Out',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Scrollable Body
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadData,
                  color: Theme.of(context).colorScheme.primary,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24), // Spacing for visual separation from nav bar
                        screenWidth > 900
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WelcomeHeader(
                                    user: _currentUser,
                                    storyCount: _stories.length,
                                  ),
                                  SizedBox(height: 32),
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          flex: 3, // Wider ProfileCard (60%)
                                          child: ProfileCard(
                                            user: _currentUser,
                                            isMobile: false,
                                            onEditPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => UserProfileScreen()),
                                              ).then((_) => _loadData());
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 24),
                                        Expanded(
                                          flex: 2, // Narrower RecordingCTA (40%)
                                          child: RecordingCTA(
                                            isNarrow: false,
                                            onRecordPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => RecordingScreen()),
                                              ).then((_) => _loadData());
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  ProfileCard(
                                    user: _currentUser,
                                    isMobile: true,
                                    onEditPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => UserProfileScreen()),
                                      ).then((_) => _loadData());
                                    },
                                  ),
                                  SizedBox(height: 24),
                                  RecordingCTA(
                                    isNarrow: true,
                                    onRecordPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => RecordingScreen()),
                                      ).then((_) => _loadData());
                                    },
                                  ),
                                ],
                              ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your Stories',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        TagFilterBar(
                          selectedTag: _selectedTag,
                          tags: _tags,
                          onTagSelected: _onTagSelected,
                        ),
                        SizedBox(height: 16),
                        StoriesList(
                          stories: _stories,
                          isLoading: _isLoading,
                          onGetStarted: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => RecordingScreen()),
                            ).then((_) => _loadData());
                          },
                          onStoryTap: (story) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StoryDetailScreen(
                                  story: story,
                                  onDelete: _deleteStory,
                                ),
                              ),
                            ).then((_) => _loadData());
                          },
                          onStoryDelete: (id) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Story'),
                                content: Text(
                                    'Are you sure you want to delete this story?'),
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
                                    child: Text('Delete',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                          onStoryEdit: (story) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StoryReviewScreen(
                                  storyId: story.id,
                                  isEditMode: true,
                                ),
                              ),
                            ).then((_) => _loadData());
                          },
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

