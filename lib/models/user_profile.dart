// models/user_profile.dart
import 'package:flutter/foundation.dart';

class UserProfile extends ChangeNotifier {
  String name = '';
  int age = 0;
  String gender = 'Male';
  double weight = 0;
  String weightUnit = 'kg';
  double height = 0;
  String heightUnit = 'cm';
  String fitnessGoal = 'Weight Loss';
  List<String> healthConditions = [];

  // Convert weight to kg for calculations
  double get weightInKg {
    return weightUnit == 'kg' ? weight : weight * 0.453592;
  }

  // Convert height to cm for calculations
  double get heightInCm {
    return heightUnit == 'cm' ? height : height * 2.54;
  }

  // Calculate BMI
  double get bmi {
    if (height <= 0) return 0;
    double heightInMeters = heightInCm / 100;
    return weightInKg / (heightInMeters * heightInMeters);
  }

  // Get BMI category
  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  // Update profile data
  void updateProfile({
    String? name,
    int? age,
    String? gender,
    double? weight,
    String? weightUnit,
    double? height,
    String? heightUnit,
    String? fitnessGoal,
    List<String>? healthConditions,
  }) {
    this.name = name ?? this.name;
    this.age = age ?? this.age;
    this.gender = gender ?? this.gender;
    this.weight = weight ?? this.weight;
    this.weightUnit = weightUnit ?? this.weightUnit;
    this.height = height ?? this.height;
    this.heightUnit = heightUnit ?? this.heightUnit;
    this.fitnessGoal = fitnessGoal ?? this.fitnessGoal;
    this.healthConditions = healthConditions ?? this.healthConditions;

    notifyListeners();
  }
}
