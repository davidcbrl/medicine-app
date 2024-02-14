import 'package:flutter/material.dart';

class CustomBottomSheetWidget {
  CustomBottomSheetWidget.show({
    required BuildContext context,
    required Widget body,
    double? height,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.background,
      builder: (BuildContext context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: height ?? MediaQuery.of(context).size.height * 0.4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: body,
          ),
        );
      },
    );
  }
}
