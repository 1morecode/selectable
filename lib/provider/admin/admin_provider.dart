import 'package:flutter/material.dart';

/// A provider class that manages the state for the currently selected item
/// in the admin navigation or menu. This class uses `ChangeNotifier` to notify
/// UI components about changes in the state.
class AdminProvider extends ChangeNotifier {
  /// The index of the currently selected navigation item.
  int _selectedIndex = 0;

  /// Getter to retrieve the currently selected index.
  int get selectedIndex => _selectedIndex;

  /// Updates the selected index and notifies listeners to refresh the UI.
  ///
  /// [index]: The index of the navigation item tapped by the admin user.
  void onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners(); // Notify listeners of the state change.
  }
}
