import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Use 10.0.2.2 for Android emulator, localhost for iOS/Web
  // For physical device, you need your computer's IP
  static const String baseUrl = 'http://localhost:8000'; 
  
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> signInWithGoogle() async {
    try {
      // 1. Trigger Google Sign In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google Sign In aborted');

      // 2. Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase with the credential
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Google Sign In failed: $e');
    }
  }

  Future<UserCredential> login(String email, String password) async {
    try {
      // 1. Call backend to verify credentials and get custom token
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Login failed');
      }

      final data = jsonDecode(response.body);
      final customToken = data['token'];

      // 2. Sign in with custom token
      return await _firebaseAuth.signInWithCustomToken(customToken);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<UserModel> register(String email, String password, String displayName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'display_name': displayName,
        }),
      );

      if (response.statusCode != 201) {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Registration failed');
      }

      return UserModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<UserModel> getCurrentUserProfile() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('No user logged in');

      final token = await user.getIdToken();
      
      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch profile');
      }

      return UserModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Get profile failed: $e');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
  
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
