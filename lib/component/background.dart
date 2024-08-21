import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final bool? isDashboard;
  const Background({
    super.key,
    this.isDashboard = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(children: [
        Image.asset(
          'assets/images/pngs/ic_background1.png',
          width: 67,
        ),
        // Image.asset('assets/images/ic_background2.png'),
        // Positioned(
        //   left: 290,
        //   top: isDashboard! ? 410 : 450,
        //   right: -5,
        //   bottom: 0,
        //   child: Image.asset('assets/images/pngs/ic_background2.png'),
        // )
      ]),
    );
  }
}
