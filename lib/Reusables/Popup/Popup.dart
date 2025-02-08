import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zappy/Helpers/Mixins/PopUpMixin.dart';
import 'package:zappy/Helpers/Mixins/PopupMixinConfig.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';

import '../../../Helpers/ResponsiveUI.dart';
import '../CustomSvg.dart';

Future<void> showPopupWithSingleAction(
    BuildContext context, ShowPopupWithSingleAction event) {
  return showDialog(
      barrierDismissible: false,
      barrierColor: Styles.backgroundTertiary.withOpacity(0.7),
      context: context,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: Styles.backgroundPrimary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(ResponsiveUI.r(28, context)))),
          backgroundColor: Styles.backgroundPrimary,
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          insetPadding: EdgeInsets.only(
              left: ResponsiveUI.w(32, context),
              right: ResponsiveUI.w(32, context)),
          icon: SizedBox(
            height: ResponsiveUI.h(10, context),
          ),
          iconPadding: EdgeInsets.only(
              left: ResponsiveUI.w(24, context),
              right: ResponsiveUI.w(24, context),
              top: ResponsiveUI.h(40, context),
              bottom: ResponsiveUI.h(24, context)),
          titlePadding: EdgeInsets.only(
              left: ResponsiveUI.w(24, context),
              right: ResponsiveUI.w(24, context)),
          title: Text(
            event.popUpName,
            textAlign: TextAlign.center,
            style:
                Styles.h1(context).merge(TextStyle(color: Styles.textPrimary)),
          ),
          contentPadding: EdgeInsets.only(
              top: ResponsiveUI.h(24, context),
              left: ResponsiveUI.w(24, context),
              right: ResponsiveUI.w(24, context)),
          content: Text(
            event.description!,
            textAlign: TextAlign.center,
            style: Styles.body(context)
                .merge(TextStyle(color: Styles.textTertiary, height: 1.625)),
          ),
          actionsPadding: EdgeInsets.only(
              bottom: ResponsiveUI.h(30, context),
              top: ResponsiveUI.h(32, context),
              left: ResponsiveUI.w(24, context),
              right: ResponsiveUI.w(24, context)),
          actions: [
            FilledButton(
                onPressed: () => event.function(),
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        event.type == PopupType.success
                            ? Styles.primaryColor
                            : Styles.errorLight),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              ResponsiveUI.r(40, context))),
                    ),
                    fixedSize: WidgetStatePropertyAll(Size(
                      ResponsiveUI.w(281, context),
                      ResponsiveUI.h(48, context),
                    ))),
                child: Text(
                  event.buttonText,
                  style: Styles.button1(context)
                      .merge(TextStyle(color: Styles.backgroundSecondary)),
                ))
          ],
        );
      });
}

Future<void> showPopupWithMultiAction(
    BuildContext context, ShowPopupWithMultiAction event) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Styles.textPrimary.withOpacity(0.7),
      builder: (context) {
        return Container(
          height: 250,
          width: 300,
          decoration: BoxDecoration(color: Colors.transparent),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(event.popUpName),
              ElevatedButton(
                onPressed: () {
                  event.function[0]();
                },
                child: Text(event.buttonText[0]),
              ),
              ElevatedButton(
                onPressed: () {
                  event.function[1]();
                },
                child: Text(event.buttonText[1]),
              ),
            ],
          ),
        );
      });
}

class Popup {
  static Future<void> showPopup(
      BuildContext context, PopupBO event, GlobalKey alertKey) {
    return showDialog(
        context: context,
        barrierDismissible: event.isDismissable,
        barrierColor: Styles.textPrimary.withOpacity(0.7),
        builder: (context) {
          return AlertDialog(
            surfaceTintColor: Styles.backgroundPrimary,
            backgroundColor: event.type.style.bgColor,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(ResponsiveUI.r(8, context))),
            key: alertKey,
            alignment: Alignment.center,
            iconPadding: EdgeInsets.only(
                bottom: ResponsiveUI.h(16, context),
                top: ResponsiveUI.h(32, context)),
            icon: Center(
              child: CustomSvg(
                name: event.assetPath,
                width: ResponsiveUI.w(28, context),
                height: ResponsiveUI.h(25, context),
              ),
            ),
            titlePadding: EdgeInsets.only(
              left: ResponsiveUI.w(32, context),
              right: ResponsiveUI.w(32, context),
            ),
            title: Center(
              child: Text(
                event.title.toString(),
                style: Styles.h1(context).merge(
                  TextStyle(
                    color: event.type.style.titleColor,
                    height: 1.0325,
                  ),
                ),
              ),
            ),
            contentPadding: EdgeInsets.only(
              top: ResponsiveUI.h(16, context),
              left: ResponsiveUI.w(32, context),
              right: ResponsiveUI.w(32, context),
            ),
            content: Text(
              event.content,
              textAlign: TextAlign.center,
              style: Styles.h4(context).merge(
                TextStyle(
                  color: event.type.style.contentColor,
                  height: 1.625,
                ),
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: EdgeInsets.only(
              top: ResponsiveUI.h(24, context),
              bottom: ResponsiveUI.h(32, context),
              left: ResponsiveUI.w(32, context),
              right: ResponsiveUI.w(32, context),
            ),
            insetPadding: EdgeInsets.only(
              left: ResponsiveUI.w(24, context),
              right: ResponsiveUI.w(24, context),
            ),
            actions: [
              Column(
                  children: event.buttons.map((item) {
                switch (item.type) {
                  case ButtonType.filled:
                    return FilledButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        padding:
                            const MaterialStatePropertyAll(EdgeInsets.all(0)),
                        fixedSize: MaterialStatePropertyAll(
                          Size(
                            ResponsiveUI.w(281, context),
                            ResponsiveUI.h(48, context),
                          ),
                        ),
                        backgroundColor: MaterialStatePropertyAll(
                            event.type.style.primaryButtonColor),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveUI.r(24, context),
                            ),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          event.buttons[0].text,
                          textAlign: TextAlign.center,
                          style: Styles.button1(context).merge(
                            TextStyle(
                                color: event.type.style.primaryButtonTextColor,
                                height: 1.366),
                          ),
                        ),
                      ),
                    );
                  case ButtonType.text:
                    return Padding(
                      padding: EdgeInsets.only(
                        top: ResponsiveUI.h(16, context),
                      ),
                      child: TextButton(
                        onPressed: () {
                          event.buttons[1].onClick();
                        },
                        style: ButtonStyle(
                          padding:
                              const MaterialStatePropertyAll(EdgeInsets.all(0)),
                          fixedSize: MaterialStatePropertyAll(
                            Size(
                              ResponsiveUI.w(281, context),
                              ResponsiveUI.h(48, context),
                            ),
                          ),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveUI.r(5, context),
                              ),
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            event.buttons[1].text.toString(),
                            textAlign: TextAlign.center,
                            style: Styles.button1(context).merge(
                              TextStyle(
                                  color:
                                      event.type.style.secondaryButtonTextColor,
                                  height: 1.366),
                            ),
                          ),
                        ),
                      ),
                    );
                }
              }).toList())
            ],
          );
        });
  }
}
