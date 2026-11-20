import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({
    super.key,
    required this.label,
    required this.icon,
    required this.unavailableLabel,
    this.value,
  });
  final String label;
  final IconData icon;
  final String unavailableLabel;
  final int? value;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Spacer(),
              Semantics(
                label: '$label. ${value ?? unavailableLabel}',
                child: ExcludeSemantics(
                  child: Text(
                    value?.toString() ?? '—',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(label, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    ),
  );
}
