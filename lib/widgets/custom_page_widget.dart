import 'package:flutter/material.dart';

class CustomPageWidget extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? bottomBar;
  final bool hasPadding;

  const CustomPageWidget({
    super.key, 
    this.appBar,
    this.body,
    this.bottomBar,
    this.hasPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: hasPadding ? const EdgeInsets.all(20) : EdgeInsets.zero,
        child: body,
      ),
      bottomNavigationBar: bottomBar,
    );
  }
}
