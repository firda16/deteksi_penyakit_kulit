import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tubes_semester_6/shared/size_config.dart';
import 'package:tubes_semester_6/shared/theme.dart';
import 'package:tubes_semester_6/ui/pages/detail_result_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tubes_semester_6/main.dart'; // untuk akses plugin notifikasi

class ResultPage extends StatefulWidget {
  const ResultPage({
    Key? key,
    required this.image,
    required this.pred,
  }) : super(key: key);

  final File? image;
  final Map<String, dynamic> pred;

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  static const List<String> _penyakitYangDidukung = ['kutil', 'kurap', 'herpes'];

  static const Map<String, String> _namaPenyakit = {
    'kutil': 'Kutil',
    'kurap': 'Kurap',
    'herpes': 'Herpes',
  };

  @override
  void initState() {
    super.initState();
    _simpanKeFirestoreJikaValid();
  }

  Future<void> _simpanKeFirestoreJikaValid() async {
    final String prediksiDariAPI =
        widget.pred['prediction']?.toString().toLowerCase() ?? '';
    final double akurasi = widget.pred['confidence']?.toDouble() ?? 0.0;

    if (_penyakitYangDidukung.contains(prediksiDariAPI)) {
      await _simpanKeFirestore(prediksiDariAPI, akurasi);
      await _tampilkanNotifikasi(prediksiDariAPI, akurasi); // ⬅️ Tambahkan ini
    }
  }

  Future<void> _simpanKeFirestore(String penyakit, double akurasi) async {
    try {
      await FirebaseFirestore.instance.collection('hasil_deteksi').add({
        'penyakit': penyakit,
        'akurasi': akurasi,
        'tanggal': DateTime.now(),
      });
      print('✅ Data berhasil disimpan ke Firestore.');
    } catch (e) {
      print('❌ Gagal menyimpan data ke Firestore: $e');
    }
  }

