// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';
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

  @override
  void initState() {
    super.initState();
    _checkImageCacheStatus();
    _getPackageInfo();
  }

  Future<void> _checkImageCacheStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // if the imgUrl in shared preferences is equal to incoming imgLink then the image is cached
    if(prefs.getString('imgUrl') == widget.imgLink) {
      setState(() {
        _isImageCached = true;
      });
    }
    else {
      setState(() {
        _isImageCached = false;
      });
      _setImageUrl();
    }
  }

  Future<void> _setImageUrl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('imgUrl', widget.imgLink);
  }

  // get package info for accessing app name
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

  void _shareImageDetails() async {
    await Share.share("Title: ${widget.imgTitle}\nDate: ${widget.imgDate}\n\nImage Link: ${widget.imgLink}\n\n${widget.imgDescription}");
  }

  void _downloadFile() {
    setState(() {
      _isFileDownloading = true;
    });
    
    FileDownloader.downloadFile(
      url: widget.imgLink,
      name: "$_appName - ${widget.imgDate}",
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
          // visible if the image is cached
          Visibility(
            visible: _isImageCached!,
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(widget.imgLink),
              minScale: PhotoViewComputedScale.contained * 1,
              maxScale: PhotoViewComputedScale.covered * 1,
              loadingBuilder: (context, event) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          // visible if the image is not cached
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
                    return PhotoView(
                      imageProvider: imageProvider,
                      minScale: PhotoViewComputedScale.contained * 1,
                      maxScale: PhotoViewComputedScale.covered * 1,
                  );
                }
              ),
            ),
          ),
          // visible if the user wants to show text i.e., _showText is true
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
        distance: 140,
        children: [
          // About FAB
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
            tooltip: "About",
            child: const Icon(Icons.info_outline),
          ),
          // toggle text FAB
          FloatingActionButton.small(
            onPressed: () {
              setState(() {
                _showText = !_showText;
              });
            },
            tooltip: "Show/Hide Text",
            child: Icon(_showText ? Icons.comments_disabled_outlined : Icons.comment_outlined),
          ),
          // Share FAB
          FloatingActionButton.small(
            onPressed: () {
              _shareImageDetails();
            },
            tooltip: "Share",
            child: const Icon(Icons.share_outlined),
          ),
          // Download FAB
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
            tooltip: "Download",
            child: !_isFileDownloading ?
              const Icon(Icons.download_outlined) :
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                ),
              ),
          ),
          // LinkedIn FAB
          FloatingActionButton.small(
            onPressed: _openLinkedProfile,
            backgroundColor: const Color(0xff0078d4),
            tooltip: "Open LinkedIn Profile",
            child: Image.asset(
              'assets/icons/linkedin.png',
            ),
          ),
        ],
      ),
    );
  }
}
