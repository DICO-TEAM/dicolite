import 'package:dicolite/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewImage extends StatelessWidget {
  const ViewImage({
    required this.imageProvider, 
    required this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    required this.heroTag, 
  });
  final ImageProvider imageProvider;
  final BoxDecoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black26,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          children: <Widget>[
            LoadingWidget(),
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: 
              PhotoView(
                imageProvider: imageProvider,
                backgroundDecoration: backgroundDecoration,
                minScale: minScale,
                maxScale: maxScale,
                heroAttributes: PhotoViewHeroAttributes(tag: heroTag),
                enableRotation: false,
              ),
            ),
            Positioned(
              right: 10,
              top: MediaQuery.of(context).padding.top,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
