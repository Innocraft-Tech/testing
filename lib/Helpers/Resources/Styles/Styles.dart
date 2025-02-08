import 'package:flutter/material.dart';

import '../../ResponsiveUI.dart';

class Styles {
  static Color lightGreen = const Color(0xffB2E67E);

  static Color darkGrey = const Color(0xffE3E3E3);

  static Color lightBlue = const Color(0xffC3EBF5);

  static Color lightGrayishBlue = const Color(0xffE3F0F3);

  static Color rideItemBackground = const Color.fromRGBO(242, 242, 242, 1);

  static Color neutralGrey = const Color(0xffEDF1F3);

  static Color primaryGrey = const Color(0xffF0F0F0);

  static Color backgroundWhite = const Color(0xffFFFFFF);

  static Color disabledButton = const Color(0xff9F9F9F);

  static Color greemTextColor = const Color(0xff13A944);

  static Color grayText = const Color.fromRGBO(54, 54, 54, 1);

  static Color lightGrayText = Color.fromRGBO(185, 185, 185, 1);

  static LinearGradient greenGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xffFFFFFF).withOpacity(0.47),
        const Color(0xff574CFA)
      ]);

  //
  static Color transparent = Colors.transparent;

  static Color backgroundPrimary = Colors.white;

  static Color backgroundSecondary = const Color(0xfff7f7f7);

  static Color iconBackgroundPrimary = const Color(0xff191919);

  static Color iconBackgroundSecondary = const Color(0xffECECEC);

  static Color iconBackgroundTertiary = const Color(0xffF5D5D5);

  static Color iconBackgroundQuaternary = const Color(0xffFAF3D2);

  static Color iconBackgroundSenary = const Color(0xffF3F3F3);

  static Color iconPrimary = const Color(0xff9597A6);

  static Color socialIconBackground = const Color(0xffADD8E6).withOpacity(.5);

  static Color utilitiesIconBackground =
      const Color(0xffC0FCC0).withOpacity(.44);

  static Color entertainmentIconBackground = const Color(0xffFFF2DF);

  static Color gamesIconBackground = const Color(0xffFCE9FF);

  static Color healthFitnessIconBackground = const Color(0xff7BBDA9);

  static Color educationIconBackground =
      const Color(0xffADD8E6).withOpacity(.5);

  static Color productivityIconBackground = const Color(0xffE8EDFF);

  static Color notificationPositiveIconBackground = const Color(0xff10b20c);

  static Color notificationNegativeIconBackground = const Color(0xffFF0000);

  static Color animatedCheckboxPositiveColor = const Color(0xff64C585);

  static Color progressbarBackgroundPrimary = const Color(0xffE1E1E1);

  static Color cardBackgroundColor = const Color(0xffcdcdcd);

  static Color progressbarBackgroundSecondary = const Color(0xffE8E8E8);

  static Color progressbarBackgroundTertiar = const Color(0xffF1F1F1);

  static Color progressGreenPrimary = const Color(0xff96E2A7);

  static Color progressGreenSecondary = const Color(0xffD4FCAD);

  static Color progressRedPrimary = const Color(0xffFF827A);

  static Color progressOrangeSecondary = const Color(0xffFFC973);

  static Color customEclipsepaintColor = const Color(0xffE8FFD0);

  static Color progressBlue = const Color(0xff8FC3FC);

  static Color buttonPrimary = const Color(0xff574CFA);

  static Color categoryBackgroundPrimary = const Color(0xfff5f5f5);

  static Color waterScreenBorderColor = const Color(0XFFF4F4F4);

  static Color errorBorder = const Color(0xffFF6969);

  static Color carouselScreenbackgroundColor = const Color(0xff040404);

  static Color categoryBorderPrimary = const Color(0xffe0e0e0);

  static Color categoryBorderSecondary = const Color(0xffEBEBEB);

  static Color notificationBackground = const Color(0xffDF4343);

  static Color dividerColor = const Color(0xffE4E4E4);

  static Color wavePrimary = const Color(0xff65A7FF);

  static Color profilebackgroundContainerBorder = const Color(0xfff0f4f8);

  static Color basicDetailsBorderColor = const Color(0xffefefef);

  static Color waterIntakeBorderColor = Color(0xffa9cbf2);

  static Color waveSecondary = const Color(0xffCAE3FF);

  static Color cardBackgroundPrimary = const Color(0xffEAF4FF);

  static Color cardBackgroundSecondary = const Color(0xffcdcdcd);

  static Color cardBoarderPrimary = const Color(0xffD5D5D5);

  static Color cardBoarderSecondary = const Color(0xffE9EFF1);

  static Color cardBoarderTertiary = const Color(0xffD5E5FC);

  static Color cardBorderQuaternary = const Color(0xffeeeeee);

  static Color cardBorderSenary = const Color(0xffE9F2FF);

  static Color checkBoxBackground = const Color(0xff72a6f8);

  static Color backgroundShadowColor = const Color(0xff555e68);

  static Color textPrimary = Color(0xff574CFA);

  static Color shadowPrimary = Colors.black.withOpacity(.11);

  static Color shadowSecondary = const Color(0xff8f8f8f).withOpacity(.18);

  static Color shadowTertiary = const Color(0xffEDEEEE).withOpacity(.9);

  static Color textSecondary = const Color(0xff727272);

  static Color textTertiary = const Color(0xff000000);

  static Color textQuaternary = const Color(0xffAFAFAF);

  static Color subTextPrimary = const Color(0xff0C1118);

  static Color positiveText = const Color(0xff85DD2E);

  static Color placeHolderPrimary = const Color(0xff6C747C);

  static Color blueHighlight = const Color(0xff357bf8);

  static Color dividerPrimaryBackground = const Color(0xffDBDBDB);

  static Color buttonSecondary = const Color(0xffA6A6A6);

  static Color buttonTertiary = const Color(0xffD4D2D2);

  static Color buttonQuaternary = const Color(0xff73A7F8);

  static Color cardBackgroundQuaternary = const Color(0xffFFEF98);

  static Color textFieldBorderPrimary = const Color(0xffE7EAF2);

  static Color textFieldBorderSecondary = const Color(0xffEDF0F2);

  static Color menuTabBackgroundPrimary =
      const Color.fromARGB(255, 135, 195, 255);

  static Color menuTabBackgroundSecondary = Color.fromARGB(255, 184, 184, 186);

  static Color menuTabTextPrimary = const Color(0xff3E3E3E);

  static Color screenBackgroundColor = const Color(0xfff9f9f9);

  static Color graphSubTextPrimary = const Color(0xff535353);

  static Color toolTipBackground = const Color(0xffD9D9D9);

  static Color lineChartColorPrimary = const Color(0xff9BE94D);

  static Color lineChartColorSecondary = const Color(0xffD0D0D0);

  static Color toolTipTextPrimary = const Color(0xff4D4D4D);

  static Color barCharPrimary = const Color(0xffC4F98F);

  static Color buttonBorderPrimary = const Color(0xffF98C0C);

  static Color buttonSelectedOrange = const Color(0xffFFF7EE);

  static Color checkPrimary = const Color(0xff2F87FF);

  static Color tabButtonPrimary = const Color(0xffD0F8A8);

  static Color tabBorderPrimary = const Color(0xffE6E6E6);
  static Color textColor = const Color.fromRGBO(30, 30, 30, 1);
  static Color yellowTabBarColor = const Color.fromRGBO(255, 251, 0, 1);
  static Color lightGrayTextSecondary = const Color.fromRGBO(134, 132, 144, 1);
  static Color selectedVehicleColor = const Color.fromRGBO(87, 76, 250, 0.1);
  static Color greenButtonColor = const Color.fromRGBO(19, 169, 68, 1);
  static Color lightWhiteContainer = const Color.fromRGBO(255, 255, 255, 0.36);
  static Color blueBorderColor = const Color.fromRGBO(73, 69, 255, 1);
  static Color carouselRed = const Color(0xffE7523C);
  static Color blueContainer = const Color.fromRGBO(87, 76, 250, 1);
  // Create a static variable primaryColor of type Color
  static Color primaryColor = const Color(0xff574CFA);

  // Create a static variable primaryDark of type Color
  static Color primaryDark = const Color(0xff7BB05E);

  // Create a static variable primaryLight of type Color
  static Color primaryLight = const Color(0xffD2F8BD);

