import 'package:flutter/material.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';

class CustomRupeeController extends TextEditingController {
  static const String prefix = "RS ";

  CustomRupeeController({String? text}) : super(text: text ?? prefix);

  @override
  set text(String newText) {
    // Ensure the prefix is always present
    if (!newText.startsWith(prefix)) {
      newText = prefix + newText;
    }
    super.text = newText;
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    return TextSpan(
      children: [
        TextSpan(
          text: prefix,
          style: TextStyle(
            fontSize: ResponsiveUI.sp(30, context),
            fontFamily: "MontserratBold",
            color: Colors.grey,
          ),
        ),
        TextSpan(
          text: text.substring(prefix.length),
          style: TextStyle(
            fontSize: ResponsiveUI.sp(30, context),
            fontFamily: "MontserratBold",
            color: Styles.blackPrimary,
          ),
        ),
      ],
    );
  }

  @override
  set selection(TextSelection newSelection) {
    // Prevent selection from starting before the prefix
    if (newSelection.start < prefix.length) {
      super.selection = newSelection.copyWith(
        extentOffset: max(prefix.length, newSelection.extentOffset),
      );
    } else {
      super.selection = newSelection;
    }
  }

  @override
  TextSelection get selection => super.selection;

  // Override value setter to prevent deletion of prefix
  @override
  set value(TextEditingValue newValue) {
    // If the new value doesn't start with prefix, maintain the prefix
    if (!newValue.text.startsWith(prefix)) {
      final int offset = newValue.selection.baseOffset;
      newValue = TextEditingValue(
        text: prefix,
        selection: TextSelection.collapsed(offset: offset + prefix.length),
      );
    }
    super.value = newValue;
  }

  int max(int a, int b) {
    return a > b ? a : b;
  }
}
