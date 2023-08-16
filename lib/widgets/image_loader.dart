import 'package:flutter/material.dart';

class ImageLoader extends StatefulWidget {
  final int cumulativeBytesLoaded;
  final int expectedTotalBytes;

  const ImageLoader({
    required this.cumulativeBytesLoaded,
    required this.expectedTotalBytes,
    Key? key
  }) : super(key: key);

  @override
  _ImageLoaderState createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Text(
            "${(widget.cumulativeBytesLoaded / (widget.expectedTotalBytes) * 100).toInt()}%",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        Center(
          child: CircularProgressIndicator(
            value:
                widget.cumulativeBytesLoaded / (widget.expectedTotalBytes),
          ),
        ),
      ],
    );
  }
}
