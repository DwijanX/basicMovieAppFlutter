import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/HomeBloc/homePage.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  GlobalKey<FormState> _signInKey = GlobalKey();
  TextEditingController _passController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  //auth
  final RegExp emailValid =
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

  LocalAuthentication localAuth = LocalAuthentication();
  _SupportState supportState = _SupportState.unknown;

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print("Error checking biometrics: $e");
      return;
    }

    setState(() {
      supportState = canCheckBiometrics
          ? _SupportState.supported
          : _SupportState.unsupported;
    });

    if (canCheckBiometrics) {
      // You can now authenticate using biometrics
      try {
        bool authenticated = await localAuth.authenticate(
          localizedReason:
              'Scan your fingerprint (or face or whatever) to authenticate',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
        print(authenticated);
        if (authenticated) {
          navigateToHome();
        } else {
          // Handle authentication failure
          // You may want to show a message to the user indicating that biometric authentication failed.
        }
      } catch (e) {
        print(e);
      }
    }
  }

  navigateToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeBloc()),
    );
  }

  onLogin(String email, String pass) async {
    if (email != "admin" || pass != "admin") {
      return;
    }
    final SharedPreferences prefs = await _prefs;

    await prefs.setBool('logged', true);
    navigateToHome();
    //save user
  }

  @override
  void initState() {
    super.initState();

    _prefs.then((SharedPreferences prefs) {
      var logged = prefs.getBool('logged') ?? false;
      var useBiometrics = prefs.getBool('useFingerPrint') ?? false;
      if (!logged) {
        return;
      }
      if (useBiometrics) {
        _checkBiometrics();
      } else {
        navigateToHome();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Form(
            key: _signInKey,
            child: Column(children: [
              Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30)),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "This field is required";
                    } else if (!emailValid.hasMatch(val)) {
                      return "Email is not valid";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: "Enter an email",
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30)),
                child: TextFormField(
                    controller: _passController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: "Enter your password",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20))),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)),
                child: TextButton(
                    onPressed: () {
                      onLogin(_emailController.text, _passController.text);
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              ),
            ])));
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
