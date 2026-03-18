import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/auth_controller.dart';
import 'package:mobile_supportyou/views/login_screen/screen.dart';
// import 'package:mobile_supportyou/views/register_screen.dart';
import 'package:mobile_supportyou/views/widgets/button.dart';

class LoginNoHpScreen extends StatelessWidget {
  const LoginNoHpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    final GlobalKey<FormState> form = GlobalKey<FormState>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 10),
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
                'Silahkan login dengan No HP',
                style: GoogleFonts.poppins(fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 10),

              // Input No HP
              Container(
                margin: const EdgeInsets.symmetric(vertical: 7),
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  controller: controller.phoneController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'No HP tidak boleh kosong!';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: '08123xxx',
                    prefixIcon: Icon(Icons.phone_android, color: Colors.grey[500]),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Tombol Login (Request OTP)
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

              // Tombol pindah ke Login Email
              DefaultButtonSecond(
                text: 'Login dengan Email',
                press: () {
                  Get.off(() => LoginScreen());
                },
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Anda belum punya akun? '),
                  TextButton(
                    onPressed: () {
                      // Get.to(() => const RegisterScreen(),
                      //     transition: Transition.rightToLeftWithFade);
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}