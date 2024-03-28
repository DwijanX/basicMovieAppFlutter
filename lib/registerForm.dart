import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  GlobalKey<FormState> _registerKey = GlobalKey();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _verifypassController = TextEditingController();
  final RegExp emailValid =
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Form(
            key: _registerKey,
            child: Column(children: [
              MyFormField(
                fieldController: _nameController,
                inputDecoration: const InputDecoration(
                    labelText: "Enter your Name",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
              ),
              MyFormField(
                fieldController: _lastNameController,
                inputDecoration: const InputDecoration(
                    labelText: "Enter your last name",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
              ),
              MyFormField(
                fieldController: _emailController,
                inputDecoration: const InputDecoration(
                    labelText: "Enter your email",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "This field is required";
                  } else if (!emailValid.hasMatch(val)) {
                    return "Email is not valid";
                  }
                  return null;
                },
              ),
              MyFormField(
                fieldController: _passController,
                obscureText: true,
                inputDecoration: const InputDecoration(
                    labelText: "Enter your password",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
              ),
              MyFormField(
                fieldController: _verifypassController,
                obscureText: true,
                inputDecoration: const InputDecoration(
                    labelText: "Re enter your password",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "This field is required";
                  } else if (val != _passController.text) {
                    return "Passwords must match";
                  }
                  return null;
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)),
                child: TextButton(
                    onPressed: () {
                      if (_registerKey.currentState!.validate()) {
                        debugPrint("Email: ${_emailController.text}");
                      }
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              ),
            ])));
  }
}

class MyFormField extends StatefulWidget {
  const MyFormField(
      {super.key,
      required this.fieldController,
      required this.inputDecoration,
      this.validator,
      this.obscureText = false});

  final TextEditingController fieldController;
  final InputDecoration inputDecoration;
  final String? Function(String)? validator;
  final bool obscureText;

  @override
  State<MyFormField> createState() => _MyFormFieldState();
}

class _MyFormFieldState extends State<MyFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(30)),
        child: TextFormField(
            validator: (value) {
              if (widget.validator != null) {
                return widget.validator!(value!);
              }
              return null;
            },
            controller: this.widget.fieldController,
            obscureText: widget.obscureText,
            decoration: this.widget.inputDecoration));
  }
}
