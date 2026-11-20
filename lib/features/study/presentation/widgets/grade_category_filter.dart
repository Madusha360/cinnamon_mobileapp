import 'package:flutter/material.dart';

import '../../../../app/l10n/l10n.dart';
import '../../domain/cinnamon_grade.dart';

class GradeCategoryFilter extends StatelessWidget {
  const GradeCategoryFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });
  final GradeGroup? selected;
  final ValueChanged<GradeGroup?> onChanged;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      ChoiceChip(
        key: const ValueKey('group-all'),
        label: Text(context.l10n.all),
        selected: selected == null,
        onSelected: (_) => onChanged(null),
      ),
      for (final group in GradeGroup.values)
        ChoiceChip(
          key: ValueKey('group-${group.name}'),
          label: Text(group.label),
          selected: selected == group,
          onSelected: (_) => onChanged(group),
        ),
    ],
  );
}