// Create a static variable secondaryColor of type Color
  static Color secondaryColor = const Color(0xff1E1E1E);

// Create a static variable secondaryDark of type Color
  static Color secondaryDark = const Color(0xff0C1118);

// Create a static variable secondaryLight of type Color
  static Color secondaryLight = const Color(0xff2A3851);

// Create a static variable accent1 of type Color
  static Color accent1 = const Color(0xff0A0D13);

// Create a static variable accent2 of type Color
  static Color accent2 = const Color(0xff51122D);

// Create a static variable neutralDark of type Color
  static Color neutralDark = const Color(0xff212121);

// Create a static variable neutralMedium of type Color
  static Color neutralMedium = const Color(0xffADB5BD);

// Create a static variable neutralLight of type Color
  static Color neutralLight = const Color(0xffE5E5E5);

  static Color timeCardBorderPrimary = const Color(0xff9EA4B8);

// Create a static variable textLight of type Color
  static Color textLight = const Color(0xffEEEEEE);

// Create a static variable backgroundTertiary of type Color
  static Color backgroundTertiary = const Color(0xff000000);

// Create a static variable transparentColor of type Color
  static Color transparentColor = Colors.transparent;

// Create a static variable primaryColorGradient of type List<Colors>
  static List<Color> primaryColorGradient = [
    const Color(0xff94D073),
    const Color(0xff94D073).withOpacity(0)
  ];
