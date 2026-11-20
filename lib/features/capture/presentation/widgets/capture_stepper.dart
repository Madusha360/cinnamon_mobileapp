import 'package:flutter/material.dart';

import '../../../../app/l10n/l10n.dart';

class CaptureStepper extends StatelessWidget {
  const CaptureStepper({super.key});

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final item in [
        (1, context.l10n.endView),
        (2, context.l10n.sideView),
        (3, context.l10n.review),
      ])
        Chip(
          avatar: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              '${item.$1}',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          label: Text(item.$2),
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
    ],
  );
}