  Future<void> _tampilkanNotifikasi(String penyakit, double akurasi) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'hasil_deteksi_channel',
      'Hasil Deteksi',
      channelDescription: 'Notifikasi setelah hasil deteksi berhasil disimpan',
      icon: 'ic_notification', 
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Deteksi Berhasil Disimpan',
      'Penyakit: ${penyakit.toUpperCase()} (Akurasi: ${(akurasi * 100).toStringAsFixed(1)}%)',
      platformDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String prediksiDariAPI =
        widget.pred['prediction']?.toString().toLowerCase() ?? '';
    final String namaPenyakit =
        _namaPenyakit[prediksiDariAPI] ?? 'Tidak Dikenali';
    final double akurasi = widget.pred['confidence']?.toDouble() ?? 0.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(prediksiDariAPI, namaPenyakit, akurasi),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      shadowColor: Colors.transparent,
      elevation: 0,
      backgroundColor: whiteColor,
      toolbarHeight: getProportionateScreenHeight(60),
      centerTitle: true,
      flexibleSpace: Container(
        padding: EdgeInsets.only(top: getProportionateScreenHeight(23)),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: blueColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                'Hasil',
                style: latoTextStyle.copyWith(
                  fontSize: getProportionateScreenWidth(20),
                  fontWeight: weightBold,
                  color: whiteColor,
                ),
              ),
            ),
            Positioned(
              right: getProportionateScreenWidth(20),
              top: getProportionateScreenHeight(20),
              child: GestureDetector(
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/main', (route) => false),
                child: Text(
                  'Selesai',
                  style: latoTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: weightBold,
                    color: whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(String prediksiDariAPI, String namaPenyakit, double akurasi) {
    if (!_penyakitYangDidukung.contains(prediksiDariAPI)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 20),
            Text(
              'Penyakit "$namaPenyakit" tidak dikenali\n'
              '(Akurasi: ${(akurasi * 100).toStringAsFixed(1)}%)\n\n'
              'Penyakit yang didukung: Kutil, Kurap, Herpes',
              style: latoTextStyle.copyWith(
                fontSize: getProportionateScreenWidth(18),
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    switch (prediksiDariAPI) {
      case 'kutil':
        return _tampilanDetailPenyakit(
          nama: 'Kutil',
          deskripsiSingkat: 'Kutil disebabkan oleh infeksi virus HPV...',
          deskripsiPanjang:
              'Kutil adalah pertumbuhan kecil pada kulit yang umumnya disebabkan oleh infeksi virus Human Papillomavirus (HPV). Virus ini memicu pertumbuhan sel kulit secara berlebihan, sehingga membentuk benjolan kasar di permukaan kulit. Kutil bisa muncul di berbagai bagian tubuh, seperti tangan, kaki, wajah, dan area kelamin (pada kasus tertentu disebut kutil kelamin). Kutil tidak selalu menimbulkan rasa sakit, namun bisa menjadi mengganggu secara estetika, dan pada beberapa kasus dapat terasa nyeri, terutama jika tumbuh di area yang sering bergesekan atau terbebani berat (seperti telapak kaki).',
          tips: '''
          1. Hindari kontak langsung dengan kutil
          2. Jaga kebersihan tangan
          3. Gunakan alas kaki di tempat umum''',
          daftarObat: [
            'assets/obat_kutil1.png',
            'assets/obat_kutil2.png',
            'assets/obat_kutil3.png',
            'assets/obat_kutil4.png'
          ],
        );
      case 'kurap':
        return _tampilanDetailPenyakit(
          nama: 'Kurap',
          deskripsiSingkat: 'Kurap disebabkan oleh infeksi jamur...',
          deskripsiPanjang:
              'Kurap (dalam istilah medis disebut tinea corporis) adalah infeksi kulit yang disebabkan oleh jamur dermatofita. Infeksi ini menimbulkan ruam berbentuk melingkar yang terasa gatal, bersisik, dan kadang-kadang menimbulkan peradangan di bagian pinggirnya. Kurap dapat menyerang kulit tubuh mana saja, termasuk wajah, leher, lengan, dan kaki. Penyakit ini sangat mudah menular, baik melalui kontak langsung kulit ke kulit dengan orang yang terinfeksi maupun melalui benda-benda yang terkontaminasi seperti pakaian, handuk, sprei, atau alat cukur. Hewan peliharaan seperti kucing dan anjing juga bisa menjadi sumber penularan.',
          tips: '''
          1. Cuci pakaian dan sprei secara teratur
          2. Jaga kebersihan lingkungan
          3. Hindari menggaruk area yang terinfeksi''',
          daftarObat: [
            'assets/obat_kurap1.png',
            'assets/obat_kurap2.png',
            'assets/obat_kurap3.png',
            'assets/obat_kurap4.png'
          ],
        );
      case 'herpes':
        return _tampilanDetailPenyakit(
          nama: 'Herpes',
          deskripsiSingkat: 'Herpes disebabkan oleh virus herpes simplex...',
          deskripsiPanjang:
              'Herpes adalah infeksi kulit yang disebabkan oleh virus herpes simpleks (HSV), yang dapat menimbulkan lepuhan berisi cairan pada kulit, terasa nyeri, gatal, dan dapat pecah membentuk luka terbuka. Virus ini terbagi menjadi dua tipe utama, yaitu HSV-1 (biasanya menyerang area mulut dan wajah) dan HSV-2 (biasanya menyerang area genital). Setelah infeksi pertama, virus ini akan tetap berada di dalam tubuh dalam keadaan tidak aktif (dorman), namun bisa kembali aktif sewaktu-waktu, terutama saat daya tahan tubuh melemah, stres, atau kelelahan.',
          tips: '''
          1. Hindari kontak kulit dengan penderita
          2. Tingkatkan daya tahan tubuh
          3. Gunakan obat antivirus''',
          daftarObat: [
            'assets/obat_herpes1.png',
            'assets/obat_herpes2.png',
            'assets/obat_herpes3.png',
            'assets/obat_herpes4.png'
          ],
        );
      default:
        return _tampilanTidakDikenali();
    }
  }

  Widget _tampilanDetailPenyakit({
    required String nama,
    required String deskripsiSingkat,
    required String deskripsiPanjang,
    required String tips,
    required List<String> daftarObat,
  }) {
    return DetailResultPage(
      image: widget.image,
      sDetail: deskripsiSingkat,
      lDetail: deskripsiPanjang,
      penyakit: nama,
      tips: tips,
      medicine: daftarObat,
    );
  }

  Widget _tampilanTidakDikenali() {
    return Center(
      child: Text(
        'Hasil prediksi tidak valid',
        style: latoTextStyle.copyWith(
          fontSize: getProportionateScreenWidth(20),
          color: Colors.red,
        ),
      ),
    );
  }
}