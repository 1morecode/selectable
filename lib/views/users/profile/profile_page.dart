//
// Created by 1 More Code on 12/11/24.
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authProvider, child) => Center(
        child: Column(
          children: [
            IconButton(
                onPressed: () {
                  authProvider.signOut();
                },
                icon: const Icon(Icons.logout)),
            const Text("Profile"),
          ],
        ),
      ),
    );
  }
}
