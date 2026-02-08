import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lostandback/services/auth_services.dart';
import 'package:lostandback/utils/routes.dart';
import 'package:lostandback/viewmodel/auth_view_model.dart';
import 'package:lostandback/viewmodel/splash_viewmodel.dart';
import 'package:lostandback/viewmodel/lost_item_viewmodel.dart';
import 'package:lostandback/viewmodel/found_item_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),

        // ViewModels
        ChangeNotifierProvider(
          create: (_) => SplashViewModel(),
        ),
        ChangeNotifierProxyProvider<AuthService, AuthViewModel>(
          create: (context) => AuthViewModel(
            Provider.of<AuthService>(context, listen: false),
          ),
          update: (context, authService, previous) =>
          previous ?? AuthViewModel(authService),
        ),
        ChangeNotifierProvider(
          create: (_) => LostItemViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => FoundItemViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Lost & Back',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            secondary: AppColors.secondary,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
        // Use the AppRoutes class
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}