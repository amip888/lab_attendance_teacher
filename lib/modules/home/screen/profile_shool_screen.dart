import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';

class ProfileSchoolScreen extends StatefulWidget {
  const ProfileSchoolScreen({super.key});

  static const String path = '/profileSchool';
  static const String title = 'Profil Sekolah';

  @override
  State<ProfileSchoolScreen> createState() => _ProfileSchoolScreenState();
}

class _ProfileSchoolScreenState extends State<ProfileSchoolScreen> {
  List<String> misions = [
    'Menumbuhkan keimanan dan ketakwaan melalui pembiasaan beribadah.',
    'Mengoptimalkan proses pendidikan dan pelatihan bidang vokasi sesuai kebutuhan dunia usaha dan industri.',
    'Mengembangkan ilmu pengetahuan dan teknologi berdasarkan potensi, minat dan bakat.',
    'Menumbuhkan jiwa entrepreneurship, kreativitas kerja dan budaya industri yang terencana dan berkelanjutan.',
    'Menjalin kerjasama yang harmonis antar warga sekolah dan lembaga terkait.'
        'Menjadikan Sekolah sebagai Lembaga Sertifikasi Profesi Pihak Pertama (LSP-P1).'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ProfileSchoolScreen.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Pallete.primary2,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset('assets/images/pngs/logo_smk_talaga.png', width: 90),
            divide16,
            const Text(
              'SMK Negeri 1 Talaga adalah sekolah kejuruan negeri pertama di wilayah selatan Kab. Majalengka. Sekolah ini berdiri pada tahun 2006 dan berlokasi di desa Talagkulon, Talaga Kab. Majalengka. SMK Negeri 1 Talaga adalah sekolah kejuruan negeri pertama di wilayah selatan Kab. Majalengka. Sekolah ini berdiri pada tahun 2006 dan berlokasi di desa Talagkulon, Talaga Kab. Majalengka. Pada awalanya sekolah ini bernama SMK Bina Bangsa dengan akta yayasan bergabung dengan SMK Bina bangsa Yayasan Sedong Kabupaten Cirebon (Tahun 1999/2000), status masih menginduk pada yayasan tersebut. Bangunan yang digunakan yaitu Madrasah Diniyah (MD) PUI Talaga Wetan yang beralamat di Jalan Banjar layungan. Siswa yang ada pada wktu itu kurang lebih 15 orang, sampai mereka mengikuti ujian Nasional di SMK Negeri 1 Kadipaten (Filial) satu Program Keahliannya adalah Penjualan dari Bidang Keahlian Bisnis dan Manajemen. Pasilitas yang ada mempunyai computer sistem discard sebanyak 7 unit. Tenaga pengajar berjumlah 7 orang Yang dipimpin Oleh Seorang Kepala Sekolah Emad Andriana (Alm),itupun di bantu dari tenaga Sedong Cirebon. Kami berjuang terus di tahun-tahun berikutnya bersosialisasi ke SLTP yang berada di wilayah selatan, bahkaan ke Desa-desa di waktu Hari Jum’at, bekerja sama dengan para DKM. Alhamdulillah, setiap tahun pelajaran ada peningkatan penambahan siswa. Pertemuan antar pengurus yayasan pada akhirnya kami memisahkan diri dari yayasan Sedong Cirebon yaitu SMK Bina Bangsa Talaga pada awal tahun 2003/2004. Pada tahun 2004 Yayasan Bina Bangsa Talaga mendapat Kepala Sekolah Depinitif dari Dinas Pendidikan Kabupaten Majalengka (Drs.H.Acep Saepudin,M.Pd). Maka sejak itu sambil berbenah tentang sarana prasarana utamanya kelas yang digunakanan sudah tidak layak, beliau (Kepala Sekolah Depinitif) melobi kepada dinas Pendidikan Kabupaten Majalengka dan lembaga terkait, hingga mendapatkan kampus bekas SMPN 1 Talaga, dan SMK Bina Bangsa Talaga bisa menggunakan bangunan tersebut.Yayasan berkiprah dengan Kepala Depinitif terus sampai pada akhirnya hasil musyawarah, status siap di Negerikan mengingat di wilayah selatan Majalengka belum ada SMK Negeri. Selama kurun waktu 3 tahun kami bersama-sama mengurus penegerian dan pada saatnya yayasan SMK Bina Bangsa berubah status menjadi Negeri, Yaitu SMK Negeri 1 Talaga yang dipimpin oleh Kepala Sekolah (Drs.H.Wahyuddin,M.Pd) Setelah penegrian menjadi SMK Negeri 1 Talaga pada tahun 2006, maka sekolah ini kini mempunyai 4 Program Keahlian yaitu 1.Penjualan 2.Akuntans 3.Teknik Komputer dan Jaringan 4.Teknik Kendaraan Ringan, dan pada tahun 2014 ada penambahan 2 Program Kehlian yaitu 1.Teknik Sepeda Motor 2.Rekayasa Perangkat Lunak. Alhamdulillah Kampus SMK Negeri 1 Talaga kini mempunyai gedung baru 2 lantai yang dibangun pada awal tahun ajaran 2008/2009. Tahun 2010/2011 bertambah terus fasititas ruang pembelajaran terus dibangun, termasuk ruang praktek TSM, ruang Lab IPA dan Perpustakaan, sampai pada tahun 2014/2015 bangunan  lantai ke 3 dibangun  Ruang Belajar dan Ruang Praktek, serta Ruang Tata Usaha yang Revresentatif.',
              textAlign: TextAlign.justify,
            ),
            const Text(
              'PROGRAM KEAHLIAN Setiap program keahlian yang berada di bawah naungan SMKN 1 Talaga diharapkan bisa menjadi wadah siswa/siswi dalam menyalurkan bakat dan minatnya sehingga bisa berkontribusi dalam memajukan negeri. ADDRESS: JL. Sekolah, No No.20, Talagakulon, Talaga, Kabupaten Majalengka, Jawa Barat 45463 PHONE: 0233 319238 EMAIL: admin@smkn1talaga.sch.id',
              textAlign: TextAlign.justify,
            ),
            divide12,
            const Text('VISI'),
            divide8,
            const Text(
              '"TERWUJUDNYA CIVITAS AKADEMIK YANG RELIGIUS, CERDAS VOKASIONAL,  MEMILIKI DAYA KOMPETITIF UNGGUL, ENTREPRENEURSHIP DAN  MANDIRI PADA TAHUN 2022”',
              textAlign: TextAlign.center,
            ),
            divide12,
            const Text('MISI'),
            divide8,
            ListView.builder(
              itemCount: misions.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${index + 1}.  '),
                        Expanded(
                          child: Text(
                            misions[index],
                            maxLines: 5,
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    divide4
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
