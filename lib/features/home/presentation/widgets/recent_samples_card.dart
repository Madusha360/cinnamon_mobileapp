import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../samples/domain/sample.dart';
import '../../../samples/presentation/providers/sample_providers.dart';
import '../../../samples/presentation/widgets/sample_card.dart';

class RecentSamplesCard extends ConsumerWidget {
  const RecentSamplesCard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const query = SampleQuery(limit: 5);
    final text = context.l10n;
    return ref
        .watch(sampleListProvider(query))
        .when(
          loading: () => LoadingView(label: text.localDataLoading),
          error: (_, _) => ErrorView(
            title: text.localDataError,
            message: text.localDataErrorBody,
            retryLabel: text.retry,
            onRetry: () => ref.invalidate(sampleListProvider(query)),
          ),
          data: (samples) => samples.isEmpty
              ? EmptyState(
                  title: text.historyUnavailable,
                  message: text.historyUnavailableBody,
                  icon: Icons.document_scanner_outlined,
                  action: OutlinedButton(
                    onPressed: () => context.go(RouteNames.capture),
                    child: Text(text.exploreCapture),
                  ),
                )
              : Column(
                  children: [for (final sample in samples) SampleCard(sample)],
                ),
        );
  }
}
