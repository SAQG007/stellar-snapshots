import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
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
  var imgLink = 'https://apod.nasa.gov/apod/image/2308/sombrero_spitzer_3000.jpg';

  final Uri _linkedInUrl = Uri.parse('https://www.linkedin.com/in/syed-abdul-qadir-gillani/');

  Future<void> _openLinkedProfile() async {
    if (!await launchUrl(_linkedInUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_linkedInUrl');
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
              imageProvider: NetworkImage(imgLink),
              minScale: PhotoViewComputedScale.contained * 1,
              maxScale: PhotoViewComputedScale.covered * 1,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pillars of creation",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Divider(),
                  Table(
                    columnWidths: const <int, TableColumnWidth>{
                      0: FixedColumnWidth(55),
                    },
                    children: [
                      TableRow(
                        children: [
                          Text(
                            "Date:",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            "2023-13-07",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
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
            onPressed: () {},
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
