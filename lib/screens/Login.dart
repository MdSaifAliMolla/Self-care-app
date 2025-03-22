import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authProvider.signInWithGoogle();
          },
          child: Text('Sign In'),
        ),  
      )
    );
  }
}