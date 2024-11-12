import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/helper/global_data.dart';
import 'package:selectable/views/auth/admin_auth_screen.dart';
import 'package:selectable/views/auth/register_screen.dart';
import '../../provider/auth_provider.dart';
import '../widgets/custom_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<AuthService>(
      builder: (context, authService, child) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Sign In', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onSecondary),),
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
                      await authService.signIn();
                    },
                    child: const Text('Sign In'),
                  ))
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              CupertinoButton(
                onPressed: () {
                  authService.clearFields();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      )).then((value) {
                    authService.clearFields();
                  });
                },
                child: const Text("Don't have account? Sign Up"),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(border: Border(top: BorderSide(color: colorScheme.onSurface, width: 1))),
          child: CupertinoButton(child: const Text("Admin Login"), onPressed: (){
            authService.clearFields();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminAuthScreen(),
                )).then((value) {
              authService.clearFields();
            });
          },),
        ),
      ),
    );
  }
}
