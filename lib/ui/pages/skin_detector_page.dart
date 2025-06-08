import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class SkinDetectorPage extends StatefulWidget {
  @override
  _SkinDetectorPageState createState() => _SkinDetectorPageState();
}

class _SkinDetectorPageState extends State<SkinDetectorPage> {
  File? _image;
  String? _prediction;
  double? _confidence;

  final picker = ImagePicker();
  final String baseUrl = 'http://10.0.167.239:8000'; // GANTI IP sesuai IP laptop kamu

  Future<void> pickImageAndPredict() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _prediction = null;
        _confidence = null;
      });

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/predict'),
      );
      request.files.add(await http.MultipartFile.fromPath('file', pickedFile.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final data = json.decode(respStr);

        setState(() {
          _prediction = data['prediction'];
          _confidence = data['confidence'];
        });
      } else {
        print('Error: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal prediksi')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Deteksi Penyakit Kulit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickImageAndPredict,
              child: Text('Pilih Gambar & Prediksi'),
            ),
            SizedBox(height: 20),
            if (_image != null)
              Image.file(_image!, height: 200),
            SizedBox(height: 20),
            if (_prediction != null)
              Text("Hasil Prediksi: $_prediction\nKepercayaan: ${(_confidence! * 100).toStringAsFixed(2)}%"),
          ],
        ),
      ),
    );
  }
}
