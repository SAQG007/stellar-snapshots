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
  static const _imgTitle = "Pillars of creation";
  static const _imgDate = "2023-13-07";
  static const _imgDescription = "The Ring Nebula (M57), is more complicated than it appears through a small telescope.  The easily visible central ring is about one light-year across, but this remarkable exposure by the James Webb Space Telescope explores this popular nebula with a deep exposure in infrared light. Strings of gas, like eyelashes around a cosmic eye, become evident around the Ring in this digitally enhanced featured image in assigned colors. These long filaments may be caused by shadowing of knots of dense gas in the ring from energetic light emitted within. The Ring Nebula is an elongated planetary nebula, a type of gas cloud created when a Sun-like star evolves to throw off its outer atmosphere to become a white dwarf star.  The central oval in the Ring Nebula lies about 2,500 light-years away toward the musical constellation Lyra.";

  var _showFullDescription = false;

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
                    _imgTitle,
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
                            _imgDate,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
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
                        style: const TextStyle(
                          fontSize: 14,
                        ),
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
