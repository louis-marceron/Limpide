import 'package:flutter/material.dart';

@immutable
class CustomColor extends ThemeExtension<CustomColor> {
  const CustomColor({
    required this.green,
    required this.groceriesCategory,
    required this.rentCategory,
    required this.utilitiesCategory,
    required this.entertainmentCategory,
    required this.transportationCategory,
    required this.healthCategory,
    required this.insuranceCategory,
    required this.educationCategory,
    required this.clothingCategory,
    required this.giftsCategory,
    required this.foodCategory,
    required this.travelCategory,
    required this.investmentsCategory,
    required this.savingsCategory,
    required this.salaryCategory,
    required this.bonusCategory,
    required this.interestCategory,
    required this.dividendsCategory,
    required this.refundCategory,
    required this.otherCategory,
  });

  final Color? green;
  final Color? groceriesCategory;
  final Color? rentCategory;
  final Color? utilitiesCategory;
  final Color? entertainmentCategory;
  final Color? transportationCategory;
  final Color? healthCategory;
  final Color? insuranceCategory;
  final Color? educationCategory;
  final Color? clothingCategory;
  final Color? giftsCategory;
  final Color? foodCategory;
  final Color? travelCategory;
  final Color? investmentsCategory;
  final Color? savingsCategory;
  final Color? salaryCategory;
  final Color? bonusCategory;
  final Color? interestCategory;
  final Color? dividendsCategory;
  final Color? refundCategory;
  final Color? otherCategory;

  @override
  CustomColor copyWith({
    Color? green,
    Color? groceriesCategory,
    Color? rentCategory,
    Color? utilitiesCategory,
    Color? entertainmentCategory,
    Color? transportationCategory,
    Color? healthCategory,
    Color? insuranceCategory,
    Color? educationCategory,
    Color? clothingCategory,
    Color? giftsCategory,
    Color? foodCategory,
    Color? travelCategory,
    Color? investmentsCategory,
    Color? savingsCategory,
    Color? salaryCategory,
    Color? bonusCategory,
    Color? interestCategory,
    Color? dividendsCategory,
    Color? refundCategory,
    Color? otherCategory,
  }) {
    return CustomColor(
      green: green ?? this.green,
      groceriesCategory: groceriesCategory ?? this.groceriesCategory,
      rentCategory: rentCategory ?? this.rentCategory,
      utilitiesCategory: utilitiesCategory ?? this.utilitiesCategory,
      entertainmentCategory:
          entertainmentCategory ?? this.entertainmentCategory,
      transportationCategory:
          transportationCategory ?? this.transportationCategory,
      healthCategory: healthCategory ?? this.healthCategory,
      insuranceCategory: insuranceCategory ?? this.insuranceCategory,
      educationCategory: educationCategory ?? this.educationCategory,
      clothingCategory: clothingCategory ?? this.clothingCategory,
      giftsCategory: giftsCategory ?? this.giftsCategory,
      foodCategory: foodCategory ?? this.foodCategory,
      travelCategory: travelCategory ?? this.travelCategory,
      investmentsCategory: investmentsCategory ?? this.investmentsCategory,
      savingsCategory: savingsCategory ?? this.savingsCategory,
      salaryCategory: salaryCategory ?? this.salaryCategory,
      bonusCategory: bonusCategory ?? this.bonusCategory,
      interestCategory: interestCategory ?? this.interestCategory,
      dividendsCategory: dividendsCategory ?? this.dividendsCategory,
      refundCategory: refundCategory ?? this.refundCategory,
      otherCategory: otherCategory ?? this.otherCategory,
    );
  }

  @override
  CustomColor lerp(CustomColor? other, double t) {
    if (other is! CustomColor) {
      return this;
    }
    return CustomColor(
      green: Color.lerp(green, other.green, t),
      groceriesCategory:
          Color.lerp(groceriesCategory, other.groceriesCategory, t),
      rentCategory: Color.lerp(rentCategory, other.rentCategory, t),
      utilitiesCategory:
          Color.lerp(utilitiesCategory, other.utilitiesCategory, t),
      entertainmentCategory:
          Color.lerp(entertainmentCategory, other.entertainmentCategory, t),
      transportationCategory:
          Color.lerp(transportationCategory, other.transportationCategory, t),
      healthCategory: Color.lerp(healthCategory, other.healthCategory, t),
      insuranceCategory:
          Color.lerp(insuranceCategory, other.insuranceCategory, t),
      educationCategory:
          Color.lerp(educationCategory, other.educationCategory, t),
      clothingCategory: Color.lerp(clothingCategory, other.clothingCategory, t),
      giftsCategory: Color.lerp(giftsCategory, other.giftsCategory, t),
      foodCategory: Color.lerp(foodCategory, other.foodCategory, t),
      travelCategory: Color.lerp(travelCategory, other.travelCategory, t),
      investmentsCategory:
          Color.lerp(investmentsCategory, other.investmentsCategory, t),
      savingsCategory: Color.lerp(savingsCategory, other.savingsCategory, t),
      salaryCategory: Color.lerp(salaryCategory, other.salaryCategory, t),
      bonusCategory: Color.lerp(bonusCategory, other.bonusCategory, t),
      interestCategory: Color.lerp(interestCategory, other.interestCategory, t),
      dividendsCategory:
          Color.lerp(dividendsCategory, other.dividendsCategory, t),
      refundCategory: Color.lerp(refundCategory, other.refundCategory, t),
      otherCategory: Color.lerp(otherCategory, other.otherCategory, t),
    );
  }
}
