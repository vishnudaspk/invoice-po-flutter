import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<void> savePurchaseOrder(Map<String, dynamic> data) async {
    try {
      final response = await _supabase.from('PO details').insert([
        {
          'PO_id': data['po_number'],
          'supplier_details': {
            'name': data['supplier_details']['name'],
            'location': data['supplier_details']['location'],
            'delivery_date': data['delivery_date'],
          },
          'ship_to': {
            'name': data['ship_to']['name'],
            'address': data['ship_to']['address'],
          },
          'items': data['items'],
          'total_amount': data['total_amount'],
        }
      ]).select('PO_id');

      if (response.isNotEmpty) {
        log("Invoice Saved! PO Id: ${response[0]['PO_id']}");
      }
    } catch (e) {
      log("Error saving to DB: $e");
    }
  }
}
