import 'package:chat_system/screens/Registration_page.dart';
import 'package:chat_system/screens/home_page.dart';
import 'package:chat_system/screens/splasePage.dart';
import 'package:chat_system/services/navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/LoginPage.dart';
import '../Providers/authentication.dart';

void main() {
  runApp(SplashPage(
    key: UniqueKey(),
    onInitializationComplete:(){
      runApp(MyApp());
    }

  ));
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<AuthenticationProvider>(create:(BuildContext _context){
        return AuthenticationProvider();
      })
    ],
    child: MaterialApp(
      title: 'Chat System',
      theme: ThemeData(
        backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
        scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
        // bottomNavigationBarTheme:BottomAppBarTheme
      ),
      navigatorKey: NavigationServices.NavigatorKey,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home' : (context) => HomePage(),
      },

    ),);
  }
}

