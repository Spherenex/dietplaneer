// services/analytics_service.dart
import 'dart:math';
import '../models/user_profile.dart';

class AnalyticsService {
  // Simulate ML model for calculating recommended calories
  static Map<String, dynamic> getRecommendedNutrition(UserProfile profile) {
    // Base metabolic rate calculation using Harris-Benedict Equation
    double bmr;
    if (profile.gender == 'Male') {
      bmr =
          88.362 +
          (13.397 * profile.weightInKg) +
          (4.799 * profile.heightInCm) -
          (5.677 * profile.age);
    } else {
      bmr =
          447.593 +
          (9.247 * profile.weightInKg) +
          (3.098 * profile.heightInCm) -
          (4.330 * profile.age);
    }

    // Activity factor (simplified)
    double activityFactor = 1.2; // Sedentary

    // Adjust calories based on fitness goal
    double goalMultiplier;
    switch (profile.fitnessGoal) {
      case 'Weight Loss':
        goalMultiplier = 0.8;
        break;
      case 'Muscle Gain':
        goalMultiplier = 1.15;
        break;
      case 'Athletic Performance':
        goalMultiplier = 1.2;
        break;
      default:
        goalMultiplier = 1.0; // Maintenance
    }

    // Calculate TDEE (Total Daily Energy Expenditure)
    int calories = (bmr * activityFactor * goalMultiplier).round();

    // Adjust for health conditions
    if (profile.healthConditions.contains('Diabetes')) {
      calories = (calories * 0.9).round(); // Lower calories for diabetes
    }
    if (profile.healthConditions.contains(
      'Hypertension (High Blood Pressure)',
    )) {
      calories = (calories * 0.95).round(); // Slightly lower for hypertension
    }

    // Calculate macronutrients based on goals
    int protein, carbs, fat;

    switch (profile.fitnessGoal) {
      case 'Weight Loss':
        protein =
            (profile.weightInKg * 2.2)
                .round(); // Higher protein for weight loss
        fat = (calories * 0.3 / 9).round(); // 30% from fat
        carbs =
            ((calories - (protein * 4) - (fat * 9)) / 4)
                .round(); // Remainder from carbs
        break;
      case 'Muscle Gain':
        protein =
            (profile.weightInKg * 2.5)
                .round(); // Very high protein for muscle gain
        fat = (calories * 0.25 / 9).round(); // 25% from fat
        carbs =
            ((calories - (protein * 4) - (fat * 9)) / 4)
                .round(); // Remainder from carbs
        break;
      default:
        protein = (profile.weightInKg * 1.8).round(); // Moderate protein
        fat = (calories * 0.3 / 9).round(); // 30% from fat
        carbs =
            ((calories - (protein * 4) - (fat * 9)) / 4)
                .round(); // Remainder from carbs
    }

    // Adjust for health conditions
    if (profile.healthConditions.contains('Heart Disease') ||
        profile.healthConditions.contains('High Cholesterol')) {
      fat = (fat * 0.8).round(); // Lower fat for heart conditions
      protein = (protein * 1.1).round(); // Increase protein slightly
      carbs =
          ((calories - (protein * 4) - (fat * 9)) / 4)
              .round(); // Recalculate carbs
    }

    if (profile.healthConditions.contains('Diabetes')) {
      carbs = (carbs * 0.8).round(); // Lower carbs for diabetes
      protein = (protein * 1.2).round(); // Increase protein
      fat =
          ((calories - (protein * 4) - (carbs * 4)) / 9)
              .round(); // Recalculate fat
    }

    // Water recommendation (in cups)
    int water = (profile.weightInKg * 0.033).round() + 2;

    // Generate synthetic daily data for charts (last 7 days)
    List<int> calorieDaily = List.generate(7, (index) {
      // Create realistic variation around the target
      double variation = Random().nextDouble() * 0.2 - 0.1; // -10% to +10%
      return (calories * (1 + variation)).round();
    });

    List<int> proteinDaily = List.generate(7, (index) {
      double variation = Random().nextDouble() * 0.15 - 0.05; // -5% to +10%
      return (protein * (1 + variation)).round();
    });

    List<int> carbsDaily = List.generate(7, (index) {
      double variation = Random().nextDouble() * 0.25 - 0.15; // -15% to +10%
      return (carbs * (1 + variation)).round();
    });

    List<int> fatDaily = List.generate(7, (index) {
      double variation = Random().nextDouble() * 0.2 - 0.1; // -10% to +10%
      return (fat * (1 + variation)).round();
    });

    // Calculate trends based on simulated data
    String calorieTrend = _calculateTrend(calorieDaily);
    String proteinTrend = _calculateTrend(proteinDaily);
    String carbsTrend = _calculateTrend(carbsDaily);
    String fatTrend = _calculateTrend(fatDaily);

    // Generate weight data based on profile and goal
    List<Map<String, dynamic>> weightData = _generateWeightData(profile);

    // Create personalized meal ratings based on goal
    List<Map<String, dynamic>> mealRatings = _generateMealRatings(profile);

    // Generate nutrition insights based on profile data
    List<Map<String, dynamic>> insights = _generateInsights(
      profile,
      calorieDaily,
      proteinDaily,
      carbsDaily,
    );

    // Return the complete analytics data
    return {
      'calories': {
        'goal': calories,
        'current': calorieDaily.last,
        'average': calorieDaily.reduce((a, b) => a + b) ~/ calorieDaily.length,
        'trend': calorieTrend,
        'daily': calorieDaily,
      },
      'protein': {
        'goal': protein,
        'current': proteinDaily.last,
        'average': proteinDaily.reduce((a, b) => a + b) ~/ proteinDaily.length,
        'trend': proteinTrend,
        'daily': proteinDaily,
      },
      'carbs': {
        'goal': carbs,
        'current': carbsDaily.last,
        'average': carbsDaily.reduce((a, b) => a + b) ~/ carbsDaily.length,
        'trend': carbsTrend,
        'daily': carbsDaily,
      },
      'fat': {
        'goal': fat,
        'current': fatDaily.last,
        'average': fatDaily.reduce((a, b) => a + b) ~/ fatDaily.length,
        'trend': fatTrend,
        'daily': fatDaily,
      },
      'water': {
        'goal': water,
        'current': water - Random().nextInt(3),
        'average': water - 1,
        'trend': 'stable',
        'daily': List.generate(
          7,
          (index) => max(1, water - Random().nextInt(4)),
        ),
      },
      'weightData': weightData,
      'mealRatings': mealRatings,
      'insights': insights,
      'nutrientBalance': {
        'protein': (protein * 4 / calories * 100).round(),
        'carbs': (carbs * 4 / calories * 100).round(),
        'fat': (fat * 9 / calories * 100).round(),
      },
      'wellnessScore': _calculateWellnessScore(
        profile,
        calorieDaily,
        proteinDaily,
      ),
    };
  }

