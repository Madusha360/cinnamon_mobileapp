import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../samples/domain/sample.dart';
import '../../../samples/presentation/providers/sample_providers.dart';
import '../../../samples/presentation/widgets/sample_card.dart';

class SampleDetailPage extends ConsumerStatefulWidget {
  const SampleDetailPage({super.key, required this.sampleId});
  final String sampleId;
  @override
  ConsumerState<SampleDetailPage> createState() => _SampleDetailPageState();
}

class _SampleDetailPageState extends ConsumerState<SampleDetailPage> {
  bool _deleting = false;
  Future<void> _delete() async {
    final text = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: Text(text.deleteSampleTitle),
        content: Text(text.deleteSampleBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(text.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(text.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _deleting = true);
    try {
      await ref.read(sampleRepositoryProvider).deleteSample(widget.sampleId);
      if (mounted) context.go(RouteNames.history);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(text.sampleDeleteError)));
      }
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    final sample = ref.watch(sampleDetailProvider(widget.sampleId));
    return AppPage(
      title: text.sampleDetails,
      subtitle: text.historySubtitle,
      leading: BackButton(
        onPressed: () =>
            context.canPop() ? context.pop() : context.go(RouteNames.history),
      ),
      children: [
        sample.when(
          loading: () => LoadingView(label: text.localDataLoading),
          error: (_, _) => ErrorView(
            title: text.localDataError,
            message: text.localDataErrorBody,
            retryLabel: text.retry,
            onRetry: () =>
                ref.invalidate(sampleDetailProvider(widget.sampleId)),
          ),
          data: (record) => record == null
              ? EmptyState(
                  title: text.sampleNotFound,
                  message: text.sampleNotFoundBody,
                  icon: Icons.inventory_2_outlined,
                )
              : _details(record),
        ),
      ],
    );
  }

  Widget _details(SampleRecord sample) {
    final text = context.l10n;
    String mm(double? value) =>
        value == null ? text.notMeasured : '${value.toStringAsFixed(2)} mm';
    Widget field(String label, String value) =>
        ListTile(title: Text(label), subtitle: SelectableText(value));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(sample.code, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: SampleSyncIndicator(sample.syncStatus),
        ),
        SectionHeading(text.sampleDetails),
        Card(
          child: Column(
            children: [
              field(text.sampleId, sample.id),
              field(text.batchId, sample.batchId ?? '—'),
              field(
                text.captureDate,
                DateFormat.yMMMd().add_jm().format(sample.capturedAt.toLocal()),
              ),
              field(text.sampleNotes, sample.notes ?? '—'),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: _deleting
              ? null
              : () => showDialog<void>(
                  context: context,
                  builder: (_) => _EditSampleDialog(sample: sample),
                ),
          icon: const Icon(Icons.edit_outlined),
          label: Text(text.editSample),
        ),
        SectionHeading(text.endView),
        SamplePhoto(
          path: sample.endImagePath,
          label: text.endView,
          height: 220,
        ),
        SectionHeading(text.sideView),
        SamplePhoto(
          path: sample.sideImagePath,
          label: text.sideView,
          height: 220,
        ),
        SectionHeading(text.measurementReview),
        Card(
          child: Column(
            children: [
              field(text.maximumWidth, mm(sample.maximumWidthMm)),
              field(text.minimumWidth, mm(sample.minimumWidthMm)),
              field(text.equivalentDiameter, mm(sample.equivalentDiameterMm)),
              field(text.circumference, mm(sample.outerCircumferenceMm)),
            ],
          ),
        ),
        SectionHeading(text.finishingAnalysis),
        Card(
          child: field(
            text.finishingAnalysis,
            sample.finishingQuality == null
                ? text.notAnalyzed
                : '${sample.finishingQuality}${sample.finishingConfidence == null ? '' : ' (${(sample.finishingConfidence! * 100).toStringAsFixed(1)}%)'}',
          ),
        ),
        Card(
          child: Column(
            children: [
              field(text.detectionStatus, switch (sample.detectionStatus) {
                'validated' => text.validated,
                'rejected' => text.rejected,
                _ => text.notValidated,
              }),
              field(text.calibrationStatus, switch (sample.calibrationStatus) {
                'calibrated' => text.calibrated,
                'invalid' => text.invalidCalibration,
                _ => text.notCalibrated,
              }),
              field(
                text.syncStatus,
                syncStatusLabel(context, sample.syncStatus),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: _deleting ? null : _delete,
          icon: const Icon(Icons.delete_outline),
          label: Text(text.deleteSample),
        ),
      ],
    );
  }
}

class _EditSampleDialog extends ConsumerStatefulWidget {
  const _EditSampleDialog({required this.sample});
  final SampleRecord sample;
  @override
  ConsumerState<_EditSampleDialog> createState() => _EditSampleDialogState();
}

class _EditSampleDialogState extends ConsumerState<_EditSampleDialog> {
  late final _code = TextEditingController(text: widget.sample.code);
  late final _batch = TextEditingController(text: widget.sample.batchId);
  late final _notes = TextEditingController(text: widget.sample.notes);
  bool _saving = false;
  bool _failed = false;
  @override
  void dispose() {
    _code.dispose();
    _batch.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _failed = false;
    });
    try {
      await ref
          .read(sampleRepositoryProvider)
          .updateSample(
            widget.sample.id,
            code: _code.text,
            batchId: _batch.text,
            notes: _notes.text,
          );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    return AlertDialog(
      scrollable: true,
      title: Text(text.editSample),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _code,
              enabled: !_saving,
              decoration: InputDecoration(labelText: text.sampleCode),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _batch,
              enabled: !_saving,
              decoration: InputDecoration(labelText: text.batchId),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notes,
              enabled: !_saving,
              maxLines: 3,
              decoration: InputDecoration(labelText: text.sampleNotes),
            ),
            if (_failed)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  text.sampleSaveError,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: Text(text.cancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(text.saveChanges),
        ),
      ],
    );
  }
}
