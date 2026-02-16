// lib/utils/routes.dart
import 'package:flutter/material.dart';
import '../view/admin/admin_chat_box.dart';
import '../view/admin/admin_dash_screen.dart';
import '../view/admin/admin_item_screen.dart';
import '../view/admin/admin_user_screen.dart';
import '../view/chat/chat_admin_screen.dart';
import '../view/found_items/report_found_item.dart';
import '../view/home/homeview.dart';
import '../view/lost_items/report_items_screen.dart';
import '../view/splash_screen.dart';
import '../view/onboarding_screen.dart';
import '../view/auth/login_screen.dart';
import '../view/auth/register_screen.dart';
import '../view/auth/forgot_screen.dart';
import '../view/home/home_screen.dart';

class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot_password';
  static const String home = '/home';
  static const String reportLost = '/report_lost';
  static const String reportFound = '/report_found';
  static const String myLostItems = '/my_lost_items';
  static const String myFoundItems = '/my_found_items';
  static const String adminDashboard = '/admin_dashboard';
  static const String adminUsers = '/admin_users';
  static const String adminLostItems = '/admin_lost_items';
  static const String adminFoundItems = '/admin_found_items';
  static const String adminChats = '/admin_chats';
  static const String chatWithAdmin = '/chat_with_admin';  // ✅ FIXED: lowercase


  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case reportLost:
        return MaterialPageRoute(builder: (_) => const ReportLostItemScreen());

      case reportFound:
        return MaterialPageRoute(builder: (_) => const ReportFoundItemScreen());

      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());

      case adminUsers:
        return MaterialPageRoute(builder: (_) => const AdminUsersScreen());

      case adminLostItems:
        return MaterialPageRoute(builder: (_) => const AdminItemsScreen(isLostItems: true));

      case adminFoundItems:
        return MaterialPageRoute(builder: (_) => const AdminItemsScreen(isLostItems: false));

      case adminChats:
        return MaterialPageRoute(builder: (_) => const AdminChatInboxScreen());

      case chatWithAdmin:
        return MaterialPageRoute(builder: (_) => const ChatWithAdminScreen());

    // Add more routes as needed
    // case myLostItems:
    //   return MaterialPageRoute(builder: (_) => const MyLostItemsScreen());

    // case myFoundItems:
    //   return MaterialPageRoute(builder: (_) => const MyFoundItemsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  // Named routes map (alternative approach)
  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    home: (context) => const HomeScreen(),
    reportLost: (context) => const ReportLostItemScreen(),
    reportFound: (context) => const ReportFoundItemScreen(),
    adminDashboard: (context) => const AdminDashboardScreen(),
    adminUsers: (context) => const AdminUsersScreen(),
    adminLostItems: (context) => const AdminItemsScreen(isLostItems: true),
    adminFoundItems: (context) => const AdminItemsScreen(isLostItems: false),
    adminChats: (context) => const AdminChatInboxScreen(),
    chatWithAdmin: (context) => const ChatWithAdminScreen(),  // ✅ FIXED
  };
}