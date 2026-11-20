import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/status_card.dart';
import '../../../../core/widgets/status_indicator.dart';
import '../providers/study_provider.dart';
import '../widgets/cinnamon_grade_card.dart';
import '../widgets/grade_category_filter.dart';

class StudyPage extends ConsumerStatefulWidget {
  const StudyPage({super.key});
  @override
  ConsumerState<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends ConsumerState<StudyPage> {
  late final TextEditingController _search;
  @override
  void initState() {
    super.initState();
    _search = TextEditingController(text: ref.read(studyFilterProvider).query);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _clear() {
    _search.clear();
    ref.read(studyFilterProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    final catalogue = ref.watch(gradeCatalogueProvider);
    final filter = ref.watch(studyFilterProvider);
    final filtered = ref.watch(filteredGradesProvider);
    return AppPage(
      title: text.studyTitle,
      subtitle: text.studySubtitle,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.forest,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text.studyEyebrow,
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(color: AppColors.darkOrange, letterSpacing: 1.4),
              ),
              const SizedBox(height: 16),
              Text(
                text.studyIntro,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                catalogue.asData == null
                    ? text.referenceOnly
                    : text.catalogueCount(
                        catalogue.requireValue.grades.length,
                        catalogue.requireValue.groups.length,
                      ),
                style: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: const Color(0xFFDAE8D7)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: StatusIndicator(
            label: text.offlineGuide,
            icon: Icons.offline_pin_outlined,
            tone: StatusTone.positive,
          ),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => context.push(RouteNames.gradeComparison),
          icon: const Icon(Icons.compare_arrows_rounded),
          label: Text(text.compareGrades),
        ),
        SectionHeading(text.browseGrades),
        TextField(
          key: const ValueKey('grade-search'),
          controller: _search,
          onChanged: ref.read(studyFilterProvider.notifier).setQuery,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            labelText: text.gradeSearch,
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: filter.query.isEmpty
                ? null
                : IconButton(
                    tooltip: text.clearSearch,
                    onPressed: () {
                      _search.clear();
                      ref.read(studyFilterProvider.notifier).setQuery('');
                    },
                    icon: const Icon(Icons.close_rounded),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        GradeCategoryFilter(
          selected: filter.group,
          onChanged: ref.read(studyFilterProvider.notifier).setGroup,
        ),
        const SizedBox(height: 20),
        if (filter.group != null && catalogue.asData != null) ...[
          Text(
            catalogue.requireValue.groupInfo(filter.group!).description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
        ],
        filtered.when(
          loading: () => LoadingView(label: text.openingWorkspace),
          error: (_, _) => ErrorView(
            title: text.gradeLoadError,
            message: text.gradeLoadErrorBody,
            retryLabel: text.retry,
            onRetry: () => ref.invalidate(gradeCatalogueProvider),
          ),
          data: (grades) => grades.isEmpty
              ? EmptyState(
                  title: text.noGradesFound,
                  message: text.noGradesFoundBody,
                  icon: Icons.search_off_rounded,
                  action: OutlinedButton(
                    onPressed: _clear,
                    child: Text(text.clearFilters),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final columns =
                        constraints.maxWidth >= 600 &&
                            MediaQuery.textScalerOf(context).scale(1) < 1.5
                        ? 2
                        : 1;
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        for (final grade in grades)
                          SizedBox(
                            width:
                                (constraints.maxWidth - (columns - 1) * 16) /
                                columns,
                            child: CinnamonGradeCard(grade: grade),
                          ),
                      ],
                    );
                  },
                ),
        ),
        SectionHeading(text.groupOverview),
        if (catalogue.asData != null)
          for (final group in catalogue.requireValue.groups)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ExpansionTile(
                  key: PageStorageKey('guide-group-${group.group.name}'),
                  title: Text(group.group.label),
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 6,
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(group.description),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${text.cinnamonType}: ${group.typeName}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        const SizedBox(height: 8),
        StatusCard(
          title: text.referenceOnly,
          message: text.guideReferenceNote,
          icon: Icons.info_outline_rounded,
        ),
        if (catalogue.asData != null) ...[
          SectionHeading(text.sourceInformation),
          Text(
            catalogue.requireValue.source.title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            text.sourceCheckedDate(catalogue.requireValue.source.checkedAt),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
