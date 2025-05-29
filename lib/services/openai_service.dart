import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  static Future<Map<String, dynamic>?> processImage(
      Uint8List fileBytes, String conversionType) async {
    String? apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      log("Error: API key is missing!");
      return null;
    }

    String prompt = conversionType == "Invoice to PO"
        ? "Extract structured details from the invoice image and return only a JSON response. "
            "Ensure the JSON follows this format exactly: "
            "{ "
            "   'po_number': '...', "
            "   'delivery_date': '...', "
            "   'supplier_details': {'name': '...', 'location': '...'}, "
            "   'ship_to': {'name': '...', 'address': '...'}, "
            "   'items': [ "
            "       {'item_name': '...', 'uom': '...', 'quantity': ..., 'unit_price': ..., 'total': ...} "
            "   ], "
            "   'total_amount': ... "
            "} "
            "If any field is missing, use 'n/a' as the value. "
            "Do not include explanations, introductions, or anything other than valid JSON output."
        : "Extract text from this purchase order and format it as an invoice.";

    String base64Image = base64Encode(fileBytes);
    try {
      var response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-4o",
          "messages": [
            {"role": "system", "content": prompt},
            {
              "role": "user",
              "content": [
                {
                  "type": "text",
                  "text": "Extract and return structured JSON data."
                },
                {
                  "type": "image_url",
                  "image_url": {"url": "data:image/png;base64,$base64Image"}
                }
              ],
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        String cleanResponse =
            response.body.replaceAll(RegExp(r'```json|```'), '');
        var data = jsonDecode(cleanResponse);
        return jsonDecode(data["choices"][0]["message"]["content"].trim());
      } else {
        log("Error: Received status code ${response.statusCode}");
      }
    } catch (e) {
      log("Error uploading file: $e");
    }
    return null;
  }
}
