import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/status_card.dart';
import '../../../../shared/widgets/quill_illustration.dart';

class StudyPage extends StatelessWidget {
  const StudyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    return AppPage(
      title: text.study,
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
                text.fieldGuide,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFFE9C59D),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                text.studyTitle,
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(color: Colors.white),
              ),
              const QuillIllustration(endView: true, height: 180),
              Text(
                text.studyIntro,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        for (final item in [
          (text.guideEndTitle, text.guideEndBody),
          (text.guideSideTitle, text.guideSideBody),
          (text.guideMeasureTitle, text.guideMeasureBody),
          (text.guideReviewTitle, text.guideReviewBody),
        ]) ...[
          Card(
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              key: PageStorageKey(item.$1),
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              title: Text(
                item.$1,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              children: [Text(item.$2)],
            ),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 8),
        StatusCard(
          title: text.readGuide,
          message: text.studyNote,
          icon: Icons.menu_book_outlined,
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => context.push(RouteNames.calibration),
          icon: const Icon(Icons.straighten_rounded),
          label: Text(text.openCalibration),
        ),
      ],
    );
  }
}
