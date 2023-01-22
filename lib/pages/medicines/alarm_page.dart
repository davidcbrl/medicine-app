
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:medicine/widgets/custom_page_widget.dart';

class AlarmPage extends StatelessWidget {
  const AlarmPage({Key? key, required this.receivedAction}): super(key: key);

  final ReceivedAction receivedAction;

  @override
  Widget build(BuildContext context) {
    bool hasLargeIcon = receivedAction.largeIconImage != null;
    bool hasBigPicture = receivedAction.bigPictureImage != null;
    double bigPictureSize = MediaQuery.of(context).size.height * .4;
    double largeIconSize = MediaQuery.of(context).size.height * (hasBigPicture ? .12 : .2);

    return CustomPageWidget(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.asset(
                      'assets/img/ben.png',
                      width: 50,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Tio Ben',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Falar com minha família',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    '10:00',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              if (receivedAction.title?.isNotEmpty ?? false) ...[
                                TextSpan(
                                  text: receivedAction.title!,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                              if ((receivedAction.title?.isNotEmpty ?? false) && (receivedAction.body?.isNotEmpty ?? false)) ...[
                                TextSpan(
                                  text: '\n\n',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                              if (receivedAction.body?.isNotEmpty ?? false) ...[
                                TextSpan(
                                  text: receivedAction.body!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: hasBigPicture ? bigPictureSize + 40 : largeIconSize + 60,
                    child: hasBigPicture
                    ? Stack(
                        children: [
                          if (hasBigPicture) ...[
                            FadeInImage(
                              placeholder: const NetworkImage(
                                'https://cdn.syncfusion.com/content/images/common/placeholder.gif',
                              ),
                              //AssetImage('assets/images/placeholder.gif'),
                              height: bigPictureSize,
                              width: MediaQuery.of(context).size.width,
                              image: receivedAction.bigPictureImage!,
                              fit: BoxFit.cover,
                            ),
                          ],
                          if (hasLargeIcon) ...[
                            Positioned(
                              bottom: 15,
                              left: 20,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(largeIconSize)
                                ),
                                child: FadeInImage(
                                  placeholder: const NetworkImage(
                                    'https://cdn.syncfusion.com/content/images/common/placeholder.gif',
                                  ),
                                  //AssetImage('assets/images/placeholder.gif'),
                                  height: largeIconSize,
                                  width: largeIconSize,
                                  image: receivedAction.largeIconImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ],
                      )
                    : Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(largeIconSize),
                          ),
                          child: FadeInImage(
                            placeholder: const NetworkImage(
                              'https://cdn.syncfusion.com/content/images/common/placeholder.gif',
                            ),
                            //AssetImage('assets/images/placeholder.gif'),
                            height: largeIconSize,
                            width: largeIconSize,
                            image: receivedAction.largeIconImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    child: Text(receivedAction.toString()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
