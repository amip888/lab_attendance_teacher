import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:math' as math show sin, pi;

class SpinKitFadingCube extends StatefulWidget {
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Color? color;
  final Duration? duration;
  final AnimationController? controller;
  const SpinKitFadingCube(
      {super.key,
      this.size = 50.0,
      this.itemBuilder,
      this.color,
      this.duration,
      this.controller})
      : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color');

  @override
  State<SpinKitFadingCube> createState() => _SpinKitFadingCubeState();
}

class _SpinKitFadingCubeState extends State<SpinKitFadingCube>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size.square(widget.size),
        child: Transform.rotate(
          angle: -45.0 * 0.0174533,
          child: Stack(
            children: List.generate(4, (index) {
              final size = widget.size * 0.5, position = widget.size * 0.5;
              return Positioned.fill(
                  top: position,
                  left: position,
                  child: Transform.scale(
                    scale: 1.1,
                    origin: Offset(-size * 0.5, -size * 0.5),
                    child: Transform(
                      transform: Matrix4.rotationZ(90.0 * index * 0.0174533),
                      child: Align(
                        alignment: Alignment.center,
                        child: FadeTransition(
                          opacity: DelayTween(
                                  begin: 0.0, end: 1.0, delay: 0.3 * index)
                              .animate(_controller),
                          child: SizedBox.fromSize(
                              size: Size.square(size),
                              child: itemBuilder(index)),
                        ),
                      ),
                    ),
                  ));
            }),
          ),
        ),
      ),
    );
  }

  Widget itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(decoration: BoxDecoration(color: widget.color));
}

class DelayTween extends Tween<double> {
  DelayTween({super.begin, super.end, required this.delay});
  final double delay;

  @override
  double lerp(double t) =>
      super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
