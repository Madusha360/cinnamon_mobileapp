import 'package:flutter/material.dart';

import '../../../../app/l10n/l10n.dart';
import '../../domain/cinnamon_grade.dart';
import 'grade_size_badge.dart';

class GradeComparisonCard extends StatelessWidget {
  const GradeComparisonCard({super.key, required this.grade});
  final CinnamonGrade grade;
  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    Widget field(String label, String value) => Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 5),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(grade.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: GradeSizeBadge(diameter: grade.diameterLabel, large: true),
            ),
            field(text.gradeGroup, grade.group.label),
            field(
              text.finishingCharacteristics,
              grade.finishingCharacteristics ?? text.finishingUnavailable,
            ),
            field(text.quillsPerKg, '${grade.quillsPerKg}'),
            field(text.foxing, '${grade.foxingLabel}%'),
          ],
        ),
      ),
    );
  }
}
