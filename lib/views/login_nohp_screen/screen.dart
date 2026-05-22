// lib/views/login_nohp_screen/screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/views/widgets/button.dart';
import 'package:mobile_supportyou/utils/alert.dart';
import 'package:mobile_supportyou/controllers/auth_controller.dart';
import 'package:mobile_supportyou/views/login_screen/screen.dart';
import 'package:mobile_supportyou/views/register_screen/screen.dart';

class LoginNoHpScreen extends StatelessWidget {
  const LoginNoHpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    final GlobalKey<FormState> form = GlobalKey<FormState>();
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        height: 200,
                        child: Image.asset('assets/logo/supportyou-logo-icon.png'),
                      ),
                    ),
                  ),
                ),
                Text(
                  'Masuk dengan No HP',
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
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val!.isEmpty) {
                      showErrorDialog('No HP tidak boleh kosong!');
                      return '';
                    }
                    if (val.length < 10) {
                      showErrorDialog('No HP tidak valid!');
                      return '';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: '08123xxx',
                    prefixIcon: Icon(Icons.phone_android, color: Colors.grey[500]),
                  ),
                ),
                const SizedBox(height: 20),
                DefaultButton(
                  text: 'Login',
                  press: () {
                    if (form.currentState!.validate()) {
                      controller.requestOtp();
                    }
                  },
                  color: primary,
                ),
                const SizedBox(height: 10),
                DefaultButtonOutline(
                  text: 'Login dengan Email',
                  press: () {
                    Get.off(() => const LoginScreen());
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