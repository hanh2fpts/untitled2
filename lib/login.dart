import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled2/otp_verification_page.dart';

import 'bloc/login_bloc.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController phoneNumberController;
  @override
  void initState() {
    super.initState();
    phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    phoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is SendOtpSuccess) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const OtpVerificationPage()));
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Stack(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/images/mobile.json',
                      alignment: Alignment.topCenter,
                      height: 160,
                    ),
                    const Text(
                      'Your phone',
                      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child:
                          Text('Please confirm your country code and enter your phone number.', style: TextStyle(fontSize: 16, color: Colors.black), textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                        keyboardType: TextInputType.phone,
                        controller: phoneNumberController,
                        style: const TextStyle(fontSize: 20),
                        autofocus: true,
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(fontSize: 20),
                            labelStyle: TextStyle(fontSize: 20),
                            prefixIcon: SizedBox(
                              width: 60,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '+84',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            hintText: 'Your phone number',
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))))),
                    const SizedBox(height: 10),
                  ],
                ),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            minimumSize: const Size.fromHeight(50),
                          ),
                          onPressed: () {
                            //context.read<LoginBloc>().isLoading.value = true;
                            context.read<LoginBloc>().add(SendOtpEvent(phoneNumber: phoneNumberController.text));
                          },
                          child: const Text(
                            'Continue',
                            style: TextStyle(fontSize: 18),
                          )),
                    );
                  },
                ),
              ]),
            ),
          )),
    );
  }
}
