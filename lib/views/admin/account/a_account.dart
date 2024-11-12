//
// Created by 1 More Code on 09/11/24.
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/provider/auth_provider.dart';

class AAccount extends StatelessWidget {
  const AAccount({super.key});

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
            const Text("Account"),
          ],
        ),
      ),
    );
  }
}
