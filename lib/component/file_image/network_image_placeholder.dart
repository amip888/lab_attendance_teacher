import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/services/api/environment.dart';

class NetworkImagePlaceHolder extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool? click;
  final BorderRadius? borderRadius;
  final bool isRounded;
  final bool isCircle;
  final Color? color;

  const NetworkImagePlaceHolder({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.click = false,
    this.borderRadius,
    this.isRounded = false,
    this.isCircle = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ??
          (isRounded
              ? const BorderRadius.all(Radius.circular(12))
              : (isCircle
                  ? const BorderRadius.all(Radius.circular(300))
                  : BorderRadius.zero)),
      child: CachedNetworkImage(
        // imageUrl:
        //     'http://192.168.43.18:3000/file/get-image/2024-09-06T15-42-40-247Z-image_cropper_1725637342685.jpg',
        // imageUrl:
        //     '${Environment.endpointFile}2024-09-06T15-42-40-247Z-image_cropper_1725637342685.jpg',
        imageUrl: '${Environment.endpointFile}$imageUrl',
        fit: fit ?? BoxFit.cover,
        width: width,
        height: height,
        placeholder: (context, url) => SpinKitCircle(
          color: color ?? Pallete.primary,
          size: 20,
        ),
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/pngs/ic_image_blank.png',
          fit: fit ?? BoxFit.cover,
          height: height,
          width: height,
        ),
      ),
    );
  }
}
