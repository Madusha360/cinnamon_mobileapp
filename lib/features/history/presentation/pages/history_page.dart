import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/status_indicator.dart';
import '../../../samples/domain/sample.dart';
import '../../../samples/presentation/providers/sample_providers.dart';
import '../../../samples/presentation/widgets/sample_card.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});
  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  final _search = TextEditingController();
  SyncStatus? _status;
  SampleSort _sort = SampleSort.newest;
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    final query = SampleQuery(
      search: _search.text,
      status: _status,
      sort: _sort,
    );
    final samples = ref.watch(sampleListProvider(query));
    return AppPage(
      title: text.history,
      subtitle: text.historySubtitle,
      actions: [
        IconButton(
          tooltip: text.reports,
          onPressed: () => context.push(RouteNames.reports),
          icon: const Icon(Icons.ios_share_outlined),
        ),
      ],
      children: [
        TextField(
          controller: _search,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: text.searchSamples,
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: _search.text.isEmpty
                ? null
                : IconButton(
                    tooltip: text.clearSearch,
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(_search.clear),
                  ),
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: Text(text.all),
              selected: _status == null,
              onSelected: (_) => setState(() => _status = null),
            ),
            for (final status in SyncStatus.values)
              ChoiceChip(
                label: Text(syncStatusLabel(context, status)),
                selected: _status == status,
                onSelected: (_) => setState(() => _status = status),
              ),
          ],
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<SampleSort>(
          initialValue: _sort,
          isExpanded: true,
          decoration: InputDecoration(labelText: text.sortSamples),
          items: [
            for (final sort in SampleSort.values)
              DropdownMenuItem(
                value: sort,
                child: Text(switch (sort) {
                  SampleSort.newest => text.newestFirst,
                  SampleSort.oldest => text.oldestFirst,
                  SampleSort.code => text.sampleCodeOrder,
                }),
              ),
          ],
          onChanged: (value) {
            if (value != null) setState(() => _sort = value);
          },
        ),
        const SizedBox(height: 16),
        if (samples.hasValue)
          Align(
            alignment: Alignment.centerLeft,
            child: StatusIndicator(
              label: text.localStorageReady,
              icon: Icons.storage_outlined,
            ),
          ),
        SectionHeading(text.recentActivity),
        samples.when(
          loading: () => LoadingView(label: text.localDataLoading),
          error: (_, _) => ErrorView(
            title: text.localDataError,
            message: text.localDataErrorBody,
            retryLabel: text.retry,
            onRetry: () => ref.invalidate(sampleListProvider(query)),
          ),
          data: (records) {
            if (records.isNotEmpty) {
              return Column(
                children: [for (final sample in records) SampleCard(sample)],
              );
            }
            final filtered = _search.text.isNotEmpty || _status != null;
            return EmptyState(
              title: filtered ? text.noSamplesFound : text.historyUnavailable,
              message: filtered
                  ? text.noSamplesFoundBody
                  : text.historyUnavailableBody,
              icon: Icons.inventory_2_outlined,
              action: OutlinedButton.icon(
                onPressed: () {
                  if (filtered) {
                    setState(() {
                      _search.clear();
                      _status = null;
                    });
                  } else {
                    context.go(RouteNames.capture);
                  }
                },
                icon: Icon(
                  filtered
                      ? Icons.filter_alt_off_outlined
                      : Icons.add_a_photo_outlined,
                ),
                label: Text(filtered ? text.clearFilters : text.exploreCapture),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          text.historyStorageBody,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
