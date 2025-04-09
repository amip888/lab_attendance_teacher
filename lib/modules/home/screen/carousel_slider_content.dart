import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/shimmer.dart';

final List<ContentSlider> contentSliders = [
  ContentSlider(
    title: 'Profil SMK N 1 Talaga',
    background: 'background_slider1.jpeg',
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/pngs/logo_smk_talaga.png', width: 50),
          divideW10,
          const Expanded(
            child: Text(
              'SMK Negeri 1 Talaga adalah sekolah kejuruan negeri pertama di wilayah selatan Kab. Majalengka. Sekolah ini berdiri pada tahun 2006 dan berlokasi di desa Talagkulon, Talaga Kab... ',
              textAlign: TextAlign.justify,
              maxLines: 5,
              style: TextStyle(overflow: TextOverflow.ellipsis),
            ),
          )
        ],
      ),
    ),
  ),
  ContentSlider(
    background: 'background_slider.jpeg',
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Visi:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          divide2,
          const Text(
            'TERWUJUDNYA CIVITAS AKADEMIK YANG RELIGIUS, CERDAS VOKASIONAL,  MEMILIKI DAYA KOMPETITIF UNGGUL, ENTREPRENEURSHIP DAN  MANDIRI PADA TAHUN 2022',
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 12),
          ),
          divide4,
          const Text('Misi:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          divide2,
          contentMission(
              'Menumbuhkan keimanan dan ketakwaan melalui pembiasaan beribadah.'),
          contentMission(
              'Mengoptimalkan proses pendidikan dan pelatihan bidang vokasi sesuai kebutuhan dunia usaha dan industri.')
        ],
      ),
    ),
  ),
  ContentSlider(
    title: 'Jurusan SMK N 1 Talaga',
    background: 'background_slider1.jpeg',
    content: Padding(
      padding: const EdgeInsets.only(top: 16, right: 8, left: 8, bottom: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child:
                          Image.asset('assets/images/pngs/tkr.jpg', width: 70)),
                  divide8,
                  const Text('TKR'),
                ],
              ),
              Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child:
                          Image.asset('assets/images/pngs/tkj.jpg', width: 70)),
                  divide8,
                  const Text('TKJ'),
                ],
              ),
              Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child:
                          Image.asset('assets/images/pngs/rpl.jpg', width: 70)),
                  divide8,
                  const Text('RPL'),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  )
];

contentMission(String content) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.symmetric(vertical: 7),
        height: 5,
        width: 5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100), color: Colors.white),
      ),
      divideW6,
      Expanded(
        child: Text(
          content,
          textAlign: TextAlign.justify,
          maxLines: 2,
          style: const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 12),
        ),
      ),
    ],
  );
}

class CarouselSliderContent {
  static final List<Widget> imageSliders = contentSliders
      .map((item) => Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(width: 2, color: Pallete.border),
              // gradient: RadialGradient(
              //     colors: [Pallete.primary2, Pallete.border],
              //     center: Alignment.center,
              //     focal: Alignment.bottomCenter,
              //     focalRadius: 10)
              // color: Pallete.primary2,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/pngs/${item.background}',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  if (item.title != null)
                    Positioned(
                      top: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        alignment: Alignment.topCenter,
                        decoration: const BoxDecoration(
                            // gradient: LinearGradient(
                            //   colors: [
                            //     Color.fromARGB(0, 0, 0, 0),
                            //     Color.fromARGB(200, 0, 0, 0),
                            //   ],
                            //   begin: Alignment.bottomCenter,
                            //   end: Alignment.topCenter,
                            // ),
                            ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          item.title!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(top: item.title != null ? 27 : 0),
                    child: item.content,
                  ),
                ],
              ),
            ),
          ))
      .toList();

  static final List<Widget> shimmerSliders = contentSliders
      .map((item) => Container(
            margin: const EdgeInsets.all(5.0),
            child: const Blink(
              borderRadius: 5,
            ),
          ))
      .toList();
}

class ContentSlider {
  String? title, background;
  Widget content;
  ContentSlider({this.title, this.background, required this.content});
}