  // Helper method to calculate trend
  static String _calculateTrend(List<int> data) {
    if (data.length < 3) return 'stable';

    int recent = data.sublist(data.length - 3).reduce((a, b) => a + b);
    int earlier = data.sublist(0, 3).reduce((a, b) => a + b);

    double percentChange = (recent - earlier) / earlier * 100;

    if (percentChange > 5) return 'up';
    if (percentChange < -5) return 'down';
    return 'stable';
  }

  // Generate weight data based on profile
  static List<Map<String, dynamic>> _generateWeightData(UserProfile profile) {
    double currentWeight = profile.weightInKg;
    String unit = profile.weightUnit;

    List<String> dates = [
      'Apr 1',
      'Apr 8',
      'Apr 15',
      'Apr 22',
      'Apr 29',
      'May 6',
    ];

    List<Map<String, dynamic>> weightData = [];

    // Generate synthetic weight data based on goal
    if (profile.fitnessGoal == 'Weight Loss') {
      // Weight loss trajectory
      for (int i = 0; i < dates.length; i++) {
        double weeklyChange =
            0.2 + Random().nextDouble() * 0.3; // 0.2 - 0.5 kg loss per week
        double historicalWeight =
            currentWeight + weeklyChange * (dates.length - i - 1);

        // Convert to selected unit
        double displayWeight =
            unit == 'kg' ? historicalWeight : historicalWeight * 2.20462;

        weightData.add({
          'date': dates[i],
          'weight': double.parse(displayWeight.toStringAsFixed(1)),
        });
      }
    } else if (profile.fitnessGoal == 'Muscle Gain') {
      // Weight gain trajectory
      for (int i = 0; i < dates.length; i++) {
        double weeklyChange =
            0.1 + Random().nextDouble() * 0.2; // 0.1 - 0.3 kg gain per week
        double historicalWeight =
            currentWeight - weeklyChange * (dates.length - i - 1);

        // Convert to selected unit
        double displayWeight =
            unit == 'kg' ? historicalWeight : historicalWeight * 2.20462;

        weightData.add({
          'date': dates[i],
          'weight': double.parse(displayWeight.toStringAsFixed(1)),
        });
      }
    } else {
      // Maintenance with small fluctuations
      for (int i = 0; i < dates.length; i++) {
        double fluctuation =
            Random().nextDouble() * 0.6 - 0.3; // -0.3 to +0.3 kg
        double historicalWeight = currentWeight + fluctuation;

        // Convert to selected unit
        double displayWeight =
            unit == 'kg' ? historicalWeight : historicalWeight * 2.20462;

        weightData.add({
          'date': dates[i],
          'weight': double.parse(displayWeight.toStringAsFixed(1)),
        });
      }
    }

    return weightData;
  }

