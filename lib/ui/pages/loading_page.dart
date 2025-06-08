import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:tubes_semester_6/shared/size_config.dart';
import 'package:tubes_semester_6/shared/theme.dart';
import 'package:tubes_semester_6/ui/pages/result_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key, required this.image}) : super(key: key);
  final File? image;

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _sendToServer();
  }

  Future<void> _sendToServer() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.2:8000/predict'),
      );
      request.files.add(
        await http.MultipartFile.fromPath('file', widget.image!.path),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResult = json.decode(responseBody);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              image: widget.image,
              pred: jsonResult,
            ),
          ),
        );
      } else {
        _showError("Server returned error ${response.statusCode}");
      }
    } catch (e) {
      _showError("Connection failed: $e");
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog( 
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        appBar: AppBar(
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
            child: Center(
              child: Text(
                'Scan',
                style: latoTextStyle.copyWith(
                  fontSize: getProportionateScreenWidth(20),
                  fontWeight: weightBold,
                  color: whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Kami sedang memindai, harap tunggu ...',
                style: latoTextStyle.copyWith(
                  fontSize: getProportionateScreenWidth(20),
                  fontWeight: weightBold,
                  color: blueColor,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(40)),
                child: Lottie.asset(
                  'assets/loading.json',
                  height: getProportionateScreenHeight(200),
                  width: getProportionateScreenWidth(200),
                ),
              ),
              Text(
                '“Kebersihan adalah satu-satunya cara\nuntuk menjauhkan semua penyakit.”',
                style: latoTextStyle.copyWith(
                  fontSize: getProportionateScreenWidth(20),
                  fontWeight: weightBold,
                  color: blueColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
