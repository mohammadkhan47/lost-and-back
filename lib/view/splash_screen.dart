// import 'package:flutter/material.dart';
//
// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               const SizedBox(height: 40),
//               // Title
//               const Text(
//                 "Welcome to\nLost & Back",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue,
//                 ),
//               ),
//               Divider(color: Colors.grey,
//                 ),
//               const SizedBox(height: 10),
//
//               // Subtitle
//               const Text(
//                 "Find and Recover Lost Items\nwith Ease.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey,
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               // Image
//               Expanded(
//                 child: Image.asset(
//                   "assets/images/splashlogo.png", // Your image path
//                   fit: BoxFit.contain,
//                 ),
//               ),
//
//               const SizedBox(height: 40),
//
//               // Buttons
//               Row(
//                 children: [
//
//                   // Login Button
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Navigate to Login
//                         Navigator.pushNamed(context, '/login');
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: const Text(
//                         "Login",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(width: 15),
//
//                   // Sign Up Button
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () {
//                         // Navigate to SignUp
//                         Navigator.pushNamed(context, '/signup');
//                       },
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         side: const BorderSide(color: Colors.blue),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: GestureDetector(
//                         onTap: (){
//                           // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>))
//                         },
//                         child: Text(
//                           "Sign Up",
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                 ],
//               ),
//
//               const SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import '../viewmodel/splash_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // Initialize and navigate
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<SplashViewModel>();
      viewModel.initialize().then((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, viewModel.navigationRoute);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.find_in_page_rounded,
                      size: 80,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // App Name
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Lost & Back',
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Tagline
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Find What You Lost, Return What You Found',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(height: 50),

              // Loading Indicator
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}