  // Generate meal ratings data
  static List<Map<String, dynamic>> _generateMealRatings(UserProfile profile) {
    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    List<Map<String, dynamic>> mealRatings = [];

    // Personalize meal ratings based on health conditions and goals
    for (int i = 0; i < days.length; i++) {
      int breakfastRating = 3 + Random().nextInt(3); // 3-5
      int lunchRating = 3 + Random().nextInt(3); // 3-5
      int dinnerRating = 3 + Random().nextInt(3); // 3-5

      // Adjust ratings based on user profile
      if (profile.healthConditions.contains('Diabetes')) {
        // Lower ratings for breakfast (often high carb)
        breakfastRating = max(1, breakfastRating - 1);
      }

      if (profile.healthConditions.contains('GERD (Acid Reflux)')) {
        // Lower ratings for dinner (eating late can worsen GERD)
        dinnerRating = max(1, dinnerRating - 1);
      }

      if (profile.fitnessGoal == 'Muscle Gain') {
        // Higher ratings for protein-rich lunch
        lunchRating = min(5, lunchRating + 1);
      }

      mealRatings.add({
        'day': days[i],
        'breakfast': breakfastRating,
        'lunch': lunchRating,
        'dinner': dinnerRating,
      });
    }

    return mealRatings;
  }

  // Generate personalized insights
  static List<Map<String, dynamic>> _generateInsights(
    UserProfile profile,
    List<int> calorieData,
    List<int> proteinData,
    List<int> carbsData,
  ) {
    List<Map<String, dynamic>> insights = [];

    // Basic insight about calorie trend
    if (_calculateTrend(calorieData) == 'down') {
      insights.add({
        'icon': 'trending_down',
        'title': 'Good progress!',
        'description':
            'Your calorie intake is trending downward, which aligns with your ${profile.fitnessGoal} goal.',
      });
    } else if (_calculateTrend(calorieData) == 'up' &&
        profile.fitnessGoal == 'Weight Loss') {
      insights.add({
        'icon': 'warning',
        'title': 'Watch your calories',
        'description':
            'Your calorie intake is trending upward, which may slow your weight loss progress.',
      });
    }

    // Protein insight based on goal
    if (profile.fitnessGoal == 'Muscle Gain' &&
        _calculateTrend(proteinData) != 'up') {
      insights.add({
        'icon': 'fitness_center',
        'title': 'Increase protein intake',
        'description':
            'For muscle gain, try to consistently hit your daily protein target of ${profile.weightInKg * 2.2.round()}g.',
      });
    }

    // Health condition specific insights
    if (profile.healthConditions.contains('Diabetes') &&
        _calculateTrend(carbsData) == 'up') {
      insights.add({
        'icon': 'medical_services',
        'title': 'Monitor carb intake',
        'description':
            'Your carbohydrate intake is increasing. Consider keeping it more consistent to help manage blood sugar levels.',
      });
    }

    if (profile.healthConditions.contains(
      'Hypertension (High Blood Pressure)',
    )) {
      insights.add({
        'icon': 'favorite',
        'title': 'Heart-healthy eating',
        'description':
            'For hypertension management, aim to limit sodium intake and focus on potassium-rich foods like bananas and leafy greens.',
      });
    }

    // BMI-related insight
    if (profile.bmi > 25) {
      insights.add({
        'icon': 'monitor_weight',
        'title': 'BMI above recommended range',
        'description':
            'Your current BMI is ${profile.bmi.toStringAsFixed(1)}, which falls in the ${profile.bmiCategory} category. Focus on sustainable weight management.',
      });
    }

    // General health insight
    insights.add({
      'icon': 'water_drop',
      'title': 'Stay hydrated',
      'description':
          'Try to drink at least ${(profile.weightInKg * 0.033).round() + 2} cups of water daily to maintain optimal hydration.',
    });

    return insights;
  }

