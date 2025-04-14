// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService extends ChangeNotifier {
//   // Authentication states
//   bool _isLoggedIn = false;
//   bool _isLoading = false;
//   String? _phoneNumber;

//   // Getters
//   bool get isLoggedIn => _isLoggedIn;
//   bool get isLoading => _isLoading;
//   String? get phoneNumber => _phoneNumber;

//   // Keys for shared preferences
//   static const String _loginKey = 'isLoggedIn';
//   static const String _phoneKey = 'phoneNumber';

//   // Constructor - load saved state
//   AuthService() {
//     _loadLoginState();
//   }

//   // Set loading state
//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }

//   // Load login state from shared preferences
//   Future<void> _loadLoginState() async {
//     _setLoading(true);
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       _isLoggedIn = prefs.getBool(_loginKey) ?? false;
//       _phoneNumber = prefs.getString(_phoneKey);
//       notifyListeners();
//     } catch (e) {
//       debugPrint('Error loading login state: $e');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Set login state
//   Future<void> setLoggedIn(bool value, {String? phone}) async {
//     _setLoading(true);

//     try {
//       _isLoggedIn = value;

//       // If logging in, save phone number
//       if (value && phone != null) {
//         _phoneNumber = phone;
//       } else if (!value) {
//         // If logging out, clear phone number
//         _phoneNumber = null;
//       }

//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_loginKey, value);

//       if (_phoneNumber != null) {
//         await prefs.setString(_phoneKey, _phoneNumber!);
//       } else {
//         await prefs.remove(_phoneKey);
//       }

//       notifyListeners();
//     } catch (e) {
//       debugPrint('Error saving login state: $e');
//       // If error, revert state
//       _isLoggedIn = !value;
//       throw Exception('Failed to ${value ? 'login' : 'logout'}: $e');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Login method
//   Future<void> login({String? phone}) async {
//     if (_isLoggedIn) return; // Already logged in

//     await setLoggedIn(true, phone: phone);
//   }

//   // Logout method
//   Future<void> logout() async {
//     if (!_isLoggedIn) return; // Already logged out

//     await setLoggedIn(false);
//   }

//   // Check if user needs to login
//   bool requiresLogin() {
//     return !_isLoggedIn;
//   }

//   // Send OTP method (would connect to backend in real app)
//   Future<bool> sendOTP(String phoneNumber) async {
//     _setLoading(true);

//     try {
//       // Simulate API call
//       await Future.delayed(const Duration(seconds: 2));

//       // In a real app, you would call your backend API here
//       return true;
//     } catch (e) {
//       debugPrint('Error sending OTP: $e');
//       return false;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Verify OTP method (would connect to backend in real app)
//   Future<bool> verifyOTP(String phoneNumber, String otp) async {
//     _setLoading(true);

//     try {
//       // Simulate API call
//       await Future.delayed(const Duration(seconds: 2));

//       // In a real app, you would call your backend API here
//       // and receive a token or session ID

//       // For demo purposes, any 6-digit OTP is valid
//       if (otp.length == 6 && int.tryParse(otp) != null) {
//         // Save the phone number on successful verification
//         await login(phone: phoneNumber);
//         return true;
//       }

//       return false;
//     } catch (e) {
//       debugPrint('Error verifying OTP: $e');
//       return false;
//     } finally {
//       _setLoading(false);
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _phoneNumber;

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get phoneNumber => _phoneNumber;

  // Keys for shared preferences
  static const String _loginKey = 'isLoggedIn';
  static const String _phoneKey = 'phoneNumber';

  // Constructor
  AuthService() {
    _loadLoginState();
  }

  // Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Load login state from shared preferences
  Future<void> _loadLoginState() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool(_loginKey) ?? false;
      _phoneNumber = prefs.getString(_phoneKey);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading login state: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Set login state - add this method
  Future<void> setLoggedIn(bool value, {String? phone}) async {
    _setLoading(true);

    try {
      _isLoggedIn = value;

      // If logging in, save phone number
      if (value && phone != null) {
        _phoneNumber = phone;
      } else if (!value) {
        // If logging out, clear phone number
        _phoneNumber = null;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_loginKey, value);

      if (_phoneNumber != null) {
        await prefs.setString(_phoneKey, _phoneNumber!);
      } else {
        await prefs.remove(_phoneKey);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error saving login state: $e');
      // If error, revert state
      _isLoggedIn = !value;
      throw Exception('Failed to ${value ? 'login' : 'logout'}: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Login method
  Future<void> login({String? phone}) async {
    if (_isLoggedIn) return; // Already logged in

    // For web, simplified login
    if (kIsWeb) {
      _isLoggedIn = true;
      _phoneNumber = phone ?? "1234567890";
      notifyListeners();

      // Save to preferences even in web
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_loginKey, true);
        if (phone != null) {
          await prefs.setString(_phoneKey, phone);
        }
      } catch (e) {
        debugPrint('Error saving web login state: $e');
      }
      return;
    }

    await setLoggedIn(true, phone: phone);
  }

  // Logout method
  Future<void> logout() async {
    if (!_isLoggedIn) return; // Already logged out

    // For web, simplified logout
    if (kIsWeb) {
      _isLoggedIn = false;
      _phoneNumber = null;
      notifyListeners();

      // Clear preferences even in web
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_loginKey, false);
        await prefs.remove(_phoneKey);
      } catch (e) {
        debugPrint('Error clearing web login state: $e');
      }
      return;
    }

    await setLoggedIn(false);
  }

  // Check if user needs to login
  bool requiresLogin() {
    return !_isLoggedIn;
  }

  // Mock methods for Firebase functionality
  Future<bool> sendOTP(String phoneNumber) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call
    _setLoading(false);
    return true;
  }

  Future<bool> verifyOTP(String phoneNumber, String otp) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call

    // For demo purposes, any 6-digit OTP is valid
    if (otp.length == 6 && int.tryParse(otp) != null) {
      await login(phone: phoneNumber);
      _setLoading(false);
      return true;
    }

    _setLoading(false);
    return false;
  }
}
