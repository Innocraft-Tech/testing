// ignore_for_file: file_names

import 'dart:async';

/* Create an IToastMessage abstract class */
abstract class IToastMessage {
}

// Create AddToast class to Add the toast message
class AddToast extends IToastMessage {
  String toastMessage;
  AddToast({required this.toastMessage});
}

mixin ToastMixin {
  // Initailize a streamController to listen the emitted events
  StreamController<IToastMessage?> toastMessageController =
      StreamController<IToastMessage?>();

  /* Create setToastEvent method and add the event into the StreamController variable "toastMessageController" */
  void setToastEvent({required IToastMessage event}) {
    // Add event inside the stream
    toastMessageController.add(event);
  }

  /* Create closeToastMixin method to close the toastMessageController*/
  void closeToastMixin() async {
    
    //  Stop the stream listeneing using close function
    await toastMessageController.close();
  }
}

