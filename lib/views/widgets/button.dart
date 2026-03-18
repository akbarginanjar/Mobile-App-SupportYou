import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_supportyou/config/theme.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    super.key,
    required this.text,
    required this.press,
    required this.color,
  });
  final String? text;
  final Color? color;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          // ignore: deprecated_member_use
          foregroundColor: Colors.white,
          backgroundColor: color,
        ),
        onPressed: press as Function()?,
        child: Text(
          text!,
          style: GoogleFonts.montserrat(
            fontSize: 17,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class DefaultButtonSecond extends StatelessWidget {
  const DefaultButtonSecond({super.key, this.text, this.press});
  final String? text;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          // ignore: deprecated_member_use
          foregroundColor: theme,
          backgroundColor: theme,
        ),
        onPressed: press as Function()?,
        child: Text(
          text!,
          style: GoogleFonts.montserrat(
            fontSize: 17,
            color: textTheme,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class DefaultButtonOutline extends StatelessWidget {
  const DefaultButtonOutline({super.key, this.text, this.press});
  final String? text;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
            side: BorderSide(color: primary),
          ),
          // ignore: deprecated_member_use
          foregroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        onPressed: press as Function()?,
        child: Text(
          text!,
          style: GoogleFonts.montserrat(
            fontSize: 17,
            color: primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class DefaultButtonRound extends StatelessWidget {
  const DefaultButtonRound({super.key, this.text, this.press});
  final String? text;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: primary),
          ),
        ),
        onPressed: press as void Function()?,
        child: Text(
          text!,
          style: GoogleFonts.montserrat(
            fontSize: 20,
            color: primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class SplashButton extends StatelessWidget {
  const SplashButton({super.key, this.text, this.press});
  final String? text;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          // ignore: deprecated_member_use
          foregroundColor: Colors.white,
          backgroundColor: primary,
        ),
        onPressed: press as void Function()?,
        child: Row(
          children: [
            Text(
              text!,
              style: GoogleFonts.montserrat(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
