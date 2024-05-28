class Transaction {
  final String transactionId;
  final String type; // "credit" or "debit"
  final double amount;
  final String label;
  final DateTime date;
  final String? category;
  final String bankName; // Empty if manual

  Transaction({
    required this.transactionId,
    required this.type,
    required this.amount,
    required this.label,
    required this.date,
    this.category,
    required this.bankName,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transactionId'],
      type: json['type'],
      amount: json['amount'],
      label: json['label'],
      date: DateTime.parse(json['date']),
      category: json['category'],
      bankName: json['bankName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'type': type,
      'amount': amount,
      'label': label,
      'date': date.toIso8601String(),
      'category': category,
      'bankName': bankName,
    };
  }
}
