import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totel_x_task/view/auth/login_screen.dart';
import 'package:totel_x_task/view/home/home_screen.dart';
import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => UserController()),
      ],
      child: MaterialApp(
        title: 'User Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Sans',
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home:  LoginScreen(),
      ),
    );
  }
}