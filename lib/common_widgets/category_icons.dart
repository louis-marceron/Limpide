import 'package:flutter/material.dart';

class Category {
  final IconData icon;
  final Color color;

  Category({
    required this.icon,
    required this.color,
  });
}

// Define the colors for each category
const Color groceriesColor = Colors.greenAccent;
const Color rentColor = Colors.blueAccent;
const Color utilitiesColor = Colors.orangeAccent;
const Color entertainmentColor = Colors.purpleAccent;
const Color transportationColor = Colors.lightBlueAccent;
const Color healthColor = Colors.redAccent;
const Color insuranceColor = Colors.indigoAccent;
const Color educationColor = Colors.tealAccent;
const Color clothingColor = Colors.pinkAccent;
const Color giftsColor = Colors.amberAccent;
const Color foodColor = Colors.deepOrangeAccent;
const Color travelColor = Colors.cyanAccent;
const Color investmentsColor = Colors.green;
const Color savingsColor = Colors.blueGrey;
const Color salaryColor = Colors.brown;
const Color bonusColor = Colors.deepPurpleAccent;
const Color interestColor = Colors.lightGreen;
const Color dividendsColor = Colors.lime;
const Color refundColor = Colors.cyan;
const Color otherColor = Colors.grey;

final Map<String, Category> categories = {
  'Groceries': Category(icon: Icons.shopping_cart, color: groceriesColor),
  'Rent': Category(icon: Icons.home, color: rentColor),
  'Utilities': Category(icon: Icons.lightbulb_outline, color: utilitiesColor),
  'Entertainment': Category(icon: Icons.movie, color: entertainmentColor),
  'Transportation':
      Category(icon: Icons.directions_bus, color: transportationColor),
  'Health': Category(icon: Icons.local_hospital, color: healthColor),
  'Insurance': Category(icon: Icons.security, color: insuranceColor),
  'Education': Category(icon: Icons.school, color: educationColor),
  'Clothing': Category(icon: Icons.shopping_bag, color: clothingColor),
  'Gifts': Category(icon: Icons.card_giftcard, color: giftsColor),
  'Food': Category(icon: Icons.fastfood, color: foodColor),
  'Travel': Category(icon: Icons.flight, color: travelColor),
  'Investments': Category(icon: Icons.trending_up, color: investmentsColor),
  'Savings': Category(icon: Icons.account_balance, color: savingsColor),
  'Salary': Category(icon: Icons.work, color: salaryColor),
  'Bonus': Category(icon: Icons.card_giftcard, color: bonusColor),
  'Interest': Category(icon: Icons.account_balance, color: interestColor),
  'Dividends': Category(icon: Icons.account_balance, color: dividendsColor),
  'Refund': Category(icon: Icons.account_balance, color: refundColor),
  'Other': Category(icon: Icons.question_mark, color: otherColor),
};
