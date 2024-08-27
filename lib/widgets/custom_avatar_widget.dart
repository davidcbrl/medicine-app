import 'package:flutter/material.dart';

class CustomAvatarWidget extends StatelessWidget {
  final String image;
  final String? label;
  final Color? borderColor;

  const CustomAvatarWidget({
    super.key,
    required this.image,
    this.label,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: borderColor ?? Theme.of(context).colorScheme.tertiary,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: image.contains('http')
                    ? Image.network(image)
                    : Image.asset('assets/img/ben.png'),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.mode_edit_outline_outlined,
                  size: 15,
                ),
              ),
            ),
          ],
        ),
        if (label != null) ...[
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greetings(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Text(
                  label!,
                  style: Theme.of(context).textTheme.labelMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  String _greetings() {
    DateTime now = DateTime.now();
    if (now.isAfter(now.copyWith(hour: 05)) && now.isBefore(now.copyWith(hour: 12))) {
      return 'Bom dia';
    }
    if (now.isAfter(now.copyWith(hour: 12)) && now.isBefore(now.copyWith(hour: 19))) {
      return 'Boa tarde';
    }
    if (now.isAfter(now.copyWith(hour: 19)) || now.isBefore(now.copyWith(hour: 05))) {
      return 'Boa noite';
    }
    return 'Olá';
  }
}
