import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/Jewellery_Provider/BillGetProvider.dart';
import 'controllers/Jewellery_Provider/BillingOrderProvider.dart';
import 'controllers/Jewellery_Provider/BillingPrintProvider.dart';
import 'controllers/Jewellery_Provider/BillingReportProvider.dart';
import 'controllers/Jewellery_Provider/JwelProductProvider.dart';
import 'views/auth/login_view.dart';

void main() {
  runApp(
      MultiProvider(
          providers: [
            // Authencation provider
            ChangeNotifierProvider(create: (_) => JwelProductProvider()),
            ChangeNotifierProvider(create: (_) => BillProvider()),
            ChangeNotifierProvider(create: (_) => BillingOrderProvider()),
            ChangeNotifierProvider(create: (_) => BillingPrintProvider()),
            ChangeNotifierProvider(create: (_) => BillingReportProvider()),
          ],

      child:  MyApp()
      )
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login MVC',
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: const LoginView(),
    );
  }
}
