import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../domain/cinnamon_grade.dart';
import 'grade_size_badge.dart';
import 'reference_image_card.dart';

class CinnamonGradeCard extends StatelessWidget {
  const CinnamonGradeCard({super.key, required this.grade});
  final CinnamonGrade grade;
  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      key: ValueKey('grade-card-${grade.id}'),
      onTap: () => context.push(RouteNames.gradeDetail(grade.id)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              grade.group.label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 1.2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(grade.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: GradeSizeBadge(diameter: grade.diameterLabel),
            ),
            const SizedBox(height: 14),
            ReferenceImageCard(grade: grade, compact: true),
            const SizedBox(height: 14),
            Text(
              grade.description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.gradeDetails,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_rounded, size: 18),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
