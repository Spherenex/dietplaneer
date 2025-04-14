import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  // Form values
  String _selectedGender = 'Male';
  String _selectedFitnessGoal = 'Weight Loss';
  String _weightUnit = 'kg';
  String _heightUnit = 'cm';

  // Health conditions
  final List<String> _healthConditions = [
    'Diabetes',
    'Hypertension (High Blood Pressure)',
    'Heart Disease',
    'Kidney Disease',
    'GERD (Acid Reflux)',
    'Irritable Bowel Syndrome (IBS)',
    'Hypercholesterolemia (High Cholesterol)',
    'Normal',
  ];
  final Set<String> _selectedHealthConditions = {};

  // Gender options
  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  // Fitness goal options
  final List<String> _fitnessGoalOptions = [
    'Weight Loss',
    'Muscle Gain',
    'Maintenance',
    'General Health',
    'Athletic Performance',
  ];

  @override
  void initState() {
    super.initState();

    // Load existing profile data if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfile = Provider.of<UserProfile>(context, listen: false);

      if (userProfile.name.isNotEmpty) {
        _nameController.text = userProfile.name;
        _ageController.text = userProfile.age.toString();
        _weightController.text = userProfile.weight.toString();
        _heightController.text = userProfile.height.toString();
        setState(() {
          _selectedGender = userProfile.gender;
          _selectedFitnessGoal = userProfile.fitnessGoal;
          _weightUnit = userProfile.weightUnit;
          _heightUnit = userProfile.heightUnit;
          _selectedHealthConditions.addAll(userProfile.healthConditions);
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width to make responsive decisions
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 1200,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header Section
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Profile Setup',
                          style: TextStyle(
                            fontSize: isMobile ? 24 : 32,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Complete your profile to get personalized nutrition plans',
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isMobile ? 24 : 40),

                  // Main form content with responsive layout
                  isMobile ? _buildMobileFormLayout() : _buildWebFormLayout(),

                  SizedBox(height: isMobile ? 30 : 40),

                  // Save button
                  Center(
                    child: SizedBox(
                      width: isMobile ? double.infinity : 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _saveProfile();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Save Profile',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Mobile form layout (single column)
  Widget _buildMobileFormLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Personal Information Section
        _buildSectionHeader('Personal Information'),

        // Name field
        _buildTextField(
          controller: _nameController,
          label: 'Full Name',
          icon: Icons.person,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Age field
        _buildTextField(
          controller: _ageController,
          label: 'Age',
          icon: Icons.calendar_today,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your age';
            }
            if (int.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Gender dropdown
        _buildDropdown(
          label: 'Gender',
          icon: Icons.wc,
          value: _selectedGender,
          items: _genderOptions,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedGender = value;
              });
            }
          },
        ),
        const SizedBox(height: 30),

        // Physical Attributes Section
        _buildSectionHeader('Physical Attributes'),

        // Weight field with unit selector
        _buildMeasurementField(
          controller: _weightController,
          label: 'Weight',
          icon: Icons.monitor_weight,
          unit: _weightUnit,
          unitOptions: ['kg', 'lbs'],
          onUnitChanged: (value) {
            if (value != null) {
              setState(() {
                _weightUnit = value;
              });
            }
          },
        ),
        const SizedBox(height: 16),

        // Height field with unit selector
        _buildMeasurementField(
          controller: _heightController,
          label: 'Height',
          icon: Icons.height,
          unit: _heightUnit,
          unitOptions: ['cm', 'in'],
          onUnitChanged: (value) {
            if (value != null) {
              setState(() {
                _heightUnit = value;
              });
            }
          },
        ),
        const SizedBox(height: 30),

        // Fitness Goals Section
        _buildSectionHeader('Fitness Goals'),

        // Fitness goal dropdown
        _buildDropdown(
          label: 'Fitness Goal',
          icon: Icons.fitness_center,
          value: _selectedFitnessGoal,
          items: _fitnessGoalOptions,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedFitnessGoal = value;
              });
            }
          },
        ),

        const SizedBox(height: 30),

        // Health Conditions Section
        _buildSectionHeader('Health Conditions'),
        Text(
          'Select any conditions that apply to you:',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),

        // Health conditions as chips
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
      ],
    );
  }

  // Web form layout (multi-column)
  Widget _buildWebFormLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Personal Information Section
        _buildSectionHeader('Personal Information'),

        // Two-column layout for personal info
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),
            ),

            // Right column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: _buildTextField(
                  controller: _ageController,
                  label: 'Age',
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Gender dropdown
        _buildDropdown(
          label: 'Gender',
          icon: Icons.wc,
          value: _selectedGender,
          items: _genderOptions,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedGender = value;
              });
            }
          },
        ),
        const SizedBox(height: 30),

        // Physical Attributes Section
        _buildSectionHeader('Physical Attributes'),

        // Two-column layout for physical attributes
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weight field (left)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildMeasurementField(
                  controller: _weightController,
                  label: 'Weight',
                  icon: Icons.monitor_weight,
                  unit: _weightUnit,
                  unitOptions: ['kg', 'lbs'],
                  onUnitChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _weightUnit = value;
                      });
                    }
                  },
                ),
              ),
            ),

            // Height field (right)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: _buildMeasurementField(
                  controller: _heightController,
                  label: 'Height',
                  icon: Icons.height,
                  unit: _heightUnit,
                  unitOptions: ['cm', 'in'],
                  onUnitChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _heightUnit = value;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),

        // Fitness Goals Section
        _buildSectionHeader('Fitness Goals'),

        // Fitness goal dropdown - half width on web
        SizedBox(
          width: 500,
          child: _buildDropdown(
            label: 'Fitness Goal',
            icon: Icons.fitness_center,
            value: _selectedFitnessGoal,
            items: _fitnessGoalOptions,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedFitnessGoal = value;
                });
              }
            },
          ),
        ),

        const SizedBox(height: 30),

        // Health Conditions Section
        _buildSectionHeader('Health Conditions'),
        Text(
          'Select any conditions that apply to you:',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),

        // Health conditions as chips
        Wrap(
          spacing: 12,
          runSpacing: 12,
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
      ],
    );
  }

  // Helper method to build section headers
  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4CAF50),
          ),
        ),
        const Divider(color: Color(0xFF4CAF50)),
        const SizedBox(height: 16),
      ],
    );
  }

  // Helper method to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  // Helper method to build dropdowns
  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      items:
          items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
      onChanged: onChanged,
    );
  }

  // Helper method to build measurement fields with unit selectors
  Widget _buildMeasurementField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String unit,
    required List<String> unitOptions,
    required Function(String?) onUnitChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon),
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your $label';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<String>(
            value: unit,
            decoration: const InputDecoration(
              labelText: 'Unit',
              border: OutlineInputBorder(),
            ),
            items:
                unitOptions.map((String unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
            onChanged: onUnitChanged,
          ),
        ),
      ],
    );
  }

  // Method to save profile data
  void _saveProfile() {
    // Get the UserProfile from Provider
    final userProfile = Provider.of<UserProfile>(context, listen: false);

    // Update user profile with form values
    userProfile.updateProfile(
      name: _nameController.text,
      age: int.tryParse(_ageController.text) ?? 0,
      gender: _selectedGender,
      weight: double.tryParse(_weightController.text) ?? 0,
      weightUnit: _weightUnit,
      height: double.tryParse(_heightController.text) ?? 0,
      heightUnit: _heightUnit,
      fitnessGoal: _selectedFitnessGoal,
      healthConditions: _selectedHealthConditions.toList(),
    );

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile saved successfully!'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }
}
