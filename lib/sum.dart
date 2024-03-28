import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SumWidget extends StatefulWidget {
  const SumWidget({super.key});

  @override
  State<SumWidget> createState() => _SumWidgetState();
}

class _SumWidgetState extends State<SumWidget> {
  TextEditingController n1 = TextEditingController();
  TextEditingController n2 = TextEditingController();
  int sum = 0;
  void sumFields() {
    setState(() {
      sum = (int.tryParse(n1.text) ?? 0) + (int.tryParse(n2.text) ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        TextFormField(
          controller: n1,
        ),
        TextFormField(
          controller: n2,
        ),
        ElevatedButton(onPressed: sumFields, child: Text("Sumar")),
        Text("Resultado: ${sum}")
      ],
    ));
  }
}
