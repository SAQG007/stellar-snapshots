import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
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

  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    // _getApodData();

    _getApodData();

    // Timer(const Duration(seconds: 2), () {
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(imgLink: _imgLink, imgTitle: _imgTitle, imgDate: _imgDate, imgDescription: _imgDescription)));
    // });
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
        child: Text("Splash Screen")
      ),
    );
  }
}
