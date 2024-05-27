import 'package:flutter/material.dart';

class CustomBottomSheetWidget {
  CustomBottomSheetWidget.show({
    required BuildContext context,
    required Widget body,
    double? height,
    bool scroll = false,
    bool keyboard = false,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.background,
      isScrollControlled: scroll,
      builder: (BuildContext context) {
        return Padding(
          padding: keyboard
            ? EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              )
            : const EdgeInsets.all(0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: height ?? MediaQuery.of(context).size.height * 0.4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: body,
            ),
          ),
        );
      },
    );
  }
}
