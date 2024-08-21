import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgImage extends StatelessWidget {
  final String? svgSource;
  final double? height, width;
  final BoxFit? fit;
  final Color? color;
  const SvgImage(this.svgSource,
      {super.key, this.height, this.width, this.fit, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/svgs/$svgSource',
      height: height,
      width: width,
      color: color,
      fit: fit ?? BoxFit.cover,
    );
  }
}
