import 'package:adda/pages/login_page.dart';
import 'package:adda/services/auth_service.dart';
import 'package:adda/services/navigation_service.dart';
import 'package:adda/utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  //setting up firebase before starting

  await setup();
  runApp( MyApp());
}

//firebase setup function
Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await Firebase.initializeApp();
  await registerServices();
}

class MyApp extends StatelessWidget {

  final GetIt _getIt=GetIt.instance;
  late NavigationService _navigationService;
  late AuthService _authService;

   MyApp({super.key}){
     _navigationService=_getIt.get<NavigationService>();
     _authService=_getIt.get<AuthService>();

   }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigationService.navigatorKey,
      theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)
      ,textTheme: GoogleFonts.montserratTextTheme()),
      debugShowCheckedModeBanner: false,
      routes: _navigationService.routes,
      initialRoute: _authService.user!=null? "/home":"/login",
    );
  }
}
