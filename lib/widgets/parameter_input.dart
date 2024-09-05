import 'package:flutter/material.dart';

class ParameterInput extends StatelessWidget {
  final String label;
  final String initialValue;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const ParameterInput({
    Key? key,
    required this.label,
    required this.initialValue,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Text(label, style: const TextStyle(fontSize: 16)),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
            initialValue: initialValue,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            validator: validator,
            onSaved: onSaved,
          ),
        ),
      ],
    );
  }
}