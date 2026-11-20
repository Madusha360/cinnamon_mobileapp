import 'package:flutter/material.dart';

import '../../../../app/l10n/l10n.dart';

class GradeSizeBadge extends StatelessWidget {
  const GradeSizeBadge({super.key, required this.diameter, this.large = false});
  final String diameter;
  final bool large;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(large ? 20 : 12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(large ? 20 : 14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$diameter mm',
          style:
              (large
                      ? Theme.of(context).textTheme.headlineLarge
                      : Theme.of(context).textTheme.titleLarge)
                  ?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
        ),
        const SizedBox(height: 4),
        Text(
          context.l10n.referenceDiameter,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      ],
    ),
  );
}
