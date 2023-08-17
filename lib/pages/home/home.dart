// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nasa_apod/widgets/image_loader.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  final String imgLink;
  final String imgTitle;
  final String imgDate;
  final String imgDescription;

  const Home({
    Key? key,
    required this.imgLink,
    required this.imgTitle,
    required this.imgDate,
    required this.imgDescription,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // my mail address
  final String _mailAddress = "syedabdulqadirgillani807@gmail.com";

  // my LinkedIn url
  final Uri _linkedInUrl = Uri.parse('https://www.linkedin.com/in/syed-abdul-qadir-gillani/');
  
  String _appName = "";

  bool _showFullDescription = false;
  bool _showText = true;
  bool _isFileDownloading = false;
  bool? _isImageCached = false;
  
  int _downloadedImageBytes = 0;
  int _totalImageExpectedBytes = 0;

  @override
  void initState() {
    super.initState();
    _getImageCacheStatus();
    _getPackageInfo();
  }

  Future<void> _setImageCacheStatus(bool status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isImageCached', status);
    await prefs.setString('imgUrl', widget.imgLink);
  }

  Future<void> _getImageCacheStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getString('imgUrl') == widget.imgLink) {
      setState(() {
        _isImageCached = prefs.getBool('isImageCached');
      });
    }
    else {
      _setImageCacheStatus(false);
    }
  }

  Future<void> _getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appName = packageInfo.appName;
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

  void _downloadFile() {
    _isFileDownloading = true;
    
    FileDownloader.downloadFile(
      url: widget.imgLink,
      name: "$_appName - ${widget.imgDate}",
      onProgress: (String? fileName, double progress) {
        setState(() {
          _downloadedImageBytes = ((progress / 100) * _totalImageExpectedBytes).toInt();
        });
      },
      onDownloadCompleted: (String? message) {
        Fluttertoast.showToast(
          msg: "Download Complete",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
          backgroundColor: Theme.of(context).colorScheme.onSurface,
        );
        setState(() {
          _isFileDownloading = false;
        });
      },
    );
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
      body: Stack(
        children: [
          Visibility(
            visible: _isImageCached!,
            child: PhotoView(
              backgroundDecoration: const BoxDecoration(
                color: Colors.red,
              ),
              imageProvider: CachedNetworkImageProvider(widget.imgLink),
              minScale: PhotoViewComputedScale.contained * 1,
              maxScale: PhotoViewComputedScale.covered * 1,
              loadingBuilder: (context, event) {
                if (event == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else {
                  _totalImageExpectedBytes = event.expectedTotalBytes ?? 1;
                  return ImageLoader(
                    cumulativeBytesLoaded: event.cumulativeBytesLoaded,
                    expectedTotalBytes: event.expectedTotalBytes ?? 1,
                  );
                }
              },
            ),
          ),
          Visibility(
            visible: !_isImageCached!,
            child: Center(
              child: CachedNetworkImage(
                  imageUrl: widget.imgLink,
                  filterQuality: FilterQuality.high,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  progressIndicatorBuilder: (context, url, downloadProgress) {
                    return CircularProgressIndicator(
                      value: downloadProgress.progress,
                    );
                  },
                  imageBuilder: (context, imageProvider) {
                    _setImageCacheStatus(true);

                    return PhotoView(
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.blue,
                      ),
                      imageProvider: imageProvider,
                      minScale: PhotoViewComputedScale.contained * 1,
                      maxScale: PhotoViewComputedScale.covered * 1,
                  );
                }
              ),
            ),
          ),
          Visibility(
            visible: _showText,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 35.0, 10.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.imgTitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Divider(),
                  Text(
                    "Date: ${widget.imgDate}",
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
                        widget.imgDescription,
                        overflow: _showFullDescription ? TextOverflow.clip : TextOverflow.ellipsis,
                        maxLines: !_showFullDescription ? 3 : null,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        distance: 110,
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
                      const Text(
                        "Explore the cosmos through captivating imagery with this app powered by NASA's APOD API. Discover a daily dose of awe-inspiring astronomy pictures and expand your horizons.",
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          "Send your feedback at:-",
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
                            style: Theme.of(context).textTheme.labelMedium,
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
            onPressed: () {
              setState(() {
                _showText = !_showText;
              });
            },
            child: Icon(_showText ? Icons.comments_disabled_outlined : Icons.comment_outlined),
          ),
          FloatingActionButton.small(
            onPressed: () {
              !_isFileDownloading ?
              _downloadFile() :
              Fluttertoast.showToast(
                msg: "Download in progress",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                fontSize: 16.0,
                backgroundColor: Theme.of(context).colorScheme.onSurface,
              );
            },
            child: !_isFileDownloading ?
              const Icon(Icons.download_outlined) :
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: _downloadedImageBytes > 0 ?
                // show ImageLoader() if _downloadedImageBytes > 0
                ImageLoader(
                  cumulativeBytesLoaded: _downloadedImageBytes,
                  expectedTotalBytes: _totalImageExpectedBytes
                ) :
                // show CircularProgressIndicator() if _downloadedImageBytes <= 0
                const CircularProgressIndicator(),
              ),
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
