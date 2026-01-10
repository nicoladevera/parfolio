import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../core/theme.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: AppColors.textMain),
            onPressed: () => Provider.of<AuthService>(context, listen: false).signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello,',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 48),
            ),
             Text(
              user?.email ?? 'User',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.primary),
            ),
            SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement recording flow
              },
              icon: Icon(Icons.mic),
              label: Text('Start New Recording'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
