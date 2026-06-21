import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/login_screen.dart';
import '/signup_screen.dart';
import '/home_screen.dart';
import '/map_screen.dart';
import '/booking_screen.dart';
import '/chat_screen.dart';
import '/profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

// ─────────────────────────────────────────────────────────────
// GLOBAL STATE
// ─────────────────────────────────────────────────────────────

class AppState {
  static String userType = 'Passenger';
  static String userName = 'Laiba';
  static String userEmail = 'laiba@example.com';

  static bool get isPassenger => userType == 'Passenger';
  static bool get isDriver => userType == 'Driver';

  static void setUserType(String type) => userType = type;
}

// ─────────────────────────────────────────────────────────────
// APP COLORS
// ─────────────────────────────────────────────────────────────

class AppColors {
  static const background   = Color(0xFF0A0A0A);
  static const surface      = Color(0xFF141414);
  static const surfaceLight = Color(0xFF1E1E1E);
  static const border       = Color(0xFF2A2A2A);
  static const primary      = Color(0xFFFFFFFF);
  static const accent       = Color(0xFF00E5A0); // teal-green accent
  static const accentDim    = Color(0x2200E5A0);
  static const textPrimary  = Color(0xFFFFFFFF);
  static const textSecondary= Color(0xFF8A8A8A);
  static const textMuted    = Color(0xFF4A4A4A);
  static const danger       = Color(0xFFFF4C4C);
  static const dangerDim    = Color(0x22FF4C4C);
  static const warning      = Color(0xFFFFB020);
  static const warningDim   = Color(0x22FFB020);
  static const info         = Color(0xFF4C9EFF);
  static const infoDim      = Color(0x224C9EFF);
}

// ─────────────────────────────────────────────────────────────
// APP
// ─────────────────────────────────────────────────────────────

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RideX',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const LoginScreen(),
      routes: _buildRoutes(),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Montserrat',

      colorScheme: const ColorScheme.dark().copyWith(
        surface: AppColors.surface,
        primary: AppColors.accent,
        secondary: AppColors.textSecondary,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 34, fontWeight: FontWeight.w800,
          color: AppColors.textPrimary, letterSpacing: -1.0,
        ),
        titleLarge: TextStyle(
          fontSize: 20, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary, letterSpacing: -0.4,
        ),
        titleMedium: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600,
          color: AppColors.textPrimary, letterSpacing: -0.2,
        ),
        bodyLarge: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w500,
          color: AppColors.textMuted, letterSpacing: 0.5,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.background,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 11,
        ),
      ),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/login':   (_) => const LoginScreen(),
      '/signup':  (_) => const SignupScreen(),
      '/home':    (_) => const HomeScreen(),
      '/chat':    (_) => const ChatScreen(),
      '/booking': (_) => const BookingScreen(),
      '/profile': (_) => ProfileScreen(userType: AppState.userType),
      '/map': (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map?;
        return MapScreen(
          rideType: args?['type']  ?? 'Economy',
          price:    args?['price'] ?? '\$8.50',
          duration: args?['time']  ?? '5 min',
        );
      },
    };
  }
}