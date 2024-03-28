import 'package:flutter/material.dart';
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
  final RegExp emailValid =
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

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
      if (logged) {
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
