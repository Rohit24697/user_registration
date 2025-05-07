import 'package:flutter/material.dart';

class CommonButtonWidget extends StatelessWidget {
  const CommonButtonWidget({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.buttonLabel,
    required this.onClick,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final String buttonLabel;
  ///when we want to pass data from parent widget to child widget then we can use Constructor
  ///when we want to pass data from child widget to parent widget then we have 2 options
  /// 1.By using Function
  /// 2. By using VoidCallback
  ///When we want to pass parameter then we can use Function
  ///we can use Function to pass without parameter as well
  // final Function(String buttonName) onButtonClick;
  ///We cannot pass parameter from this callback
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: ElevatedButton(
          onPressed: () {
            onClick();
            // if (_formKey.currentState!.validate()) {
            //   // If the email is valid, perform login action
            //   ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //           content: Text(
            //               'Logging In Successfully')));
            // }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: WidgetStateColor.resolveWith((state)=>Color(0xFFFBBB3B))),
          child: Text(
            buttonLabel,
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          )),
    );
  }
}