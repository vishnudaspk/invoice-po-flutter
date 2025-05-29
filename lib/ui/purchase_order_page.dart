import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:upd_invoice/services/database_service.dart';



class PurchaseOrderPage extends StatefulWidget {
  final Map<String, dynamic> extractedData;
  

  const PurchaseOrderPage({super.key, required this.extractedData, required Uint8List fileBytes});

  @override
  State<PurchaseOrderPage> createState() => _PurchaseOrderPageState();
}

class _PurchaseOrderPageState extends State<PurchaseOrderPage> {
  final Map<String, TextEditingController> _controllers = {};
  final List<List<TextEditingController>> _tableControllers = [];
  List<String> _columnHeaders = [];
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _controllers['po_number'] = TextEditingController(text: widget.extractedData['po_number']);
    _controllers['delivery_date'] = TextEditingController(text: widget.extractedData['delivery_date']);
    _controllers['supplier_name'] = TextEditingController(text: widget.extractedData['supplier_details']['name']);
    _controllers['supplier_location'] = TextEditingController(text: widget.extractedData['supplier_details']['location']);
    _controllers['ship_to_name'] = TextEditingController(text: widget.extractedData['ship_to']['name']);
    _controllers['ship_to_address'] = TextEditingController(text: widget.extractedData['ship_to']['address']);
    _controllers['total_amount'] = TextEditingController(text: widget.extractedData['total_amount'].toString());

    _columnHeaders = widget.extractedData['items'][0].keys.toList();
    _tableControllers.clear();
    for (var item in widget.extractedData['items']) {
      var rowControllers = _columnHeaders.map((header) {
        return TextEditingController(text: item[header].toString());
      }).toList();
      _tableControllers.add(rowControllers);
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _saveEditedData();
      }
    });
  }

  void _saveEditedData() {
    widget.extractedData['po_number'] = _controllers['po_number']?.text;
    widget.extractedData['delivery_date'] = _controllers['delivery_date']?.text;
    widget.extractedData['supplier_details']['name'] = _controllers['supplier_name']?.text;
    widget.extractedData['supplier_details']['location'] = _controllers['supplier_location']?.text;
    widget.extractedData['ship_to']['name'] = _controllers['ship_to_name']?.text;
    widget.extractedData['ship_to']['address'] = _controllers['ship_to_address']?.text;
    widget.extractedData['total_amount'] = double.tryParse(_controllers['total_amount']?.text ?? '0');

    for (int i = 0; i < _tableControllers.length; i++) {
      for (int j = 0; j < _columnHeaders.length; j++) {
        widget.extractedData['items'][i][_columnHeaders[j]] = _tableControllers[i][j].text;
      }
    }
  }

  Future<void> _saveToDb() async {
    await DatabaseService.savePurchaseOrder(widget.extractedData);
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Purchase Order"),
      actions: [
        IconButton(
          icon: Icon(_isEditing ? Icons.save : Icons.edit),
          onPressed: _toggleEditMode,
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controllers['po_number'],
              decoration: InputDecoration(labelText: "PO Number"),
              readOnly: !_isEditing,
            ),
            TextField(
              controller: _controllers['delivery_date'],
              decoration: InputDecoration(labelText: "Delivery Date"),
              readOnly: !_isEditing,
            ),
            const SizedBox(height: 10),
            const Text("Supplier Details:", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _controllers['supplier_name'],
              decoration: InputDecoration(labelText: "Name"),
              readOnly: !_isEditing,
            ),
            TextField(
              controller: _controllers['supplier_location'],
              decoration: InputDecoration(labelText: "Location"),
              readOnly: !_isEditing,
            ),
            const SizedBox(height: 20),
            const Text("Ship To:", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _controllers['ship_to_name'],
              decoration: InputDecoration(labelText: "Name"),
              readOnly: !_isEditing,
            ),
            TextField(
              controller: _controllers['ship_to_address'],
              decoration: InputDecoration(labelText: "Address"),
              readOnly: !_isEditing,
            ),
            const SizedBox(height: 20),
            const Text("Items:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DataTable(
              columns: _columnHeaders.map((header) {
                return DataColumn(
                  label: Text(header, style: TextStyle(fontWeight: FontWeight.bold)),
                );
              }).toList(),
              rows: List.generate(_tableControllers.length, (index) {
                return DataRow(
                  cells: _columnHeaders.map((header) {
                    return DataCell(
                      TextField(
                        controller: _tableControllers[index][_columnHeaders.indexOf(header)],
                        readOnly: !_isEditing,
                      ),
                    );
                  }).toList(),
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text("Total Amount:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _controllers['total_amount'],
              decoration: InputDecoration(labelText: "Total Amount"),
              readOnly: !_isEditing,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Save to DB"),
              onPressed: _saveToDb,
            ),
          ],
        ),
      ),
    ),
  );
}
}

