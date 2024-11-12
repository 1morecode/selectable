import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/helper/global_data.dart';
import '../../provider/auth_provider.dart';
import '../widgets/custom_widgets.dart';

class AdminAuthScreen extends StatelessWidget {
  const AdminAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<AuthService>(
      builder: (context, authService, child) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Admin Sign In', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onSecondary),),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Image.asset("assets/logo.png", height: size.height*0.3,),
              getFieldTitle("Email *", context),
              CupertinoTextField(
                controller: authService.emailController,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                placeholder: "Enter Email",
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 16,
              ),
              getFieldTitle("Password *", context),
              CupertinoTextField(
                controller: authService.passwordController,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                placeholder: "********",
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Expanded(child: CupertinoButton(
                    color: colorScheme.primary,
                    onPressed: () async {
                      await authService.adminSignIn();
                    },
                    child: const Text('Sign In'),
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
