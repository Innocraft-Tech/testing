import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationHelpers.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/Mixins/PopUpMixin.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Pages/NameScreen/NameScreenVM.dart';
import 'package:zappy/Reusables/Popup/Popup.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  TextEditingController nameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  final NameScreenVM _nameScreenVM = NameScreenVM();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameScreenVM.navigationStream.stream.listen((event) {
      if (event is NavigatorPushReplace) {
        context.pushReplace(pageConfig: event.pageConfig);
      } else if (event is NavigatorPop) {
        context.pop();
      }
    });
    _nameScreenVM.popUpController.stream.listen((event) {
      if (event is ShowPopupWithSingleAction) {
        showPopupWithSingleAction(context, event);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: ResponsiveUI.w(10, context)),
              child: SvgPicture.asset(
                AppConstants.rightArrow,
                width: ResponsiveUI.w(24, context),
                height: ResponsiveUI.h(24, context),
                color: Styles.textsecondaryBlack,
              ),
            ),
            Text(
              "Back",
              style: TextStyle(
                fontSize: ResponsiveUI.sp(16, context),
                fontFamily: "MontserratSemiBold",
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        leadingWidth: ResponsiveUI.w(0, context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveUI.w(14, context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: ResponsiveUI.h(30, context),
                  top: ResponsiveUI.h(42, context)),
              child: Text(
                "What’s your name?",
                style: TextStyle(
                  fontSize: ResponsiveUI.sp(22, context),
                  fontFamily: "MontserratSemiBold",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextFormField(
              controller: nameController,
              focusNode: nameFocusNode,
              onTapOutside: (event) => nameFocusNode.unfocus(),
              decoration: InputDecoration(
                  hintText: "Enter your name",
                  hintStyle: TextStyle(
                      fontSize: ResponsiveUI.sp(16, context),
                      fontWeight: FontWeight.w400,
                      fontFamily: "MontserratRegular",
                      color: Styles.secondaryColor),
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(ResponsiveUI.r(10, context)),
                      borderSide: BorderSide(
                          color: Styles.secondaryColor,
                          width: ResponsiveUI.w(1, context))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(ResponsiveUI.r(10, context)),
                      borderSide: BorderSide(
                          color: Styles.secondaryColor,
                          width: ResponsiveUI.w(1, context))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(ResponsiveUI.r(10, context)),
                      borderSide: BorderSide(
                          color: Styles.secondaryColor,
                          width: ResponsiveUI.w(1, context)))),
            ),
            SizedBox(
              height: ResponsiveUI.h(58, context),
            ),
            FilledButton(
              onPressed: () {
                _nameScreenVM.submitDetails(nameController.text);
              },
              child: Text(
                "Save",
                style: TextStyle(
                  fontSize: ResponsiveUI.sp(14, context),
                  fontFamily: "MontserratSemiBold",
                ),
              ),
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Styles.primaryColor),
                  minimumSize: MaterialStatePropertyAll(
                    Size(ResponsiveUI.w(370, context),
                        ResponsiveUI.h(48, context)),
                  ),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(ResponsiveUI.r(10, context))))),
            )
          ],
        ),
      ),
    );
  }
}