  // Calculate wellness score based on adherence to goals
  static Map<String, dynamic> _calculateWellnessScore(
    UserProfile profile,
    List<int> calorieData,
    List<int> proteinData,
  ) {
    // Calculate nutrition score (0-100)
    int nutritionScore = 0;

    // Calorie adherence (max 25 points)
    double calorieAdherence =
        calorieData
            .map((actual) {
              double goal =
                  profile.fitnessGoal == 'Weight Loss'
                      ? profile.weightInKg *
                          22 *
                          0.8 // Weight loss calorie target
                      : profile.weightInKg *
                          22 *
                          (profile.fitnessGoal == 'Muscle Gain' ? 1.1 : 1.0);
              return 1 -
                  min(0.25, (actual - goal).abs() / goal); // Penalize deviation
            })
            .reduce((a, b) => a + b) /
        calorieData.length;

    nutritionScore += (calorieAdherence * 25).round();

    // Protein adherence (max 25 points)
    double proteinTarget =
        profile.weightInKg * (profile.fitnessGoal == 'Muscle Gain' ? 2.2 : 1.8);
    double proteinAdherence =
        proteinData
            .map((actual) {
              return min(
                1.0,
                actual / proteinTarget,
              ); // Reward meeting or exceeding target
            })
            .reduce((a, b) => a + b) /
        proteinData.length;

    nutritionScore += (proteinAdherence * 25).round();

    // Macronutrient balance (max 25 points)
    int macroScore = 25;
    if (profile.healthConditions.contains('Diabetes') &&
        calorieData.last > profile.weightInKg * 24) {
      macroScore -= 10; // Penalty for high calories with diabetes
    }

    nutritionScore += macroScore;

    // Consistency (max 25 points)
    double consistency =
        1.0 -
        calorieData
                .map((c) {
                  int avg =
                      calorieData.reduce((a, b) => a + b) ~/ calorieData.length;
                  return (c - avg).abs() / avg; // Lower deviation is better
                })
                .reduce((a, b) => a + b) /
            calorieData.length;

    nutritionScore += (consistency * 25).round();

    // Adjust for health conditions
    if (profile.healthConditions.isNotEmpty) {
      // Apply slight penalty for each condition as they make management harder
      nutritionScore = max(
        60,
        nutritionScore - profile.healthConditions.length * 3,
      );
    }

    // Ensure score is between 60-95 for realism
    nutritionScore = min(95, max(60, nutritionScore));

    // Calculate component scores
    int exerciseScore = 60 + Random().nextInt(30);
    int sleepScore = 70 + Random().nextInt(25);
    int stressScore = 75 + Random().nextInt(20);

    return {
      'overall': nutritionScore,
      'nutrition': nutritionScore,
      'exercise': exerciseScore,
      'sleep': sleepScore,
      'stress': stressScore,
    };
  }
}
