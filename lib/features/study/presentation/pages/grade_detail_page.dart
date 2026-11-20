import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/status_card.dart';
import '../providers/study_provider.dart';
import '../widgets/grade_size_badge.dart';
import '../widgets/reference_image_card.dart';

class GradeDetailPage extends ConsumerWidget {
  const GradeDetailPage({super.key, required this.gradeId});
  final String gradeId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = context.l10n;
    final catalogue = ref.watch(gradeCatalogueProvider);
    return catalogue.when(
      loading: () => AppPage(
        title: text.gradeDetails,
        subtitle: text.studySubtitle,
        children: [LoadingView(label: text.openingWorkspace)],
      ),
      error: (_, _) => AppPage(
        title: text.gradeDetails,
        subtitle: text.studySubtitle,
        children: [
          ErrorView(
            title: text.gradeLoadError,
            message: text.gradeLoadErrorBody,
            retryLabel: text.retry,
            onRetry: () => ref.invalidate(gradeCatalogueProvider),
          ),
        ],
      ),
      data: (data) {
        final grade = data.byId(gradeId);
        if (grade == null) {
          return AppPage(
            title: text.gradeDetails,
            subtitle: text.studySubtitle,
            children: [
              EmptyState(
                title: text.gradeNotFound,
                message: text.gradeNotFoundBody,
                action: OutlinedButton(
                  onPressed: () => context.go(RouteNames.study),
                  child: Text(text.backToGuide),
                ),
              ),
            ],
          );
        }
        final group = data.groupInfo(grade.group);
        final sameGroup = data.grades
            .where((item) => item.group == grade.group && item.id != grade.id)
            .toList();
        final related = sameGroup.isEmpty
            ? data.grades.where((item) => item.id != grade.id).take(3)
            : sameGroup;
        return AppPage(
          title: grade.name,
          subtitle: '${grade.group.label} · ${text.referenceOnly}',
          leading: BackButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(RouteNames.study);
              }
            },
          ),
          children: [
            Text(grade.name, style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 10),
            Text(grade.description),
            const SizedBox(height: 20),
            GradeSizeBadge(diameter: grade.diameterLabel, large: true),
            SectionHeading(text.referencePhoto),
            ReferenceImageCard(grade: grade),
            SectionHeading(text.groupDescription),
            Text(group.description),
            const SizedBox(height: 10),
            Text('${text.cinnamonType}: ${group.typeName}'),
            SectionHeading(text.gradeAppearance),
            Text(grade.appearance ?? text.appearanceUnavailable),
            SectionHeading(text.finishingCharacteristics),
            Text(grade.finishingCharacteristics ?? text.finishingUnavailable),
            SectionHeading(text.gradingCriteria),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(text.quillsPerKg),
                    subtitle: Text('${grade.quillsPerKg}'),
                  ),
                  const Divider(indent: 20, endIndent: 20),
                  ListTile(
                    title: Text(text.foxing),
                    subtitle: Text('${grade.foxingLabel}%'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              text.referenceCriteriaNote,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            StatusCard(
              title: text.referenceOnly,
              message: text.guideReferenceNote,
              icon: Icons.info_outline_rounded,
            ),
            SectionHeading(text.sourceInformation),
            Text(
              grade.source.title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 10),
            SelectableText(
              grade.source.url,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 8),
            Text(
              text.sourceLinkHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              text.sourceCheckedDate(grade.source.checkedAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SectionHeading(text.relatedGrades),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final relatedGrade in related)
                  ActionChip(
                    label: Text(relatedGrade.name),
                    onPressed: () => context.pushReplacement(
                      RouteNames.gradeDetail(relatedGrade.id),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => context.push(
                '${RouteNames.gradeComparison}?first=${Uri.encodeQueryComponent(grade.id)}',
              ),
              icon: const Icon(Icons.compare_arrows_rounded),
              label: Text(text.compareGrades),
            ),
          ],
        );
      },
    );
  }
}
