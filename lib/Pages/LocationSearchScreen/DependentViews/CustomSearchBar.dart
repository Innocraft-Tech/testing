import 'package:flutter/material.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';

class CustomSearchBar extends StatelessWidget {
  final String LeadingText;
  final String hint;
  final Color dotColor;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onFocus;
  final Function(String) onChanged;
  final Function(String) onLocationSelected;

  const CustomSearchBar({
    super.key,
    required this.hint,
    required this.dotColor,
    required this.controller,
    required this.focusNode,
    required this.onFocus,
    required this.onChanged,
    required this.onLocationSelected,
    required this.LeadingText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveUI.h(68, context),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUI.w(20, context),
        vertical: ResponsiveUI.h(4, context),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveUI.r(10, context)),
        border: Border.all(
          color: Styles.textColor,
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: ResponsiveUI.w(12, context),
              height: ResponsiveUI.h(12, context),
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: ResponsiveUI.w(16, context)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.zero,
                  child: Text(
                    LeadingText,
                    style: TextStyle(
                      color: Styles.primaryColor,
                      fontSize: ResponsiveUI.sp(14, context),
                      fontFamily: "MontserratRegular",
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                Focus(
                  onFocusChange: (hasFocus) {
                    if (hasFocus) {
                      onFocus();
                    }
                  },
                  child: TextFormField(
                    scrollPadding: EdgeInsets.zero,
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: onChanged,
                    style: TextStyle(
                      color: Styles.textColor,
                      fontFamily: "MontserratSemiBold",
                      fontSize: ResponsiveUI.sp(14, context),
                    ),
                    decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(
                          color: Styles.textColor,
                          fontFamily: "MontserratRegular",
                          fontSize: ResponsiveUI.sp(14, context),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUI.w(0, context),
                          vertical: ResponsiveUI.h(0, context),
                        ),
                        constraints: BoxConstraints(
                            minHeight: ResponsiveUI.h(22, context),
                            maxHeight: ResponsiveUI.h(22, context))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





/**
 * Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            LeadingText,
            style: TextStyle(
                color: Styles.primaryColor,
                fontSize: ResponsiveUI.sp(14, context),
                fontFamily: "MontserratRegular"),
          ),
          Row(
            children: [
              Container(
                width: ResponsiveUI.w(12, context),
                height: ResponsiveUI.h(12, context),
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (hasFocus) {
                      onFocus();
                    }
                  },
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: onChanged,
                    style: TextStyle(
                      color: Styles.textColor,
                      fontFamily: "MontserratRegular",
                      fontSize: ResponsiveUI.sp(14, context),
                    ),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(
                        color: Styles.textColor,
                        fontFamily: "MontserratRegular",
                        fontSize: ResponsiveUI.sp(14, context),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUI.w(16, context),
                        // vertical: ResponsiveUI.h(15, context),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),

 */
