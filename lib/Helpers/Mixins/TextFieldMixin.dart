// ignore_for_file: file_names

import 'dart:async';

/* Create an ITextFormField abstract class */
abstract class ITextFormField {}

// Create AddUserDetails class to add the text in input Text field
class AddText extends ITextFormField {
  String data;
  AddText({required this.data});
}

mixin TextFieldMixin {
  // Initailize a streamController to listen the emitted events
  StreamController<ITextFormField?> nameFieldController =
      StreamController<ITextFormField?>();

   /* Create setTextFieldValue method and add the event into the StreamController variable "textFieldController" */
  void setNameFieldValue({required ITextFormField event}) {
    // Add event inside the stream
    nameFieldController.add(event);
  }


  // Initailize a streamController to listen the emitted events
  StreamController<ITextFormField?> ageFieldController =
      StreamController<ITextFormField?>();

   /* Create setTextFieldValue method and add the event into the StreamController variable "textFieldController" */
  void setAgeFieldValue({required ITextFormField event}) {
    // Add event inside the stream
    ageFieldController.add(event);
  }

  /* Create closeTextMixin method to close the StreamController*/
  void closeTextMixin() async {

    //  Stop the name field stream's listeneing using close function
    await nameFieldController.close();

    //  Stop the age field stream's listeneing using close function
    await ageFieldController.close();
  }

}

