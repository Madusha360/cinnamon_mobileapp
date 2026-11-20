import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

enum StatusTone { neutral, positive, negative, uncertain }

class StatusIndicator extends StatelessWidget {
  const StatusIndicator({
    super.key,
    required this.label,
    this.tone = StatusTone.neutral,
    this.icon = Icons.circle_outlined,
  });
  final String label;
  final StatusTone tone;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (tone) {
      StatusTone.neutral => theme.colorScheme.onSurfaceVariant,
      StatusTone.positive => theme.colorScheme.primary,
      StatusTone.negative => theme.colorScheme.error,
      StatusTone.uncertain =>
        theme.brightness == Brightness.dark
            ? AppColors.darkWarning
            : AppColors.warning,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
