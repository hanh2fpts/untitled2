import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:untitled2/main.dart';
import 'package:untitled2/overview.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage(
      {Key? key, required this.verificationId, required this.phoneNumber})
      : super(key: key);
  final String verificationId;
  final String phoneNumber;

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  static final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black26),
      borderRadius: BorderRadius.circular(15),
    ),
  );

  final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
    borderRadius: BorderRadius.circular(8),
  );

  final submittedPinTheme = defaultPinTheme.copyWith(
    decoration: defaultPinTheme.decoration?.copyWith(
      color: const Color.fromRGBO(234, 239, 243, 1),
      border: Border.all(color: Colors.amber),
    ),
  );
  final errorPinTheme = defaultPinTheme.copyWith(
    decoration: defaultPinTheme.decoration?.copyWith(
      color: Colors.red,
    ),
  );
  TextEditingController otpController = TextEditingController();

  verifyOtp() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId, smsCode: otpController.text);
      await auth.signInWithCredential(credential).then((value) {
        otpController.setText(credential.smsCode.toString());
        if (value.user != null) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Overview()));
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/images/message.json', height: 200),
            const Text('Enter Code',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                  "We've sent the OTP to your number +84 ${widget.phoneNumber}",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 40),
            Pinput(
              androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              isCursorAnimationEnabled:  true,
              onCompleted: (value) {
                verifyOtp();
              },
              length: 6,
              showCursor: true,
              autofocus: true,
              controller: otpController,
            )
          ],
        ),
      ),
    );
  }
}
