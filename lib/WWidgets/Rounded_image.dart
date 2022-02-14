// import 'dart:html';

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class RoundedImage extends StatelessWidget {
  final String imagePath;
  final double size;
  const RoundedImage(
      {required Key key, 
      required this.size, 
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size * 15,
      width: size * 15,
      decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(imagePath),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
          color: Colors.black),
    );
  }
}

class RoundedImageFile extends StatelessWidget {
  final PlatformFile image;
  final double size;
  const RoundedImageFile(
      {required Key key, required this.size, required this.image});

  @override
  Widget build(BuildContext context) {
    File imageFile = File(image.path.toString());
    return Container(
      height: size,
      width: 100,
      decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: FileImage(imageFile),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(size),
          ),
          color: Colors.black),
    );
  }
}

class RoundedImageNetworkWithStatusIndicator extends RoundedImage {
  const RoundedImageNetworkWithStatusIndicator({
    required Key key,
    required String imagePath,
    required double size,
    required this.isActive,
  }) : super(
          key: key,
          imagePath: imagePath,
          size: size,
        );
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      
      children: [
        super.build(context),
        Container(
          height: size * 0.20,
          width: size * 0.20,
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(size*10),
          ),
        )
      ],
    );
  }
}
