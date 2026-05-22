// lib/views/login_screen/screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/views/widgets/button.dart';
import 'package:mobile_supportyou/utils/alert.dart';
import 'package:mobile_supportyou/services/auth_service.dart';
import 'package:mobile_supportyou/views/login_nohp_screen/screen.dart';
import 'package:mobile_supportyou/views/register_screen/screen.dart';
import 'package:mobile_supportyou/views/main_screen/screen.dart';
import 'package:mobile_supportyou/views/forgot_password_screen/screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  GetStorage box = GetStorage();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  AuthService authService = AuthService();
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Center(
                    child: SizedBox(
                      height: 200,
                      child: Image.asset('assets/logo/supportyou-logo-icon.png'),
                    ),
                  ),
                ),
                Text(
                  'Masuk',
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Silahkan login di SupportYou',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val!.isEmpty) {
                      showErrorDialog('Email tidak boleh kosong!');
                      return '';
                    }
                    if (!GetUtils.isEmail(val)) {
                      showErrorDialog('Format email tidak valid!');
                      return '';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[500]),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: password,
                  obscureText: _obscureText,
                  validator: (val) {
                    if (val!.isEmpty) {
                      showErrorDialog('Password tidak boleh kosong!');
                      return '';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[500]),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey[500],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => const ForgotPasswordScreen());
                    },
                    child: Text(
                      'Lupa Password?',
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DefaultButton(
                  text: 'Login',
                  press: () {
                    if (form.currentState!.validate()) {
                      authService
                          .login(email: email.text, password: password.text)
                          .then((value) {
                            if (box.read('tokens') != null) {
                              form.currentState!.reset();
                              Get.offAll(
                                const MainScreen(),
                                transition: Transition.rightToLeft,
                              );
                            }
                          });
                    }
                  },
                  color: primary,
                ),
                const SizedBox(height: 10),
                DefaultButtonOutline(
                  text: 'Login dengan No HP',
                  press: () {
                    Get.to(() => const LoginNoHpScreen());
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Anda belum punya akun?'),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const RegisterScreen());
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}