import 'package:flutter/material.dart';
import 'email_login.dart';
import 'phone_login.dart';
import '../widgets/animated_header.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            const AnimatedHeader(
              title: "Welcome",
              subtitle: "Login to continue",
            ),
            // const TabBar(
            //   tabs: [
            //     Tab(icon: Icon(Icons.email), text: "Email Login"),
            //     Tab(icon: Icon(Icons.phone), text: "OTP Login"),
            //   ],
            // ),
            Expanded(
              child: TabBarView(
                children: [LoginToggleView(), PhoneLoginView()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
