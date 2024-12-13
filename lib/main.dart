// main.dart
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GeneratePdfPage(),
    );
  }
}

class GeneratePdfPage extends StatefulWidget {
  const GeneratePdfPage({super.key});

  @override
  _GeneratePdfPageState createState() => _GeneratePdfPageState();
}

class _GeneratePdfPageState extends State<GeneratePdfPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Генерация PDF
                final pdfFile = await _generatePdf(
                  _titleController.text,
                  _contentController.text,
                );

                // Открытие файла в приложении просмотра
                await Printing.sharePdf(
                  bytes: pdfFile.readAsBytesSync(),
                  filename: 'example.pdf',
                );
              },
              child: const Text('Generate PDF'),
            ),
          ],
        ),
      ),
    );
  }

  Future<File> _generatePdf(String title, String content) async {
    // Создаем объект документа
    final pdf = pw.Document();

    // Добавляем страницу с текстом
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              content,
              style: const pw.TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );

    // Получаем путь для сохранения файла
    final outputDir = await getApplicationDocumentsDirectory();
    final outputFile = File("${outputDir.path}/example.pdf");

    // Сохраняем PDF в файл
    await outputFile.writeAsBytes(await pdf.save());

    return outputFile;
  }
}
