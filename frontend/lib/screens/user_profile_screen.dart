import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import '../services/profile_service.dart';
import '../core/shadows.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  
  UserModel? _user;
  bool _isLoading = true;
  bool _isSaving = false;
  
  // Web-compatible image storage
  XFile? _pickedImage;
  Uint8List? _webImageBytes;

  final TextEditingController _currentRoleController = TextEditingController();
  final TextEditingController _targetRoleController = TextEditingController();
  final TextEditingController _currentIndustryController = TextEditingController();
  final TextEditingController _targetIndustryController = TextEditingController();
  final TextEditingController _currentCompanyController = TextEditingController();

  CareerStage? _selectedCareerStage;
  Set<TransitionType> _selectedTransitionTypes = {};
  List<String> _targetCompanies = [];
  CompanySize? _selectedCurrentCompanySize;
  CompanySize? _selectedTargetCompanySize;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final user = await _profileService.getProfile();
      setState(() {
        _user = user;
        _currentRoleController.text = user.currentRole ?? '';
        _targetRoleController.text = user.targetRole ?? '';
        _currentIndustryController.text = user.currentIndustry ?? '';
        _targetIndustryController.text = user.targetIndustry ?? '';
        _currentCompanyController.text = user.currentCompany ?? '';
        _selectedCareerStage = user.careerStage;
        _selectedTransitionTypes = user.transitionTypes.toSet();
        _targetCompanies = List.from(user.targetCompanies);
        _selectedCurrentCompanySize = user.currentCompanySize;
        _selectedTargetCompanySize = user.targetCompanySize;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    debugPrint('_pickImage called');
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      debugPrint('Picker returned: $pickedFile');
      
      if (pickedFile != null) {
        // For web, read as bytes for display
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _pickedImage = pickedFile;
            _webImageBytes = bytes;
          });
          debugPrint('Web image loaded: ${bytes.length} bytes');
        } else {
          setState(() {
            _pickedImage = pickedFile;
          });
          debugPrint('Native image path: ${pickedFile.path}');
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      // Upload image to Firebase Storage if a new image was picked
      String? photoUrl = _user?.profilePhotoUrl;
      if (_pickedImage != null && _webImageBytes != null) {
        debugPrint('Starting photo upload...');
        try {
          final userId = FirebaseAuth.instance.currentUser?.uid;
          if (userId != null) {
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('users')
                .child(userId)
                .child('profile_photo.jpg');
            
            debugPrint('Uploading to: ${storageRef.fullPath}');
            
            // Upload with timeout
            final uploadTask = storageRef.putData(
              _webImageBytes!,
              SettableMetadata(contentType: 'image/jpeg'),
            );
            
            // Wait for upload with timeout
            final snapshot = await uploadTask.timeout(
              Duration(seconds: 30),
              onTimeout: () {
                debugPrint('Photo upload timed out');
                throw Exception('Upload timed out');
              },
            );
            
            photoUrl = await snapshot.ref.getDownloadURL();
            debugPrint('Photo uploaded successfully: $photoUrl');
          }
        } catch (e) {
          debugPrint('Error uploading photo: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Photo upload failed, saving profile without photo')),
          );
          // Continue without photo upload - use existing URL or null
        }
      }

      await _profileService.updateProfile(
        currentRole: _currentRoleController.text,
        targetRole: _targetRoleController.text,
        currentIndustry: _currentIndustryController.text,
        targetIndustry: _targetIndustryController.text,
        careerStage: _selectedCareerStage,
        transitionTypes: _selectedTransitionTypes.toList(),
        profilePhotoUrl: photoUrl,
        currentCompany: _currentCompanyController.text,
        targetCompanies: _targetCompanies,
        currentCompanySize: _selectedCurrentCompanySize,
        targetCompanySize: _selectedTargetCompanySize,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    } finally {
      setState(() => _isSaving = false);

    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFFE5E7EB), // Gray 200
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
            ),
          child: AppBar(
            title: Text('Your Profile', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF374151)), // Gray 700
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(theme),
                  SizedBox(height: 32),
                  _buildCombinedCareerSection(theme),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF65A30D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                        elevation: 2,
                      ),
                      child: _isSaving 
                        ? CircularProgressIndicator(color: Colors.white) 
                        : Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    // Determine the image to display
    ImageProvider? avatarImage;
    if (_webImageBytes != null) {
      avatarImage = MemoryImage(_webImageBytes!);
    } else if (_user?.profilePhotoUrl != null && _user!.profilePhotoUrl!.startsWith('http')) {
      avatarImage = NetworkImage(_user!.profilePhotoUrl!);
    }
    
    final bool hasImage = avatarImage != null;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: Shadows.md,
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    debugPrint('Profile photo tapped');
                    _pickImage();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFF65A30D).withOpacity(0.15),
                    backgroundImage: avatarImage,
                    child: !hasImage
                      ? Text(
                          (_user?.firstName?.substring(0, 1) ?? '').toUpperCase(),
                          style: TextStyle(
                            fontSize: 32, 
                            fontWeight: FontWeight.bold, 
                            color: Color(0xFF4D7C0F), // Darker lime green
                          ),
                        )
                      : null,
                  ),
                ),
              ),
              Positioned(
                bottom: -4,
                right: -4,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      debugPrint('Camera icon tapped');
                      _pickImage();
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.camera_alt, size: 14, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_user?.firstName ?? ''} ${_user?.lastName ?? ''}',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  _user?.email ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCombinedCareerSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CAREER DETAILS',
          style: theme.textTheme.labelSmall?.copyWith(
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF65A30D).withOpacity(0.8),
          ),
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
            boxShadow: Shadows.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                label: 'Current Role',
                controller: _currentRoleController,
                hint: 'Product Manager',
              ),
              SizedBox(height: 24),
              _buildTextField(
                label: 'Target Role',
                controller: _targetRoleController,
                hint: 'Senior Product Manager',
              ),
              SizedBox(height: 24),
              _buildTextField(
                label: 'Current Industry',
                controller: _currentIndustryController,
                hint: 'Fintech',
              ),
              SizedBox(height: 24),
              _buildTextField(
                label: 'Target Industry',
                controller: _targetIndustryController,
                hint: 'Climate Tech',
              ),
              SizedBox(height: 24),
              _buildTextField(
                label: 'Current Company',
                controller: _currentCompanyController,
                hint: 'Google',
              ),
              SizedBox(height: 24),
              _buildTargetCompaniesField(theme),
              SizedBox(height: 32),
              Text('Current Company Size', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: CompanySize.values.map((size) {
                  final isSelected = _selectedCurrentCompanySize == size;
                  return ChoiceChip(
                    showCheckmark: false,
                    label: Text(_formatCompanySize(size)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCurrentCompanySize = selected ? size : null);
                    },
                    selectedColor: Color(0xFF65A30D).withOpacity(0.15),
                    labelStyle: GoogleFonts.inter(
                      color: isSelected ? Color(0xFF4D7C0F) : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? Color(0xFF4D7C0F) : theme.colorScheme.outlineVariant,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 32),
              Text('Target Company Size', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: CompanySize.values.map((size) {
                  final isSelected = _selectedTargetCompanySize == size;
                  return ChoiceChip(
                    showCheckmark: false,
                    label: Text(_formatCompanySize(size)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedTargetCompanySize = selected ? size : null);
                    },
                    selectedColor: Color(0xFF65A30D).withOpacity(0.15),
                    labelStyle: GoogleFonts.inter(
                      color: isSelected ? Color(0xFF4D7C0F) : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? Color(0xFF4D7C0F) : theme.colorScheme.outlineVariant,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 32),
              Text('Career Stage', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: CareerStage.values.map((stage) {
                  final isSelected = _selectedCareerStage == stage;
                  return ChoiceChip(
                    showCheckmark: false,
                    label: Text(_formatCareerStage(stage)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCareerStage = selected ? stage : null);
                    },
                    selectedColor: Color(0xFF65A30D).withOpacity(0.15),
                    labelStyle: GoogleFonts.inter(
                      color: isSelected ? Color(0xFF4D7C0F) : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? Color(0xFF4D7C0F) : theme.colorScheme.outlineVariant,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 24),
              Text('Transition Type (select all that apply)', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: TransitionType.values.map((type) {
                  final isSelected = _selectedTransitionTypes.contains(type);
                  return FilterChip(
                    showCheckmark: false,
                    label: Text(_formatEnum(type)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTransitionTypes.add(type);
                        } else {
                          _selectedTransitionTypes.remove(type);
                        }
                      });
                    },
                    selectedColor: Color(0xFF65A30D).withOpacity(0.15),
                    labelStyle: GoogleFonts.inter(
                      color: isSelected ? Color(0xFF4D7C0F) : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? Color(0xFF4D7C0F) : theme.colorScheme.outlineVariant,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Example: $hint',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3),
              fontWeight: FontWeight.w300,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF65A30D)),
            ),
          ),
        ),
      ],
    );
  }

  String _formatCareerStage(CareerStage stage) {
    switch (stage) {
      case CareerStage.early_career:
        return 'Early career (0–3 years)';
      case CareerStage.mid_career:
        return 'Mid-career (4–10 years)';
      case CareerStage.senior_leadership:
        return 'Senior / Leadership';
    }
  }

  String _formatEnum(dynamic value) {
    String name = value.toString().split('.').last;
    name = name.replaceAll('_', ' ');
    return name.substring(0, 1).toUpperCase() + name.substring(1);
  }

  String _formatCompanySize(CompanySize size) {
    switch (size) {
      case CompanySize.startup:
        return 'Startup (<50)';
      case CompanySize.small:
        return 'Small (50-500)';
      case CompanySize.medium:
        return 'Medium (500-5K)';
      case CompanySize.enterprise:
        return 'Enterprise (5K+)';
    }
  }

  Widget _buildTargetCompaniesField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Target Companies (up to 5)', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        if (_targetCompanies.isEmpty)
          Text(
            'No target companies added yet',
            style: GoogleFonts.inter(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontSize: 14,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _targetCompanies.map((company) {
              return InputChip(
                label: Text(company),
                deleteIcon: Icon(Icons.close, size: 18),
                onDeleted: () {
                  setState(() {
                    _targetCompanies.remove(company);
                  });
                },
                backgroundColor: Color(0xFF65A30D).withOpacity(0.1),
                labelStyle: GoogleFonts.inter(
                  color: Color(0xFF4D7C0F),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Color(0xFF4D7C0F)),
                ),
              );
            }).toList(),
          ),
        SizedBox(height: 12),
        if (_targetCompanies.length < 5)
          OutlinedButton.icon(
            onPressed: _showAddCompanyDialog,
            icon: Icon(Icons.add, color: Color(0xFF4D7C0F)),
            label: Text('Add Company'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Color(0xFF4D7C0F),
              side: BorderSide(color: Color(0xFF4D7C0F)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _showAddCompanyDialog() async {
    final TextEditingController companyController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Target Company'),
          content: TextField(
            controller: companyController,
            decoration: InputDecoration(
              labelText: 'Company Name',
              hintText: 'Meta',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final company = companyController.text.trim();
                if (company.isNotEmpty && !_targetCompanies.contains(company)) {
                  setState(() {
                    _targetCompanies.add(company);
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF65A30D),
                foregroundColor: Colors.white,
              ),
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
