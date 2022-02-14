import 'package:chat_system/Models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../services/database.dart';
import '../services/navigation.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationServices _navigationServices;
  late final DatabaseServices _databaseServices;
  late ChatUser user; 

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationServices = GetIt.instance.get<NavigationServices>();
    _databaseServices = GetIt.instance<DatabaseServices>();
    // _auth.signOut();

    _auth.authStateChanges().listen((_user) {
      if (_user != null) {
        print("auth state changed");
        _databaseServices.updateUserlastSeenTime(_user.uid);
        _databaseServices.getUser(_user.uid).then(
          (_snapshot) {
            print(_snapshot.data());
            Map<String, dynamic> _userData =
                _snapshot.data()! as Map<String, dynamic>;
            print("*" * 20);
            print(_userData.toString());

            print("*" * 20);
            print(_userData.containsKey("last_active"));
            user = ChatUser.fromJSON(
              {
                "uid": _user.uid,
                "name": _userData["name"],
                "email": _userData["email"],
                "last_active": _userData["last_active"],
                "image": _userData["image"]
              },
            );
            print('&' * 100);
            print(user.toMap());
            _navigationServices.removAndNavigateToRoute('/home'); //  naviate to home after login
          },
        );
        print('%' * 100);
        print('User loggedIN');
        // print(user.toMap());

      } else {
        print('Not Authenticated');
        _navigationServices.removAndNavigateToRoute('/login');
      }
    });
  }
  Future<void> loginUsingEmailAndPassword(
      String _email, String _password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      print(_auth.currentUser);
    } on FirebaseAuthException {
      print('Error Logging user into Firebase');
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUserUsingEmailAndPassword(
      String _email, String _password) async {
    try {
      UserCredential _credential = await _auth
          .createUserWithEmailAndPassword(email: _email, password: _password);
      return _credential.user!.uid;

    } on FirebaseAuthException{
      print('Firebse error');
    } catch (e) {
      print(e);
    }
  }
  Future<void> logout()async{
    try{
     await _auth.signOut();
    }catch(e){
      print(e);

    }
  }

}
