import 'package:banking_app/theme/custom_color.dart';
import 'package:flutter/material.dart';

const Color seedColor = Color(0xFF00576E);
final Color green = Colors.green[700]!;
final Color groceriesColor = Colors.green[400]!;
final Color rentColor = Colors.blue[700]!;
final Color utilitiesColor = Colors.orange[600]!;
final Color entertainmentColor = Colors.purple[600]!;
final Color transportationColor = Colors.blue[800]!;
final Color healthColor = Colors.red[600]!;
final Color insuranceColor = Colors.indigo[700]!;
final Color educationColor = Colors.teal[600]!;
final Color clothingColor = Colors.pink[400]!;
final Color giftsColor = Colors.amber[600]!;
final Color foodColor = Colors.deepOrange[400]!;
final Color travelColor = Colors.blue[300]!;
final Color investmentsColor = Colors.green[800]!;
final Color savingsColor = Colors.blueGrey[600]!;
final Color salaryColor = Colors.brown[600]!;
final Color bonusColor = Colors.deepPurple[400]!;
final Color interestColor = Colors.lightGreen[600]!;
final Color dividendsColor = Colors.lime[600]!;
final Color refundColor = Colors.cyan[600]!;
final Color otherColor = Colors.grey[600]!;

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
  useMaterial3: true,
  extensions: <ThemeExtension<dynamic>>[
    CustomColor(
      green: green,
      groceriesCategory: groceriesColor,
      rentCategory: rentColor,
      utilitiesCategory: utilitiesColor,
      entertainmentCategory: entertainmentColor,
      transportationCategory: transportationColor,
      healthCategory: healthColor,
      insuranceCategory: insuranceColor,
      educationCategory: educationColor,
      clothingCategory: clothingColor,
      giftsCategory: giftsColor,
      foodCategory: foodColor,
      travelCategory: travelColor,
      investmentsCategory: investmentsColor,
      savingsCategory: savingsColor,
      salaryCategory: salaryColor,
      bonusCategory: bonusColor,
      interestCategory: interestColor,
      dividendsCategory: dividendsColor,
      refundCategory: refundColor,
      otherCategory: otherColor,
    ),
  ],
);

final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
  extensions: <ThemeExtension<dynamic>>[
    CustomColor(
      green: toDarkThemeColor(green),
      groceriesCategory: toDarkThemeColor(groceriesColor),
      rentCategory: toDarkThemeColor(rentColor),
      utilitiesCategory: toDarkThemeColor(utilitiesColor),
      entertainmentCategory: toDarkThemeColor(entertainmentColor),
      transportationCategory: toDarkThemeColor(transportationColor),
      healthCategory: toDarkThemeColor(healthColor),
      insuranceCategory: toDarkThemeColor(insuranceColor),
      educationCategory: toDarkThemeColor(educationColor),
      clothingCategory: toDarkThemeColor(clothingColor),
      giftsCategory: toDarkThemeColor(giftsColor),
      foodCategory: toDarkThemeColor(foodColor),
      travelCategory: toDarkThemeColor(travelColor),
      investmentsCategory: toDarkThemeColor(investmentsColor),
      savingsCategory: toDarkThemeColor(savingsColor),
      salaryCategory: toDarkThemeColor(salaryColor),
      bonusCategory: toDarkThemeColor(bonusColor),
      interestCategory: toDarkThemeColor(interestColor),
      dividendsCategory: toDarkThemeColor(dividendsColor),
      refundCategory: toDarkThemeColor(refundColor),
      otherCategory: toDarkThemeColor(otherColor),
    ),
  ],
);

Color toDarkThemeColor(Color color) {
  return HSLColor.fromColor(color)
      .withSaturation(0.4)
      .withLightness(0.5)
      .toColor();
}
