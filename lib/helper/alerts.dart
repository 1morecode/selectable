//*************   © Copyrighted by 1 More Code. *********************

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:selectable/helper/global_data.dart';

customCupertinoAlert({
  required Widget title,
  required String content,
  String cancelButtonText = "Cancel",
  String confirmButtonText = "OK",
  Color confirmTextColor = Colors.red,
  Function? onPressed,
}) {
  showCupertinoDialog(
    context: globalContext(),
    builder: (context) => CupertinoAlertDialog(
      title: title,
      content: Text(content),
      actions: [
        if (onPressed != null)
          CupertinoDialogAction(
            child: Text(
              confirmButtonText,
              style: TextStyle(color: confirmTextColor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onPressed();
            },
          ),
        CupertinoDialogAction(
          child: Text(cancelButtonText),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    ),
  );
}

updatedAlert({String text = 'Updated!'}) {
  EasyLoading.showSuccess(text, dismissOnTap: true);
}

successAlert({String text = 'Success!'}) {
  EasyLoading.showSuccess(text, dismissOnTap: true);
}

errorAlert({String text = 'Error!'}) {
  EasyLoading.showError(text, dismissOnTap: true);
}

failedAlert({String text = 'Failed!'}) {
  EasyLoading.showError(text, dismissOnTap: true);
}

toastAlert({required String text}) {
  EasyLoading.showToast(text, dismissOnTap: true);
}

infoAlert({required String text}) {
  EasyLoading.showInfo(text, dismissOnTap: true);
}
