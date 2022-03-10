import 'package:chat_system/services/cloud_storage.dart';
import 'package:chat_system/services/database.dart';
import 'package:chat_system/services/media_serviceas.dart';
import 'package:chat_system/services/navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';





class SplashPage extends StatefulWidget {
  const SplashPage({required Key key, required this.onInitializationComplete}) : super(key: key);
  final VoidCallback onInitializationComplete;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((_) {
      _setUp().then((_) => widget.onInitializationComplete(),);
    });
  }
  Widget build(BuildContext context) {
    return Center(
      child: MaterialApp(
        title: 'Chatify',
        theme: ThemeData(
          backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
          scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
        ),home: Scaffold(
        body: Text('Chatify',style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold),),
      ),
      ),
    );
  }
}

Future<void> _setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  _registerServices();
}

void _registerServices() {
  GetIt.instance.registerSingleton<NavigationServices>(
    NavigationServices(),
  );
  GetIt.instance.
  registerSingleton<MediaServices>(MediaServices());
  GetIt.instance
      .registerSingleton<CloudStorageServices>(CloudStorageServices());
  GetIt.instance.
  registerSingleton<DatabaseServices>(DatabaseServices());
}

