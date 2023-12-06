import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/pallete.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final bool? obscureText;
  final bool? autoCorrect;
  final bool? enableSuggestions;

  const AuthField(
      {required this.controller,
      required this.hintText,
      required this.textInputType,
      this.obscureText,
      this.autoCorrect,
      this.enableSuggestions,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: obscureText ?? false,
      autocorrect: autoCorrect ?? true,
      enableSuggestions: enableSuggestions ?? true,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Pallete.blueColor, width: 3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Pallete.greyColor),
        ),
        contentPadding: const EdgeInsets.all(22),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
