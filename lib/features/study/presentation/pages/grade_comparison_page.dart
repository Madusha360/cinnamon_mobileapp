import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/status_card.dart';
import '../../domain/cinnamon_grade.dart';
import '../providers/study_provider.dart';
import '../widgets/grade_comparison_card.dart';

class GradeComparisonPage extends ConsumerStatefulWidget {
  const GradeComparisonPage({super.key, this.initialGradeId});
  final String? initialGradeId;
  @override
  ConsumerState<GradeComparisonPage> createState() =>
      _GradeComparisonPageState();
}

class _GradeComparisonPageState extends ConsumerState<GradeComparisonPage> {
  String? _firstId;
  String? _secondId;
  @override
  void initState() {
    super.initState();
    _firstId = widget.initialGradeId;
    _secondId = widget.initialGradeId == 'c5-special' ? 'alba' : 'c5-special';
  }

  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    final catalogue = ref.watch(gradeCatalogueProvider);
    return AppPage(
      title: text.comparisonTitle,
      subtitle: text.comparisonSubtitle,
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
        catalogue.when(
          loading: () => LoadingView(label: text.openingWorkspace),
          error: (_, _) => ErrorView(
            title: text.gradeLoadError,
            message: text.gradeLoadErrorBody,
            retryLabel: text.retry,
            onRetry: () => ref.invalidate(gradeCatalogueProvider),
          ),
          data: (data) {
            final first = data.byId(_firstId ?? 'alba') ?? data.grades.first;
            final fallbackSecond = data.grades.firstWhere(
              (grade) => grade.id != first.id,
              orElse: () => first,
            );
            final second =
                data.byId(
                  _secondId ??
                      (first.id == 'c5-special' ? 'alba' : 'c5-special'),
                ) ??
                fallbackSecond;
            Widget selector(
              String label,
              String key,
              CinnamonGrade selected,
              ValueChanged<String?> onChanged,
            ) => DropdownButtonFormField<String>(
              key: ValueKey(key),
              initialValue: selected.id,
              isExpanded: true,
              isDense: false,
              itemHeight: null,
              menuMaxHeight: 360,
              decoration: InputDecoration(labelText: label),
              items: [
                for (final grade in data.grades)
                  DropdownMenuItem(
                    value: grade.id,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(grade.name),
                    ),
                  ),
              ],
              onChanged: onChanged,
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                selector(
                  text.firstGrade,
                  'first-grade-selector',
                  first,
                  (id) => setState(() => _firstId = id),
                ),
                const SizedBox(height: 16),
                selector(
                  text.secondGrade,
                  'second-grade-selector',
                  second,
                  (id) => setState(() => _secondId = id),
                ),
                const SizedBox(height: 24),
                if (first.id == second.id) ...[
                  Text(text.sameGradeNotice),
                  const SizedBox(height: 16),
                ],
                LayoutBuilder(
                  builder: (context, constraints) {
                    final sideBySide =
                        constraints.maxWidth >= 600 &&
                        MediaQuery.textScalerOf(context).scale(1) < 1.5;
                    return sideBySide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: GradeComparisonCard(grade: first),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: GradeComparisonCard(grade: second),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              GradeComparisonCard(grade: first),
                              const SizedBox(height: 16),
                              GradeComparisonCard(grade: second),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 20),
                StatusCard(
                  title: text.referenceOnly,
                  message: text.comparisonNote,
                ),
                const SizedBox(height: 16),
                Text(
                  text.referenceCriteriaNote,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SectionHeading(text.sourceInformation),
                Text(
                  data.source.title,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                SelectableText(
                  data.source.url,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
