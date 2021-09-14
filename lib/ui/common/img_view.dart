import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImgView extends StatelessWidget {
  final String img;
  const ImgView({Key? key, required this.img}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
          imageProvider: NetworkImage(img),
        )
    );
  }
}
