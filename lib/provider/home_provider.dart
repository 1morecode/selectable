import 'package:flutter/material.dart';

/// A provider class that manages the state for the currently selected item
/// in a navigation bar or menu. It uses the `ChangeNotifier` to notify
/// listeners about state changes.
class HomeProvider extends ChangeNotifier {
  /// The currently selected index in the navigation bar.
  int _selectedIndex = 0;

  /// Getter to access the current selected index.
  int get selectedIndex => _selectedIndex;

  /// Updates the selected index and notifies listeners to rebuild the UI.
  ///
  /// [index]: The new index selected by the user.
  void onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners(); // Notify listeners about the state change.
  }
}
