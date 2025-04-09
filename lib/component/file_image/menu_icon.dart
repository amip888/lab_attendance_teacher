import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';

class MenuIcon extends StatelessWidget {
  String? iconUrl, pngIcon;
  String? svgIcon;
  String title;
  bool isSvg;
  bool isPng;
  double? iconSize;
  Function() onTap;

  MenuIcon(
      {super.key,
      this.iconUrl,
      this.pngIcon,
      this.svgIcon,
      required this.title,
      required this.onTap,
      this.isSvg = false,
      this.isPng = false,
      this.iconSize});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isSvg
                ? SvgPicture.asset(
                    'assets/images/svgs/$svgIcon',
                    width: iconSize ?? 57,
                    height: iconSize ?? 57,
                  )
                : isPng
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/pngs/$pngIcon',
                          width: iconSize ?? 57,
                          height: iconSize ?? 57,
                        ),
                      )
                    : NetworkImagePlaceHolder(
                        height: iconSize ?? 57,
                        width: iconSize ?? 57,
                        isRounded: true,
                        imageUrl: iconUrl,
                      ),
            divide8,
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis)
          ],
        ),
      ),
    );
  }
}
