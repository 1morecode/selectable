import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helper/global_data.dart';
import '../../provider/auth_provider.dart';
import '../widgets/custom_widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<AuthService>(
      builder: (context, authService, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Sign Up',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSecondary),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Image.asset(
                "assets/logo.png",
                height: size.height * 0.2,
              ),
              getFieldTitle("Display Name *", context),
              CupertinoTextField(
                controller: authService.nameController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                placeholder: "Enter Full Name",
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(
                height: 16,
              ),
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
              getFieldTitle("Phone *", context),
              CupertinoTextField(
                controller: authService.phoneController,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                placeholder: "Enter Phone",
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 16,
              ),
              getFieldTitle("Password *", context),
              CupertinoTextField(
                controller: authService.passwordController,
                obscureText: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                placeholder: "********",
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Expanded(
                      child: CupertinoButton(
                    color: colorScheme.primary,
                    onPressed: authService.isUserRegistrationLoading
                        ? null
                        : () async {
                      await authService.signUp();
                    },
                    child: authService.isUserRegistrationLoading
                        ? const CupertinoActivityIndicator()
                        : const Text('Sign Up'),
                  ))
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              CupertinoButton(
                onPressed: () {
                  authService.clearFields();
                  Navigator.of(context).pop();
                },
                child: const Text('Already have an account? Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
