import 'package:flutter/material.dart';

class CustomPageWidget extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floating;
  final Widget? bottomBar;
  final bool hasPadding;
  final bool hasBackgroundImage;

  const CustomPageWidget({
    super.key, 
    this.appBar,
    this.body,
    this.floating,
    this.bottomBar,
    this.hasPadding = true,
    this.hasBackgroundImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: hasPadding ? const EdgeInsets.all(20) : EdgeInsets.zero,
        child: Stack(
          children: [
            if (hasBackgroundImage) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    'assets/img/background.png',
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                ),
              ),
            ],
            body ?? Container(),
          ],
        ),
      ),
      bottomNavigationBar: bottomBar,
      floatingActionButton: floating,
    );
  }
}
