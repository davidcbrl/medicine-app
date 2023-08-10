import 'package:flutter/material.dart';

class CustomLoadingWidget extends StatelessWidget {
  final bool loading;
  final String? text;

  const CustomLoadingWidget({
    super.key, 
    required this.loading,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return (!loading)
    ? Container()
    : Container(
        alignment: Alignment.center,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              child: const SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(),
              ),
            ),
            if (text != null)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  text ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      );
  }
}
