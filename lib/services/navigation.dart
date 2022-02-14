import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/cloud_storage.dart';
import '../services/media_serviceas.dart';
import 'package:get_it/get_it.dart';


class NavigationServices {
  static GlobalKey<NavigatorState> NavigatorKey =
      new GlobalKey<NavigatorState>();

  void removAndNavigateToRoute(String _route) {
    NavigatorKey.currentState?.popAndPushNamed(_route);
  }

  void navigateToRoute(String _route) {
    NavigatorKey.currentState?.pushNamed(_route);
  }

  void navigateToPage(Widget _page) {
    NavigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (BuildContext _context){
      return _page;
    }));
  }
  void goBack(){
    NavigatorKey.currentState?.pop();
  }

}

