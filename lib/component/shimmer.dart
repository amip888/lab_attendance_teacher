import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Blink extends StatelessWidget {
  final bool isCircle;
  final double? borderRadius;
  final double? height;
  final double? width;
  final bool isVertical;
  final bool isHorizontal;
  final Widget? child;

  const Blink(
      {super.key,
      this.height,
      this.width,
      this.isCircle = false,
      this.isVertical = false,
      this.isHorizontal = false,
      this.child,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: child ??
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: isHorizontal
                    ? BorderRadius.horizontal(
                        left: Radius.circular(borderRadius ?? 16))
                    : isVertical
                        ? BorderRadius.vertical(
                            top: Radius.circular(borderRadius ?? 16))
                        : BorderRadius.all(Radius.circular(
                            isCircle ? 300 : borderRadius ?? 16))),
            height: height,
            width: width,
          ),
    );
  }
}
