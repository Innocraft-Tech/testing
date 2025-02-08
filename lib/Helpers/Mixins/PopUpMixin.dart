// ignore_for_file: file_names
import 'dart:async';

import 'PopupMixinConfig.dart';

/* Create an IPopUp abstract class */
abstract class IPopUp {}

// Create ShowPopupWithSingleAction class to show popup to the user
class ShowPopupWithSingleAction<T> extends IPopUp {
  PopupType type;
  String popUpName;
  String? description;
  String? iconUrl;
  String buttonText;
  T function;

  ShowPopupWithSingleAction({
    required this.popUpName,
    required this.buttonText,
    required this.function,
    this.type = PopupType.information,
    this.iconUrl,
    this.description,
  });
}

class ShowSingleActionPopup<T> extends IPopUp {
  PopupType type;
  String popUpName;
  String? description;
  String? iconUrl;
  String buttonText;
  T function;

  ShowSingleActionPopup({
    required this.popUpName,
    required this.buttonText,
    required this.function,
    this.type = PopupType.information,
    this.iconUrl,
    this.description,
  });
}

class PopupBO<T> extends IPopUp {
  String assetPath;
  String title;
  String content;
  PopupType type;
  bool isDismissable;
  List<PopupButtonBO> buttons;

  PopupBO({
    required this.assetPath,
    required this.title,
    required this.content,
    required this.type,
    this.isDismissable = true,
    required this.buttons,
  });
}

class PopupButtonBO {
  final String text;
  final ButtonType type;
  final bool isPrimary;
  final void Function() onClick;

  PopupButtonBO({
    required this.text,
    required this.type,
    required this.isPrimary,
    required this.onClick,
  });
}

enum ButtonType { text, filled }

class PopupRestartBO<T> extends IPopUp {
  final String question;
  final List<Options> options;
  final String buttonText;
  final String? image;
  final int? duration;
  final void Function() action;

  PopupRestartBO({
    this.image,
    this.duration,
    required this.question,
    required this.options,
    required this.buttonText,
    required this.action,
  });
}

class PopupGifBO<T> extends IPopUp {
  final String image;
  final int duration;

  PopupGifBO({
    required this.image,
    required this.duration,
  });
}

class CreateAccountPopup<T> extends IPopUp {
  String assetPath;
  String title;
  String content;
  PopupType type;
  bool isDismissable;
  List<PopupButtonBO> buttons;

  CreateAccountPopup({
    required this.assetPath,
    required this.title,
    required this.content,
    required this.type,
    this.isDismissable = true,
    required this.buttons,
  });
}

class Options {
  String title;
  String description;
  Options({required this.title, required this.description});
}

// Create a mixin PopUpMixin and have a streamcontroller and method to add and dispose events and controller
mixin PopUpMixin {
  // Initailize a streamController to listen the emitted events
  StreamController<IPopUp> popUpController = StreamController<IPopUp>();

  /* Create setPopUpEvent method and add the event into the StreamController variable "popUpController" */
  void setPopUpEvent({required IPopUp event}) {
    // Add event inside the stream
    popUpController.add(event);
  }

  /* Create closePopUpMixin method to close the popUpController*/
  void closePopUpMixin() async {
    //  Stop the stream listeneing using close function
    await popUpController.close();
  }
}

// Create ShowPopupWithMultiAction class to show popup to the user
class ShowPopupWithMultiAction<T> extends IPopUp {
  String popUpName;
  String? description;
  String? iconUrl;
  List<String> buttonText;
  List<T> function;
  PopupType type;
  bool? deletePopup;

  ShowPopupWithMultiAction(
      {required this.popUpName,
      required this.buttonText,
      required this.function,
      this.type = PopupType.information,
      this.iconUrl,
      this.description,
      this.deletePopup});
}

class OtherExercisePopup<T> extends IPopUp {
  final Function updateFunction;
  final Function popFunction;

  OtherExercisePopup({
    required this.updateFunction,
    required this.popFunction,
  });
}

// Create a mixin PopUpMixin and have a streamcontroller and method to add and dispose events and controller
mixin PopUpMixins {
  // Initailize a streamController to listen the emitted events
  StreamController<IPopUp> popUpController = StreamController<IPopUp>();

  /* Create setPopUpEvents method and add the event into the StreamController variable "popUpController" */
  void setPopUpEvents({required IPopUp event}) {
    // Add event inside the stream
    popUpController.add(event);
  }

  /* Create closePopUpMixin method to close the popUpController*/
  void closePopUpMixin() async {
    //  Stop the stream listeneing using close function
    await popUpController.close();
  }
}