// Create a static variable primaryDarkGradient of type List<Colors>
  static List<Color> primaryDarkGradient = [
    const Color(0xff7BB05E),
    const Color(0xff7BB05E).withOpacity(0)
  ];
// Create a static variable primaryLightGradient of type List<Colors>
  static List<Color> primaryLightGradient = [
    const Color(0xffD2F8BD),
    const Color(0xffD2F8BD).withOpacity(0)
  ];
// Create a static variable secondaryColorGradient of type List<Colors>
  static List<Color> secondaryColorGradient = [
    const Color(0xff141B27),
    const Color(0xff141B27).withOpacity(0)
  ];
// Create a static variable secondaryDarkGradient of type List<Colors>
  static List<Color> secondaryDarkGradient = [
    const Color(0xff141B27),
    const Color(0xff141B27).withOpacity(0)
  ];
// Create a static variable secondaryLightGradient of type List<Colors>
  static List<Color> secondaryLightGradient = [
    const Color(0xff2A3851),
    const Color(0xff2A3851).withOpacity(0)
  ];

  static Map<String, Color> appUsageIconBackgroundColor = {
    "Social": const Color(0xffADD8E6).withOpacity(.5),
    "Utilities": const Color(0xffC0FCC0).withOpacity(.44),
    "Entertainment": const Color(0xffFFF2DF),
    "Games": const Color(0xffFCE9FF),
    "Health & Fitness": const Color(0xffDAFFF4),
    "Education": const Color(0xffD6EBF2),
    "Productivity": const Color(0xffE8EDFF)
  };

  static List<Color> greenRadialGradient = [
    const Color(0xff78E3AF).withOpacity(0.65),
    const Color(0xff0E8BB1).withOpacity(0.65)
  ];
  static List<Color> moonrackerRadialGradient = [
    const Color(0xffDA78E3).withOpacity(0.15),
    const Color(0xff383DB7).withOpacity(0.15)
  ];
  static List<Color> almondRadialGradient = [
    const Color(0xffE3D878).withOpacity(0.15),
    const Color(0xffB74F38).withOpacity(0.15)
  ];

  static LinearGradient blueGradient =
      const LinearGradient(colors: [Color(0xffF2FDFF), Color(0xffE9FBFF)]);

  static Color warningLight = const Color(0xffFFEFB7);

  static Color successColor = const Color(0xff48C375);

  static Color warningColor = const Color(0xffFFDB5E);

  static Color errorColor = const Color(0xffFF472E);

  static Color errorLight = const Color(0xffEA5656);

  static Color textFieldBackground = const Color(0xffF0F0F0);

  static TextStyle getFontStyle(
      context, Function englishFont, Function tamilFont) {
    if (Localizations.localeOf(context).languageCode == "en") {
      return englishFont(context);
    }
    return tamilFont(context);
  }

  // vasanth
  static Color fitnessDividerColor = const Color(0xff454545);
  static Color textMediumGrey = const Color(0xffB8B8B8);
  static Color fitnessButtonColor = const Color(0xffD0F8A8);
  static Color fitNessBorderColor = const Color(0xffE6E6E6);
  static Color nextSpotifyPlayButtonColor = const Color(0xffF4F4F4);
  static Color nextplayButtonColor = const Color(0xffAFAFAF);
  static Color barBorderColor = const Color(0xffDBDBDB);
  static Color textSecondaryGrey = const Color(0xff999191);
  static Color textsecondaryBlack = const Color(0xff232121);
  static Color snackBarPauseColor = const Color(0xffEC9B4F);
  static Color snackBarColor = const Color(0xffFFF0E2);
  static Color lightGrey = const Color(0xffECECED);
  static Color darkBlue = const Color(0xff0F1929);
  static Color textMediumDarkGrey = const Color(0xffA7A7A7);
  static Color purple = const Color(0xffA26FFD);
  static Color lightRed = const Color(0xffFFDEDE);
  static Color textRegularGrey = const Color(0xff535353);
  static Color textNormalGrey = const Color(0xff858585);
  static Color blackPrimary = const Color(0xff191919);
  static Color textDarkGrey = const Color(0xff585858);
  static Color textLightGrey = const Color(0xffB9B9B9);
  static Color sleepBorder = const Color(0xffEBEBEB);
  static Color secondaryBlue = const Color(0xff4C90EB);
  static Color cardSecondaryColor = const Color(0xffCDCDCD).withOpacity(0.11);

  // Create a method h1 that gets the context as parameter and returns the text style for h1
  static TextStyle h1(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(24, context),
      fontFamily: 'ManropeBold',
      fontWeight: FontWeight.w700,
    );
  }

  static h2(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(24, context),
      fontFamily: 'SequelSansSemiBoldDisp',
      fontWeight: FontWeight.w400,
      height: 1.18,
      letterSpacing: 0.05,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static h3(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(24, context),
      fontFamily: 'SequelSansRomanDisp',
      fontWeight: FontWeight.w400,
      height: 1.18,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static h4(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(20, context),
      fontFamily: 'SequelSansMediumDisp',
      fontWeight: FontWeight.w400,
      height: 1.3,
      letterSpacing: 0.05,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static subtitle1(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(18, context),
      fontFamily: 'SequelSansMediumDisp',
      fontWeight: FontWeight.w400,
      height: 1.56,
      // letterSpacing: ResponsiveUI.sp(18, context)*0.02,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static subtitle2(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(14, context),
      fontFamily: 'SequelSansMediumDisp',
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0.05,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static caption1(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(12, context),
      fontFamily: 'SequelSansRomanDisp',
      fontWeight: FontWeight.w400,
      height: 1.3,
      letterSpacing: 0.05,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static caption2(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(9, context),
      fontFamily: 'SequelSansMediumDisp',
      fontWeight: FontWeight.w400,
      height: 1.76,
      letterSpacing: 0.02,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static tab(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(20, context),
      fontFamily: 'SequelSansRomanDisp',
      fontWeight: FontWeight.w400,
      height: 1.76,
      letterSpacing: 0.02,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static body(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(14, context),
      fontFamily: 'SequelSansBookDisp',
      fontWeight: FontWeight.w400,
      height: 1.6,
      letterSpacing: 0.02,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  // Create a method body2 that gets the context as parameter and returns the text style for body2
  static TextStyle body2(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(14, context),
      fontFamily: 'ManropeMedium',
      fontWeight: FontWeight.w500,
    );
  }

  static error(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(12.5, context),
      fontFamily: 'SequelSansBookDisp',
      fontWeight: FontWeight.w400,
      height: 1.18,
      letterSpacing: 0.05,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static label(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(16, context),
      fontFamily: 'SequelSansRomanDisp',
      fontWeight: FontWeight.w400,
      height: 1.3,
      letterSpacing: 0.05,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static placeholder(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(14, context),
      fontFamily: 'SequelSansLightDisp',
      fontWeight: FontWeight.w400,
      height: 1.6,
      letterSpacing: 0.06,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static button1(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(16, context),
      fontFamily: 'SequelSansMediumDisp',
      fontWeight: FontWeight.w400,
      height: 1.18,
      letterSpacing: 0.05,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static button2(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(10, context),
      fontFamily: 'SequelSansBookDisp',
      fontWeight: FontWeight.w400,
      height: 1.76,
      letterSpacing: 0.05,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static number1(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(70, context),
      fontFamily: 'SequelSansBoldDisp',
      fontWeight: FontWeight.w400,
      height: 1.42,
      letterSpacing: 0.05,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static number2(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(40, context),
      fontFamily: 'SequelSansSemiBoldDisp',
      fontWeight: FontWeight.w400,
      color: Colors.blue,
      height: 1.42,
      letterSpacing: 0.05,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static number3(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(32, context),
      fontFamily: 'SequelSansSemiBoldDisp',
      fontWeight: FontWeight.w400,
      height: 1.42,
      letterSpacing: 0.05,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static number4(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(6, context),
      fontFamily: 'SequelSansSemiBoldDisp',
      fontWeight: FontWeight.w400,
      height: 0.625,
      letterSpacing: 0.05,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static subText1(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(18, context),
      fontFamily: 'SequelSansMediumDisp',
      fontWeight: FontWeight.w400,
      height: 1.55,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static subText2(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUI.sp(11, context),
      fontFamily: 'SequelSansBookDisp',
      fontWeight: FontWeight.w400,
      height: 1.81,
      textBaseline: TextBaseline.alphabetic,
    );
  }
}
