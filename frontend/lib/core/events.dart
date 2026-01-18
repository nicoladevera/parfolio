import 'package:flutter/foundation.dart';

/// A simple notifier to trigger global UI refreshes (e.g., Dashboard list)
class RefreshNotifier extends ChangeNotifier {
  void notifyRefresh() {
    notifyListeners();
  }
}

/// The global instance for dashboard-related refreshes
final dashboardRefreshNotifier = RefreshNotifier();
