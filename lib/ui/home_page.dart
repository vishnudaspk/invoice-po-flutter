import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:upd_invoice/services/openai_service.dart';
import 'package:upd_invoice/ui/image_preview.dart';
import 'package:upd_invoice/ui/purchase_order_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? _fileBytes;
  String? _fileName;
  bool _isUploading = false;
  final _conversionType = "Invoice to PO";

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
      );

      if (result != null) {
        setState(() {
          _fileBytes = result.files.first.bytes;
          _fileName = result.files.first.name;
        });
      }
    } catch (e) {
      log("Error picking file: $e");
    }
  }

  Future<void> _processFile() async {
    try {
      setState(() => _isUploading = true);
      Map<String, dynamic>? extractedData = await OpenAIService.processImage(
        _fileBytes!,
        _conversionType,
      );
      setState(() => _isUploading = false);

      if (extractedData != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PurchaseOrderPage(extractedData: extractedData, fileBytes: _fileBytes!),
          ),
        );
      }
    } catch (e) {
      log("Error processing file: $e");
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice <-> Purchase Order"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side: Drag & Drop Area
          Expanded(
            child: DragTarget<Uint8List>(
              onAcceptWithDetails: (data) {
                setState(() {
                  _fileBytes = data as Uint8List?;
                  _fileName = "Dropped File";
                });
              },
              builder: (context, candidateData, rejectedData) {
                return GestureDetector(
                  onTap: _pickFile,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_upload,
                              size: 50, color: Colors.blueAccent),
                          const SizedBox(height: 10),
                          const Text("Select or Drag & Drop a file",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          if (_fileName != null) ...[
                            const SizedBox(height: 10),
                            Text('Selected File: $_fileName',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400)),
                          ],
                          if (_fileBytes != null)
                            _isUploading
                                ? const CircularProgressIndicator()
                                : ElevatedButton.icon(
                                    icon: const Icon(Icons.cloud_upload),
                                    label: const Text("Upload & Process"),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 12),
                                      backgroundColor: Colors.green,
                                    ),
                                    onPressed: _processFile,
                                  ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 1),

          // Right Side: Image Preview
          // if (_fileBytes != null)
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 780,
                height: double.infinity,
                // color: Colors.red,
                child: _fileBytes != null
                    ? SingleChildScrollView(
                        child: ImagePreview(fileBytes: _fileBytes!))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.image, size: 50),
                          const Text("No Image Selected"),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
