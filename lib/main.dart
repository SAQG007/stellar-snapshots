// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NASA APOD',
      theme: myTheme,
      home: const MyHomePage(title: 'NASA APOD'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // my mail address
  final String _mailAddress = "syedabdulqadirgillani807@gmail.com";

  // my LinkedIn url
  final Uri _linkedInUrl = Uri.parse('https://www.linkedin.com/in/syed-abdul-qadir-gillani/');

  // api response data storage variables
  String _imgLink = "https://apod.nasa.gov/apod/image/2308/M57_JwstKong_4532.jpg";
  String _imgTitle = "";
  String _imgDate = "";
  String _imgDescription = "";

  // api url
  final String _apiUrl = "https://api.nasa.gov/planetary/apod?api_key=uQhkylW0hJgv4asx9U47a4IlQlbpbxiFspvb4nPB";

  var _showFullDescription = false;

  @override
  void initState() {
    _getApodData();
    super.initState();
  }

  Future<void> _getApodData() async {
    final response = await http.get(Uri.parse(_apiUrl));

    if(response.statusCode == 200) {
      final _responseData = json.decode(response.body);

      setState(() {
        _imgTitle = _responseData['title'];
        _imgDate = _responseData['date'];
        _imgDescription = _responseData['explanation'];
      });
    }
    else {
      print("Response Error: ${response.statusCode}");
    }
  }

  Future<void> _openLinkedProfile() async {
    if (!await launchUrl(_linkedInUrl, mode: LaunchMode.externalApplication)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
            'Error while launching LinkedIn profile.',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _openMail() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: _mailAddress,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Stellar Snapshots Feedback',
      }),
    );

    if(await canLaunchUrl(emailLaunchUri)) {
      launchUrl(emailLaunchUri);
    }
    else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
            'Error while opening mail.',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Stack(
          children: [
            PhotoView(
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              imageProvider: NetworkImage(_imgLink),
              minScale: PhotoViewComputedScale.contained * 1,
              maxScale: PhotoViewComputedScale.covered * 1,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 35.0, 10.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _imgTitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Divider(),
                  Text(
                    "Date: $_imgDate",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showFullDescription = !_showFullDescription;
                        });
                      },
                      child: Text(
                        _imgDescription,
                        overflow: _showFullDescription ? TextOverflow.clip : TextOverflow.ellipsis,
                        maxLines: !_showFullDescription ? 3 : null,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        distance: 60,
        children: [
          FloatingActionButton.small(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Explore the cosmos through captivating imagery with our app powered by NASA's APOD API. Discover a daily dose of awe-inspiring astronomy pictures and expand your horizons.",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          "Send your feedback at:-",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _openMail();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            _mailAddress,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: const Icon(Icons.info_outline),
          ),
          FloatingActionButton.small(
            onPressed: _openLinkedProfile,
            backgroundColor: const Color.fromRGBO(0, 120, 212, 10),
            child: Image.asset(
              'assets/icons/linkedin.png',
            ),
          ),
        ],
      ),
    );
  }
}
