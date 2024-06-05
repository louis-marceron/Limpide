import 'package:intl/intl.dart';

class OpenAiResponse {
  final String amount; //double
  final String merchantName;
  final String category;
  final String date; //DateTime
  final String label;

  OpenAiResponse({
    required this.amount,
    required this.merchantName,
    required this.category,
    required this.date,
    required this.label,
  });

  factory OpenAiResponse.fromJson(Map<String, dynamic> json) {
    return OpenAiResponse(
      amount: json['Amount'] ?? '',
      merchantName: json['Merchant Name'] ?? '',
      category: json['Category'] ?? '',
      date: json['Date'] ?? '',
      label: json['Label'] ?? '',
    );
  }
}
