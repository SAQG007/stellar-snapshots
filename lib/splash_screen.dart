// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nasa_apod/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // api url
  final String _apiUrl = "https://api.nasa.gov/planetary/apod?api_key=uQhkylW0hJgv4asx9U47a4IlQlbpbxiFspvb4nPB";

  String _imgLink = "";
  String _imgTitle = "";
  String _imgDate = "";
  String _imgDescription = "";

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();    
  }

  Future<void> _checkInternetConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if(connectivityResult == ConnectivityResult.none) {
        Fluttertoast.showToast(
          msg: "No internet connection",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
          backgroundColor: Colors.grey,
      );
    }
    else if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      _getApodData();
    }
  }

  Future<void> _getApodData() async {
    final response = await http.get(Uri.parse(_apiUrl));

    if(response.statusCode == 200) {
      final responseData = json.decode(response.body);

      setState(() {
        _imgLink = responseData['hdurl'];
        _imgTitle = responseData['title'];
        _imgDate = responseData['date'];
        _imgDescription = responseData['explanation'];

        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Home(
            imgLink: _imgLink,
            imgTitle: _imgTitle,
            imgDate: _imgDate,
            imgDescription: _imgDescription,
          ),
        ));
      });
    }
    else {
      print("Response Error: ${response.statusCode}");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Splash Screen", style: TextStyle(color: Colors.black),)
      ),
    );
  }
}
