import 'package:flutter/material.dart';

import '../../../../app/l10n/l10n.dart';
import '../../domain/cinnamon_grade.dart';

class ReferenceImageCard extends StatelessWidget {
  const ReferenceImageCard({
    super.key,
    required this.grade,
    this.compact = false,
  });
  final CinnamonGrade grade;
  final bool compact;
  @override
  Widget build(BuildContext context) {
    Widget unavailable() => Container(
      padding: EdgeInsets.all(compact ? 14 : 28),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: compact ? 24 : 40,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.photoUnavailable,
            textAlign: TextAlign.center,
            style: compact
                ? Theme.of(context).textTheme.labelSmall
                : Theme.of(context).textTheme.titleSmall,
          ),
          if (!compact) ...[
            const SizedBox(height: 8),
            Text(
              context.l10n.photoUnavailableBody,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
    if (grade.imageAsset == null) return unavailable();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            grade.imageAsset!,
            fit: BoxFit.contain,
            semanticLabel: '${grade.name} ${context.l10n.referencePhoto}',
            errorBuilder: (_, _, _) => unavailable(),
          ),
        ),
        if (grade.imageAttribution != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${context.l10n.referenceImageCredit}: ${grade.imageAttribution}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}
