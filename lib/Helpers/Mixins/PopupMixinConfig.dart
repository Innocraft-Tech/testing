import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';

// Declare the PopupStyleBO class to define styling for different popup types
class PopupStyleBO {
  Color? themeColor;
  Color? bgColor;
  Color titleColor;
  Color contentColor;
  Color primaryButtonColor;
  Color primaryButtonTextColor;
  Color? secondaryButtonColor;
  Color? secondaryButtonTextColor;

  PopupStyleBO({
    this.themeColor,
    this.bgColor = Colors.white,
    required this.titleColor,
    required this.contentColor,
    required this.primaryButtonColor,
    required this.primaryButtonTextColor,
    this.secondaryButtonColor,
    this.secondaryButtonTextColor,
  });
}

// Declare a PopupType enum to list the Popup Types
enum PopupType { warning, error, success, information }

// Declare a PopupTypeExtension extension method on PopupType to return the PopupStyleBO based on the PopupType
extension PopupTypeExtension on PopupType {
  PopupStyleBO get style {
    switch (this) {
      case PopupType.warning:
        return PopupStyleBO(
            themeColor: Styles.warningLight,
            titleColor: Styles.textPrimary,
            contentColor: Styles.textSecondary,
            primaryButtonColor: Styles.buttonPrimary,
            primaryButtonTextColor: Styles.textPrimary,
            secondaryButtonColor: Colors.transparent,
            secondaryButtonTextColor: Styles.errorLight);
      case PopupType.error:
        return PopupStyleBO(
            titleColor: Styles.textPrimary,
            contentColor: Styles.textPrimary,
            primaryButtonColor: Styles.errorColor,
            primaryButtonTextColor: Styles.textPrimary,
            secondaryButtonColor: Colors.transparent,
            secondaryButtonTextColor: Styles.textPrimary);
      case PopupType.success:
        return PopupStyleBO(
            titleColor: Styles.textPrimary,
            contentColor: Styles.textTertiary,
            primaryButtonColor: Styles.buttonPrimary,
            primaryButtonTextColor: Styles.textPrimary);
      case PopupType.information:
        return PopupStyleBO(
            themeColor: Styles.warningLight,
            titleColor: Styles.textPrimary,
            contentColor: Styles.textSecondary,
            primaryButtonColor: Styles.buttonPrimary,
            primaryButtonTextColor: Styles.textPrimary,
            secondaryButtonColor: Colors.transparent,
            secondaryButtonTextColor: Styles.textSecondary);
    }
  }
}
