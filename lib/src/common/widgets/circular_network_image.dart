import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CircularNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final double borderWidth;
  final Color borderColor;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CircularNetworkImage({
    Key? key,
    required this.imageUrl,
    this.size = 60.0,
    this.borderWidth = 2.0,
    this.borderColor = Colors.grey,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: borderColor,
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: fit,
          placeholder: (context, url) => placeholder ?? const CircularProgressIndicator(),
          errorWidget: (context, url, error) => errorWidget ??
              const Icon(Icons.error, color: Colors.red),
        ),
      ),
    );
  }
}
