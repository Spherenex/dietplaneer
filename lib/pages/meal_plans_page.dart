import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_survices.dart';

class MealPlansPage extends StatefulWidget {
  final VoidCallback onLoginTap;

  const MealPlansPage({super.key, required this.onLoginTap});

  @override
  State<MealPlansPage> createState() => _MealPlansPageState();
}

class _MealPlansPageState extends State<MealPlansPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGeneratingPlan = false;
  String _selectedCalorieGoal = '1800';
  String _selectedMealCount = '3';
  String _selectedDietType = 'Balanced';
  final Set<String> _selectedHealthConditions =
      {}; // Added health conditions set

  final List<String> _dietTypes = [
    'Balanced',
    'Low-Carb',
    'High-Protein',
    'Vegetarian',
    'Vegan',
    'Keto',
    'Mediterranean',
  ];

  // Added list of health conditions
  final List<String> _healthConditions = [
    'Diabetes',
    'Hypertension (High Blood Pressure)',
    'Heart Disease',
    'Kidney Disease',
    'GERD (Acid Reflux)',
    'Irritable Bowel Syndrome (IBS)',
    'Hypercholesterolemia (High Cholesterol)',
  ];

  // Helper method to create a new meal plan based on user selections
  Map<String, dynamic> _createNewMealPlan() {
    // Get current date
    final now = DateTime.now();
    final formattedDate = 'Created ${now.month}/${now.day}/${now.year}';

    // Generate plan name based on selected options
    String planName = '';
    if (_selectedHealthConditions.isNotEmpty) {
      // If health conditions are selected, use the first one in the name
      planName = '${_selectedHealthConditions.first} Management Plan';
    } else if (_selectedDietType == 'Low-Carb' || _selectedDietType == 'Keto') {
      planName = 'Weight Loss Plan';
    } else if (_selectedCalorieGoal == '2400' ||
        _selectedCalorieGoal == '2700') {
      planName = 'High Energy Plan';
    } else {
      planName = '${_selectedDietType} Nutrition Plan';
    }

    // Create a list of meals based on the selected meal count
    final mealCount = int.parse(_selectedMealCount);
    final List<Map<String, dynamic>> meals = [];

    // Breakfast is always included
    meals.add({
      'name': 'Breakfast',
      'time': '8:00 AM',
      'foods': [
        {
          'name': 'Greek Yogurt with Berries',
          'calories': 220,
          'protein': 18,
          'carbs': 15,
          'fat': 8,
        },
        {
          'name': 'Whole Grain Toast',
          'calories': 80,
          'protein': 4,
          'carbs': 15,
          'fat': 1,
        },
      ],
    });

    // Lunch is always included
    meals.add({
      'name': 'Lunch',
      'time': '12:30 PM',
      'foods': [
        {
          'name':
              _selectedDietType == 'Vegetarian' || _selectedDietType == 'Vegan'
                  ? 'Quinoa Bowl with Chickpeas'
                  : 'Grilled Chicken Salad',
          'calories': 350,
          'protein': 30,
          'carbs': 20,
          'fat': 12,
        },
      ],
    });

    // Add snacks based on meal count
    if (mealCount >= 4) {
      meals.add({
        'name': 'Afternoon Snack',
        'time': '3:30 PM',
        'foods': [
          {
            'name':
                _selectedHealthConditions.contains('Diabetes')
                    ? 'Apple with Almond Butter'
                    : 'Protein Bar',
            'calories': 180,
            'protein': 10,
            'carbs': 15,
            'fat': 8,
          },
        ],
      });
    }

    if (mealCount >= 5) {
      meals.add({
        'name': 'Pre-Workout Snack',
        'time': '5:00 PM',
        'foods': [
          {
            'name': 'Banana with Peanut Butter',
            'calories': 210,
            'protein': 8,
            'carbs': 25,
            'fat': 8,
          },
        ],
      });
    }

    // Dinner is always included
    meals.add({
      'name': 'Dinner',
      'time': '7:00 PM',
      'foods': [
        {
          'name':
              _selectedHealthConditions.contains('Heart Disease') ||
                      _selectedHealthConditions.contains('High Blood Pressure')
                  ? 'Baked Salmon with Herbs'
                  : 'Lean Steak with Vegetables',
          'calories': 320,
          'protein': 35,
          'carbs': 10,
          'fat': 15,
        },
        {
          'name': 'Steamed Vegetables',
          'calories': 80,
          'protein': 4,
          'carbs': 15,
          'fat': 0,
        },
      ],
    });

    if (mealCount >= 6) {
      meals.add({
        'name': 'Evening Snack',
        'time': '9:00 PM',
        'foods': [
          {
            'name':
                _selectedHealthConditions.contains('GERD (Acid Reflux)')
                    ? 'Chamomile Tea with Rice Cakes'
                    : 'Greek Yogurt with Honey',
            'calories': 120,
            'protein': 12,
            'carbs': 10,
            'fat': 3,
          },
        ],
      });
    }

    // Create the complete meal plan
    return {
      'id': DateTime.now().millisecondsSinceEpoch,
      'name': planName,
      'date': formattedDate,
      'calories': _selectedCalorieGoal,
      'dietType': _selectedDietType,
      'healthConditions': _selectedHealthConditions.toList(),
      'meals': meals,
    };
  }

  // Meal plan data
  final List<Map<String, dynamic>> _mealPlans = [
    {
      'id': 1,
      'name': 'Weight Loss Plan',
      'date': 'Created Apr 5, 2025',
      'calories': '1500',
      'meals': [
        {
          'name': 'Breakfast',
          'time': '8:00 AM',
          'foods': [
            {
              'name': 'Greek Yogurt',
              'calories': 150,
              'protein': 15,
              'carbs': 6,
              'fat': 4,
            },
            {
              'name': 'Blueberries',
              'calories': 85,
              'protein': 1,
              'carbs': 21,
              'fat': 0,
            },
            {
              'name': 'Granola',
              'calories': 120,
              'protein': 3,
              'carbs': 18,
              'fat': 6,
            },
          ],
        },
        {
          'name': 'Lunch',
          'time': '12:30 PM',
          'foods': [
            {
              'name': 'Grilled Chicken Salad',
              'calories': 320,
              'protein': 35,
              'carbs': 10,
              'fat': 14,
            },
            {
              'name': 'Whole Grain Bread',
              'calories': 80,
              'protein': 4,
              'carbs': 15,
              'fat': 1,
            },
          ],
        },
        {
          'name': 'Dinner',
          'time': '7:00 PM',
          'foods': [
            {
              'name': 'Baked Salmon',
              'calories': 280,
              'protein': 30,
              'carbs': 0,
              'fat': 15,
            },
            {
              'name': 'Steamed Broccoli',
              'calories': 55,
              'protein': 4,
              'carbs': 10,
              'fat': 0,
            },
            {
              'name': 'Quinoa',
              'calories': 120,
              'protein': 5,
              'carbs': 20,
              'fat': 2,
            },
          ],
        },
      ],
    },
    {
      'id': 2,
      'name': 'Muscle Building Plan',
      'date': 'Created Apr 3, 2025',
      'calories': '2400',
      'meals': [
        {
          'name': 'Breakfast',
          'time': '7:30 AM',
          'foods': [
            {
              'name': 'Oatmeal',
              'calories': 150,
              'protein': 5,
              'carbs': 27,
              'fat': 3,
            },
            {
              'name': 'Protein Shake',
              'calories': 180,
              'protein': 25,
              'carbs': 5,
              'fat': 3,
            },
            {
              'name': 'Banana',
              'calories': 105,
              'protein': 1,
              'carbs': 27,
              'fat': 0,
            },
          ],
        },
        {
          'name': 'Mid-Morning Snack',
          'time': '10:30 AM',
          'foods': [
            {
              'name': 'Turkey & Avocado Wrap',
              'calories': 320,
              'protein': 25,
              'carbs': 25,
              'fat': 12,
            },
          ],
        },
        {
          'name': 'Lunch',
          'time': '1:00 PM',
          'foods': [
            {
              'name': 'Grilled Steak',
              'calories': 350,
              'protein': 42,
              'carbs': 0,
              'fat': 18,
            },
            {
              'name': 'Sweet Potato',
              'calories': 120,
              'protein': 2,
              'carbs': 28,
              'fat': 0,
            },
            {
              'name': 'Mixed Vegetables',
              'calories': 80,
              'protein': 4,
              'carbs': 16,
              'fat': 0,
            },
          ],
        },
        {
          'name': 'Afternoon Snack',
          'time': '4:00 PM',
          'foods': [
            {
              'name': 'Greek Yogurt',
              'calories': 150,
              'protein': 15,
              'carbs': 6,
              'fat': 4,
            },
            {
              'name': 'Mixed Nuts',
              'calories': 160,
              'protein': 6,
              'carbs': 5,
              'fat': 14,
            },
          ],
        },
        {
          'name': 'Dinner',
          'time': '7:30 PM',
          'foods': [
            {
              'name': 'Grilled Chicken Breast',
              'calories': 280,
              'protein': 35,
              'carbs': 0,
              'fat': 6,
            },
            {
              'name': 'Brown Rice',
              'calories': 150,
              'protein': 3,
              'carbs': 32,
              'fat': 1,
            },
            {
              'name': 'Roasted Broccoli',
              'calories': 65,
              'protein': 5,
              'carbs': 10,
              'fat': 1,
            },
          ],
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;

    final isLoggedIn = context.watch<AuthService>().isLoggedIn;

    return Scaffold(
      body:
          isLoggedIn
              ? Column(
                children: [
                  // Tab Bar for switching between views
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: const Color(0xFF4CAF50),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: const Color(0xFF4CAF50),
                      tabs: const [
                        Tab(text: 'My Meal Plans', icon: Icon(Icons.list)),
                        Tab(text: 'Generate New Plan', icon: Icon(Icons.add)),
                      ],
                    ),
                  ),

                  // Tab Bar View
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // My Meal Plans Tab
                        _buildMealPlansList(isMobile, isTablet),

                        // Generate New Plan Tab
                        _buildGeneratePlanForm(isMobile),
                      ],
                    ),
                  ),
                ],
              )
              : _buildLoginPrompt(),
    );
  }

  // Widget for My Meal Plans list
  Widget _buildMealPlansList(bool isMobile, bool isTablet) {
    return _mealPlans.isEmpty
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No meal plans yet',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  _tabController.animateTo(1);
                },
                icon: Icon(Icons.add),
                label: Text('Create Your First Meal Plan'),
              ),
            ],
          ),
        )
        : ListView.builder(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          itemCount: _mealPlans.length,
          itemBuilder: (context, index) {
            final plan = _mealPlans[index];
            return Card(
              margin: EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                tilePadding: EdgeInsets.all(16),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      plan['date'],
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${plan['calories']} calories • ${plan['meals'].length} meals',
                        style: TextStyle(fontSize: 14),
                      ),
                      if (plan.containsKey('healthConditions') &&
                          (plan['healthConditions'] as List).isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'For: ${(plan['healthConditions'] as List).join(', ')}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // Edit meal plan
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Delete meal plan
                      },
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        ...List.generate(
                          plan['meals'].length,
                          (mealIndex) => _buildMealItem(
                            plan['meals'][mealIndex],
                            isMobile,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {
                                // Handle export
                              },
                              icon: Icon(Icons.file_download),
                              label: Text('Export'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Color(0xFF4CAF50),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Handle shopping list
                              },
                              icon: Icon(Icons.shopping_cart),
                              label: Text('Shopping List'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
  }

  // Widget for a single meal item in the expanded view
  Widget _buildMealItem(Map<String, dynamic> meal, bool isMobile) {
    final totalCalories = meal['foods'].fold<int>(
      0,
      (sum, food) => sum + food['calories'] as int,
    );
    final totalProtein = meal['foods'].fold<int>(
      0,
      (sum, food) => sum + food['protein'] as int,
    );
    final totalCarbs = meal['foods'].fold<int>(
      0,
      (sum, food) => sum + food['carbs'] as int,
    );
    final totalFat = meal['foods'].fold<int>(
      0,
      (sum, food) => sum + food['fat'] as int,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${meal['name']} • ${meal['time']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '$totalCalories cal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Macronutrient bars
          Row(
            children: [
              Expanded(
                flex: totalProtein,
                child: Container(height: 8, color: Colors.red[400]),
              ),
              Expanded(
                flex: totalCarbs,
                child: Container(height: 8, color: Colors.amber[400]),
              ),
              Expanded(
                flex: totalFat,
                child: Container(height: 8, color: Colors.blue[400]),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Protein: ${totalProtein}g',
                style: TextStyle(fontSize: 12, color: Colors.red[400]),
              ),
              Text(
                'Carbs: ${totalCarbs}g',
                style: TextStyle(fontSize: 12, color: Colors.amber[700]),
              ),
              Text(
                'Fat: ${totalFat}g',
                style: TextStyle(fontSize: 12, color: Colors.blue[400]),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Food list
          ...meal['foods']
              .map<Widget>(
                (food) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(food['name']),
                      Text('${food['calories']} cal'),
                    ],
                  ),
                ),
              )
              .toList(),
          SizedBox(height: 8),
          Divider(),
        ],
      ),
    );
  }

  // Widget for generating a new meal plan
  Widget _buildGeneratePlanForm(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Generate Custom Meal Plan',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Our AI will create a personalized meal plan based on your preferences',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 24),

          // Calorie Goal
          Text(
            'Daily Calorie Goal',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children:
                ['1200', '1500', '1800', '2100', '2400', '2700'].map((
                  calories,
                ) {
                  return ChoiceChip(
                    label: Text('$calories cal'),
                    selected: _selectedCalorieGoal == calories,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCalorieGoal = calories;
                        });
                      }
                    },
                    selectedColor: Color(0xFFE8F5E9),
                    labelStyle: TextStyle(
                      color:
                          _selectedCalorieGoal == calories
                              ? Color(0xFF4CAF50)
                              : Colors.black87,
                    ),
                  );
                }).toList(),
          ),
          SizedBox(height: 24),

          // Number of Meals
          Text(
            'Number of Meals',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children:
                ['3', '4', '5', '6'].map((count) {
                  return ChoiceChip(
                    label: Text('$count meals'),
                    selected: _selectedMealCount == count,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedMealCount = count;
                        });
                      }
                    },
                    selectedColor: Color(0xFFE8F5E9),
                    labelStyle: TextStyle(
                      color:
                          _selectedMealCount == count
                              ? Color(0xFF4CAF50)
                              : Colors.black87,
                    ),
                  );
                }).toList(),
          ),
          SizedBox(height: 24),

          // Diet Type
          Text(
            'Diet Type',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _dietTypes.map((diet) {
                  return ChoiceChip(
                    label: Text(diet),
                    selected: _selectedDietType == diet,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedDietType = diet;
                        });
                      }
                    },
                    selectedColor: Color(0xFFE8F5E9),
                    labelStyle: TextStyle(
                      color:
                          _selectedDietType == diet
                              ? Color(0xFF4CAF50)
                              : Colors.black87,
                    ),
                  );
                }).toList(),
          ),
          SizedBox(height: 24),

          // Health Conditions - NEW SECTION
          Text(
            'Health Conditions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _healthConditions.map((condition) {
                  return FilterChip(
                    label: Text(condition),
                    selected: _selectedHealthConditions.contains(condition),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedHealthConditions.add(condition);
                        } else {
                          _selectedHealthConditions.remove(condition);
                        }
                      });
                    },
                    selectedColor: Color(0xFFE8F5E9),
                    checkmarkColor: Color(0xFF4CAF50),
                    labelStyle: TextStyle(
                      color:
                          _selectedHealthConditions.contains(condition)
                              ? Color(0xFF4CAF50)
                              : Colors.black87,
                    ),
                  );
                }).toList(),
          ),
          SizedBox(height: 24),

          // Diet restrictions
          ExpansionTile(
            title: Text(
              'Dietary Restrictions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: [
              CheckboxListTile(
                title: Text('Gluten-Free'),
                value: false,
                onChanged: (value) {},
                activeColor: Color(0xFF4CAF50),
              ),
              CheckboxListTile(
                title: Text('Dairy-Free'),
                value: false,
                onChanged: (value) {},
                activeColor: Color(0xFF4CAF50),
              ),
              CheckboxListTile(
                title: Text('Nut-Free'),
                value: false,
                onChanged: (value) {},
                activeColor: Color(0xFF4CAF50),
              ),
            ],
          ),

          // Food preferences
          ExpansionTile(
            title: Text(
              'Food Preferences',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: [
              ListTile(
                title: Text('Foods I Like'),
                subtitle: Text('Add foods you enjoy'),
                trailing: IconButton(
                  icon: Icon(Icons.add, color: Color(0xFF4CAF50)),
                  onPressed: () {},
                ),
              ),
              ListTile(
                title: Text('Foods to Avoid'),
                subtitle: Text('Add foods you dislike or want to avoid'),
                trailing: IconButton(
                  icon: Icon(Icons.add, color: Colors.red),
                  onPressed: () {},
                ),
              ),
            ],
          ),

          SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isGeneratingPlan = true;
                });

                // Simulate API call
                Future.delayed(Duration(seconds: 3), () {
                  // Create a new meal plan with the selected properties
                  final newMealPlan = _createNewMealPlan();

                  setState(() {
                    _isGeneratingPlan = false;
                    // Add new meal plan to the list
                    _mealPlans.insert(0, newMealPlan);
                    // Switch to first tab
                    _tabController.animateTo(0);
                  });

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('New meal plan created successfully!'),
                      backgroundColor: Color(0xFF4CAF50),
                    ),
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child:
                  _isGeneratingPlan
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Generating Your Plan...'),
                        ],
                      )
                      : Text('Generate Meal Plan'),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  // Widget shown when user is not logged in
  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'You need to login to access meal plans',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: widget.onLoginTap,
            child: Text('Login Now'),
          ),
        ],
      ),
    );
  }
}
