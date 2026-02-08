// lib/views/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../viewmodel/auth_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept terms and conditions'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final viewModel = context.read<AuthViewModel>();
    final success = await viewModel.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/login');
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
          child: Column(
            children: [
              // Back Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Logo
                      _buildLogo(),
                      const SizedBox(height: 24),

                      // Title
                      Text(
                        'Create Account',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Join us to find your lost items',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Register Form Card
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Name Field
                              _buildLabel('Full Name'),
                              const SizedBox(height: 8),
                              _buildNameField(viewModel),
                              const SizedBox(height: 20),

                              // Email Field
                              _buildLabel('Email'),
                              const SizedBox(height: 8),
                              _buildEmailField(viewModel),
                              const SizedBox(height: 20),

                              // Password Field
                              _buildLabel('Password'),
                              const SizedBox(height: 8),
                              _buildPasswordField(viewModel),
                              const SizedBox(height: 20),

                              // Confirm Password Field
                              _buildLabel('Confirm Password'),
                              const SizedBox(height: 8),
                              _buildConfirmPasswordField(viewModel),
                              const SizedBox(height: 20),

                              // Terms Checkbox
                              _buildTermsCheckbox(),

                              // Error Message
                              if (viewModel.errorMessage != null) ...[
                                const SizedBox(height: 12),
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
                              ],

                              const SizedBox(height: 24),

                              // Register Button
                              _buildRegisterButton(viewModel),
                              const SizedBox(height: 20),

                              // Login Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account? ',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Text(
                                      'Sign In',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.primary,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.person_add_rounded,
        size: 40,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildNameField(AuthViewModel viewModel) {
    return TextFormField(
      controller: _nameController,
      focusNode: _nameFocus,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      enabled: !viewModel.isLoading,
      style: GoogleFonts.poppins(),
      decoration: _inputDecoration(
        hintText: 'Enter your full name',
        prefixIcon: const Icon(Icons.person_rounded, color: AppColors.primary),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        if (value.length < 3) {
          return 'Name must be at least 3 characters';
        }
        return null;
      },
      onFieldSubmitted: (_) => _emailFocus.requestFocus(),
    );
  }

  Widget _buildEmailField(AuthViewModel viewModel) {
    return TextFormField(
      controller: _emailController,
      focusNode: _emailFocus,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      enabled: !viewModel.isLoading,
      style: GoogleFonts.poppins(),
      decoration: _inputDecoration(
        hintText: 'Enter your email',
        prefixIcon: const Icon(Icons.email_rounded, color: AppColors.primary),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
    );
  }

  Widget _buildPasswordField(AuthViewModel viewModel) {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocus,
      obscureText: viewModel.obscurePassword,
      textInputAction: TextInputAction.next,
      enabled: !viewModel.isLoading,
      style: GoogleFonts.poppins(),
      decoration: _inputDecoration(
        hintText: 'Create a password',
        prefixIcon: const Icon(Icons.lock_rounded, color: AppColors.primary),
        suffixIcon: IconButton(
          icon: Icon(
            viewModel.obscurePassword
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
            color: AppColors.textSecondary,
          ),
          onPressed: viewModel.togglePasswordVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      onFieldSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
    );
  }

  Widget _buildConfirmPasswordField(AuthViewModel viewModel) {
    return TextFormField(
      controller: _confirmPasswordController,
      focusNode: _confirmPasswordFocus,
      obscureText: viewModel.obscureConfirmPassword,
      textInputAction: TextInputAction.done,
      enabled: !viewModel.isLoading,
      style: GoogleFonts.poppins(),
      decoration: _inputDecoration(
        hintText: 'Confirm your password',
        prefixIcon: const Icon(Icons.lock_rounded, color: AppColors.primary),
        suffixIcon: IconButton(
          icon: Icon(
            viewModel.obscureConfirmPassword
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
            color: AppColors.textSecondary,
          ),
          onPressed: viewModel.toggleConfirmPasswordVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
      onFieldSubmitted: (_) => _handleRegister(),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() => _acceptTerms = value ?? false);
          },
          activeColor: AppColors.primary,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() => _acceptTerms = !_acceptTerms);
            },
            child: Text.rich(
              TextSpan(
                text: 'I agree to the ',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                children: [
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(AuthViewModel viewModel) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: viewModel.isLoading ? null : _handleRegister,
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
          'Create Account',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required Widget prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(color: AppColors.textLight),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}