import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const AnalisisSentimenApp());
}

class AnalisisSentimenApp extends StatelessWidget {
  const AnalisisSentimenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Analisis Sentimen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const SentimenHome(),
    );
  }
}

class SentimenHome extends StatefulWidget {
  const SentimenHome({super.key});

  @override
  State<SentimenHome> createState() => _SentimenHomeState();
}

class _SentimenHomeState extends State<SentimenHome> {
  final TextEditingController komentarController = TextEditingController();
  static const String _apiUrl =
    'https://15240038-sentikampus-api.vercel.app';

  String _emote(String label) {
    switch (label.toLowerCase()) {
      case 'positive':
        return '😊';
      case 'negative':
        return '😞';
      case 'neutral':
        return '😐';
      default:
        return '🤔';
    }
  }

  String hasilLabel = '';
  double? hasilScore;
  bool loading = false;
  String? error;

  @override
  void dispose() {
    komentarController.dispose();
    super.dispose();
  }

  Future<void> analisisSentimen() async {
    final teks = komentarController.text.trim();
    if (teks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan komentar terlebih dahulu.')),
      );
      return;
    }

    setState(() {
      loading = true;
      error = null;
      hasilLabel = '';
      hasilScore = null;
    });
    try {
      final url = Uri.parse('$_apiUrl/api/v1/predict');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': teks}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          hasilLabel = data['label'];
          hasilScore = (data['score'] as num).toDouble();
        });
      } else {
        setState(() => error = 'Gagal: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => error = 'Tidak bisa terhubung ke API: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analisis Sentimen',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.school, size: 80, color: Colors.indigo),
            const SizedBox(height: 16),
            const Text(
              'Analisis Sentimen Kampus',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: komentarController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Komentar',
                hintText: 'Contoh: Pelayanan kampus sangat baik',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: loading ? null : analisisSentimen,
              icon: const Icon(Icons.analytics),
              label: Text(loading ? 'Memproses...' : 'Analisis Sentimen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 24),
            if (error != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(error!),
                ),
              ),
            if (hasilLabel.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        _emote(hasilLabel),
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        hasilLabel.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (hasilScore != null)
                        Text(
                          'Skor model: ${(hasilScore! * 100).toStringAsFixed(2)}%',
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
