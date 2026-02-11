// import 'package:flutter/material.dart';
// import 'package:lostandback/view/registration_view.dart';
// import 'package:provider/provider.dart';
// import '../viewmodel/loginview_model.dart';
// import '../widgets/appdrawer.dart';
// import '../widgets/custom_footer.dart';
// import '../widgets/custom_header.dart';
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final FocusNode emailFocus = FocusNode();
//   final FocusNode passFocus = FocusNode();
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//
//   bool _isHoveringSignIn = false;
//   bool _isHoveringSignUp = false;
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     emailFocus.dispose();
//     passFocus.dispose();
//     super.dispose();
//   }
//
//   Future<void> _handleSignIn() async {
//     final viewModel = context.read<LoginViewModel>();
//
//     final success = await viewModel.signIn(
//       _emailController.text,
//       _passwordController.text,
//     );
//
//     if (success && mounted) {
//       Navigator.pushReplacementNamed(context, '/welcome');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isMobile = size.width <= 600;
//
//     return SafeArea(
//       child: Scaffold(
//         key: scaffoldKey,
//         endDrawer: const AppDrawer(),
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color(0xFF1A1A2E),
//                 Color(0xFF16213E),
//                 Color(0xFF0F3460),
//               ],
//               stops: [0.0, 0.5, 1.0],
//             ),
//           ),
//           child: Column(
//             children: [
//               CustomHeader(scaffoldKey: scaffoldKey),
//               Expanded(
//                 child: Stack(
//                   children: [
//                     // Back arrow
//                     Positioned(
//                       left: isMobile ? 16 : 24,
//                       top: isMobile ? 16 : 24,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.1),
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: Colors.white.withOpacity(0.3),
//                             width: 1.5,
//                           ),
//                         ),
//                         child: IconButton(
//                           icon: const Icon(
//                             Icons.arrow_back_ios,
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ),
//                     ),
//
//                     // Main Content
//                     Center(
//                       child: SingleChildScrollView(
//                         padding: EdgeInsets.all(isMobile ? 16 : 24),
//                         child: Consumer<LoginViewModel>(
//                           builder: (context, viewModel, child) {
//                             return Container(
//                               width: isMobile ? double.infinity : 500,
//                               padding: EdgeInsets.all(isMobile ? 20 : 32),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.08),
//                                 borderRadius: BorderRadius.circular(24),
//                                 border: Border.all(
//                                   color: Colors.white.withOpacity(0.15),
//                                   width: 1.5,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.3),
//                                     blurRadius: 30,
//                                     offset: const Offset(0, 20),
//                                   ),
//                                 ],
//                               ),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   // Title
//                                   ShaderMask(
//                                     shaderCallback: (bounds) =>
//                                         const LinearGradient(
//                                           colors: [
//                                             Color(0xFF00DBDE),
//                                             Color(0xFFFC00FF),
//                                           ],
//                                           begin: Alignment.topLeft,
//                                           end: Alignment.bottomRight,
//                                         ).createShader(bounds),
//                                     child: const Text(
//                                       'Login',
//                                       style: TextStyle(
//                                         fontSize: 32,
//                                         fontWeight: FontWeight.w800,
//                                         letterSpacing: 1.2,
//                                         color: Colors.white70,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   const Text(
//                                     'Access your account to continue',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white70,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 30),
//
//                                   // Email Field
//                                   _buildTextField(
//                                     label: 'Email',
//                                     controller: _emailController,
//                                     focusNode: emailFocus,
//                                     hintText: 'your@email.com',
//                                     keyboardType: TextInputType.emailAddress,
//                                     prefixIcon: Icons.email_rounded,
//                                   ),
//                                   const SizedBox(height: 20),
//
//                                   // Password Field
//                                   _buildTextField(
//                                     label: 'Password',
//                                     controller: _passwordController,
//                                     focusNode: passFocus,
//                                     hintText: '••••••••',
//                                     obscureText: viewModel.obscurePassword,
//                                     prefixIcon: Icons.lock_rounded,
//                                     suffixIcon: IconButton(
//                                       icon: Icon(
//                                         viewModel.obscurePassword
//                                             ? Icons.visibility_off_rounded
//                                             : Icons.visibility_rounded,
//                                         color: Colors.white.withOpacity(0.8),
//                                       ),
//                                       onPressed: viewModel.togglePasswordVisibility,
//                                     ),
//                                   ),
//
//                                   // Error Message
//                                   if (viewModel.errorMessage != null)
//                                     Padding(
//                                       padding: const EdgeInsets.only(top: 16.0),
//                                       child: Text(
//                                         viewModel.errorMessage!,
//                                         style: const TextStyle(
//                                           color: Color(0xFFFF6B6B),
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                     ),
//                                   const SizedBox(height: 30),
//
//                                   // Buttons
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       // Sign In Button
//                                       _buildSignInButton(viewModel),
//
//                                       // Sign Up Button
//                                       _buildSignUpButton(viewModel),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//
//                                   // Forgot Password
//                                   MouseRegion(
//                                     cursor: SystemMouseCursors.click,
//                                     child: TextButton(
//                                       onPressed: viewModel.isLoading
//                                           ? null
//                                           : () {
//                                         Navigator.pushNamed(
//                                             context, '/forgot_password');
//                                       },
//                                       style: TextButton.styleFrom(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 16, vertical: 8),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(8),
//                                         ),
//                                       ),
//                                       child: const Text(
//                                         'Forgot Password?',
//                                         style: TextStyle(
//                                           color: Colors.white70,
//                                           fontWeight: FontWeight.w500,
//                                           decoration: TextDecoration.underline,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const CustomFooter(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Build Text Field Widget
//   Widget _buildTextField({
//     required String label,
//     required TextEditingController controller,
//     required FocusNode focusNode,
//     required String hintText,
//     required IconData prefixIcon,
//     TextInputType keyboardType = TextInputType.text,
//     bool obscureText = false,
//     Widget? suffixIcon,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Colors.white,
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           focusNode: focusNode,
//           keyboardType: keyboardType,
//           obscureText: obscureText,
//           style: const TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.white.withOpacity(0.1),
//             hintText: hintText,
//             hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 16,
//             ),
//             prefixIcon: Icon(
//               prefixIcon,
//               color: Colors.white.withOpacity(0.8),
//             ),
//             suffixIcon: suffixIcon,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Build Sign In Button
//   Widget _buildSignInButton(LoginViewModel viewModel) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHoveringSignIn = true),
//       onExit: (_) => setState(() => _isHoveringSignIn = false),
//       child: GestureDetector(
//         onTap: viewModel.isLoading ? null : _handleSignIn,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             gradient: LinearGradient(
//               colors: _isHoveringSignIn
//                   ? [const Color(0xFF00DBDE), const Color(0xFFFC00FF)]
//                   : [
//                 const Color(0xFF00DBDE).withOpacity(0.9),
//                 const Color(0xFFFC00FF).withOpacity(0.9)
//               ],
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: (_isHoveringSignIn
//                     ? const Color(0xFF00DBDE)
//                     : const Color(0xFFFC00FF))
//                     .withOpacity(0.4),
//                 blurRadius: _isHoveringSignIn ? 20 : 10,
//                 offset: Offset(0, _isHoveringSignIn ? 8 : 4),
//               ),
//             ],
//           ),
//           child: viewModel.isLoading
//               ? const SizedBox(
//             width: 24,
//             height: 24,
//             child: CircularProgressIndicator(
//               color: Colors.white,
//               strokeWidth: 3,
//             ),
//           )
//               : const Text(
//             'Sign In',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w600,
//               fontSize: 16,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Build Sign Up Button
//   Widget _buildSignUpButton(LoginViewModel viewModel) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHoveringSignUp = true),
//       onExit: (_) => setState(() => _isHoveringSignUp = false),
//       child: GestureDetector(
//         onTap: viewModel.isLoading
//             ? null
//             : () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => RegisterView(),
//             ),
//           );
//         },
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             color: Colors.white.withOpacity(_isHoveringSignUp ? 0.2 : 0.1),
//             border: Border.all(
//               color: Colors.white.withOpacity(0.3),
//               width: 1.5,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(_isHoveringSignUp ? 0.3 : 0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: const Text(
//             'Sign Up',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w600,
//               fontSize: 16,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
// }

// lib/views/auth/login_screen.dart
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../../utils/colors.dart';
// import '../../viewmodel/auth_view_model.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _emailFocus = FocusNode();
//   final _passwordFocus = FocusNode();
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _emailFocus.dispose();
//     _passwordFocus.dispose();
//     super.dispose();
//   }
//
//   Future<void> _handleLogin() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     final viewModel = context.read<AuthViewModel>();
//     final success = await viewModel.login(
//       _emailController.text.trim(),
//       _passwordController.text,
//     );
//
//     if (success && mounted) {
//       Navigator.pushReplacementNamed(context, '/home');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final viewModel = context.watch<AuthViewModel>();
//
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: AppColors.primaryGradient,
//         ),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Logo
//                   _buildLogo(),
//                   const SizedBox(height: 40),
//
//                   // Welcome Text
//                   Text(
//                     'Welcome Back!',
//                     style: GoogleFonts.poppins(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Sign in to continue',
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       color: Colors.white.withOpacity(0.8),
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//
//                   // Login Form Card
//                   Container(
//                     padding: const EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(24),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 20,
//                           offset: const Offset(0, 10),
//                         ),
//                       ],
//                     ),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           // Email Field
//                           _buildLabel('Email'),
//                           const SizedBox(height: 8),
//                           _buildEmailField(viewModel),
//                           const SizedBox(height: 20),
//
//                           // Password Field
//                           _buildLabel('Password'),
//                           const SizedBox(height: 8),
//                           _buildPasswordField(viewModel),
//                           const SizedBox(height: 12),
//
//                           // Forgot Password
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: TextButton(
//                               onPressed: () {
//                                 Navigator.pushNamed(context, '/forgot_password');
//                               },
//                               child: Text(
//                                 'Forgot Password?',
//                                 style: GoogleFonts.poppins(
//                                   color: AppColors.primary,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ),
//
//                           // Error Message
//                           if (viewModel.errorMessage != null) ...[
//                             const SizedBox(height: 12),
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: AppColors.error.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Icon(Icons.error_outline,
//                                       color: AppColors.error, size: 20),
//                                   const SizedBox(width: 8),
//                                   Expanded(
//                                     child: Text(
//                                       viewModel.errorMessage!,
//                                       style: GoogleFonts.poppins(
//                                         color: AppColors.error,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//
//                           const SizedBox(height: 24),
//
//                           // Login Button
//                           _buildLoginButton(viewModel),
//                           const SizedBox(height: 20),
//
//                           // Divider
//                           Row(
//                             children: [
//                               const Expanded(child: Divider()),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                                 child: Text(
//                                   'OR',
//                                   style: GoogleFonts.poppins(
//                                     color: AppColors.textSecondary,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                               const Expanded(child: Divider()),
//                             ],
//                           ),
//                           const SizedBox(height: 20),
//
//                           // Sign Up Link
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Don't have an account? ",
//                                 style: GoogleFonts.poppins(
//                                   color: AppColors.textSecondary,
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.pushNamed(context, '/register');
//                                 },
//                                 child: Text(
//                                   'Sign Up',
//                                   style: GoogleFonts.poppins(
//                                     color: AppColors.primary,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLogo() {
//     return Container(
//       width: 100,
//       height: 100,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: const Icon(
//         Icons.find_in_page_rounded,
//         size: 50,
//         color: AppColors.primary,
//       ),
//     );
//   }
//
//   Widget _buildLabel(String text) {
//     return Text(
//       text,
//       style: GoogleFonts.poppins(
//         fontSize: 14,
//         fontWeight: FontWeight.w600,
//         color: AppColors.textPrimary,
//       ),
//     );
//   }
//
//   Widget _buildEmailField(AuthViewModel viewModel) {
//     return TextFormField(
//       controller: _emailController,
//       focusNode: _emailFocus,
//       keyboardType: TextInputType.emailAddress,
//       textInputAction: TextInputAction.next,
//       enabled: !viewModel.isLoading,
//       style: GoogleFonts.poppins(),
//       decoration: InputDecoration(
//         hintText: 'Enter your email',
//         hintStyle: GoogleFonts.poppins(color: AppColors.textLight),
//         prefixIcon: const Icon(Icons.email_rounded, color: AppColors.primary),
//         filled: true,
//         fillColor: AppColors.background,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade200),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: AppColors.primary, width: 2),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: AppColors.error),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter your email';
//         }
//         if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//           return 'Please enter a valid email';
//         }
//         return null;
//       },
//       onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
//     );
//   }
//
//   Widget _buildPasswordField(AuthViewModel viewModel) {
//     return TextFormField(
//       controller: _passwordController,
//       focusNode: _passwordFocus,
//       obscureText: viewModel.obscurePassword,
//       textInputAction: TextInputAction.done,
//       enabled: !viewModel.isLoading,
//       style: GoogleFonts.poppins(),
//       decoration: InputDecoration(
//         hintText: 'Enter your password',
//         hintStyle: GoogleFonts.poppins(color: AppColors.textLight),
//         prefixIcon: const Icon(Icons.lock_rounded, color: AppColors.primary),
//         suffixIcon: IconButton(
//           icon: Icon(
//             viewModel.obscurePassword
//                 ? Icons.visibility_off_rounded
//                 : Icons.visibility_rounded,
//             color: AppColors.textSecondary,
//           ),
//           onPressed: viewModel.togglePasswordVisibility,
//         ),
//         filled: true,
//         fillColor: AppColors.background,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade200),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: AppColors.primary, width: 2),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: AppColors.error),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter your password';
//         }
//         if (value.length < 6) {
//           return 'Password must be at least 6 characters';
//         }
//         return null;
//       },
//       onFieldSubmitted: (_) => _handleLogin(),
//     );
//   }
//
//   Widget _buildLoginButton(AuthViewModel viewModel) {
//     return SizedBox(
//       height: 56,
//       child: ElevatedButton(
//         onPressed: viewModel.isLoading ? null : _handleLogin,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 0,
//         ),
//         child: viewModel.isLoading
//             ? const SizedBox(
//           height: 24,
//           width: 24,
//           child: CircularProgressIndicator(
//             color: Colors.white,
//             strokeWidth: 2,
//           ),
//         )
//             : Text(
//           'Sign In',
//           style: GoogleFonts.poppins(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }




// lib/view/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../viewmodel/auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = context.read<AuthViewModel>();
    final success = await viewModel.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final viewModel = context.read<AuthViewModel>();
    final success = await viewModel.signInWithGoogle();

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo/Icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.find_in_page_rounded,
                        size: 50,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      'Welcome Back!',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Sign in to continue',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Login Form Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            enabled: !viewModel.isLoading,
                            style: GoogleFonts.poppins(),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: GoogleFonts.poppins(),
                              hintText: 'Enter your email',
                              hintStyle: GoogleFonts.poppins(
                                  color: AppColors.textLight),
                              prefixIcon: const Icon(Icons.email_rounded,
                                  color: AppColors.primary),
                              filled: true,
                              fillColor: AppColors.background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.primary, width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: viewModel.obscurePassword,
                            enabled: !viewModel.isLoading,
                            style: GoogleFonts.poppins(),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: GoogleFonts.poppins(),
                              hintText: 'Enter your password',
                              hintStyle: GoogleFonts.poppins(
                                  color: AppColors.textLight),
                              prefixIcon: const Icon(Icons.lock_rounded,
                                  color: AppColors.primary),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  viewModel.obscurePassword
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: viewModel.togglePasswordVisibility,
                              ),
                              filled: true,
                              fillColor: AppColors.background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.primary, width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/forgot_password');
                              },
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          // Error Message
                          if (viewModel.errorMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline,
                                      color: AppColors.error, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      viewModel.errorMessage!,
                                      style: GoogleFonts.poppins(
                                        color: AppColors.error,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Login Button
                          SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed:
                              viewModel.isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: viewModel.isLoading
                                  ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : Text(
                                'Sign In',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          // Divider with "OR"
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey.shade300,
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    'OR',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey.shade300,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Google Sign-In Button
                          SizedBox(
                            height: 56,
                            child: OutlinedButton.icon(
                              onPressed: viewModel.isLoading
                                  ? null
                                  : _handleGoogleSignIn,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: viewModel.isLoading
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                                  : Image.asset(
                                'assets/images/google.png',
                                height: 24,
                                width: 24,
                                // If you don't have the Google logo asset, use this instead:
                                // errorBuilder: (context, error, stackTrace) =>
                                //     Icon(Icons.g_mobiledata, size: 24, color: Colors.red),
                              ),
                              label: Text(
                                'Continue with Google',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}