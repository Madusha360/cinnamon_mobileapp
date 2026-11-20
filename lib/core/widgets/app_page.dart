import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';

class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.actions,
    this.leading,
    this.titleWidget,
    this.heading,
  });
  final String title;
  final String subtitle;
  final List<Widget> children;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? titleWidget;
  final String? heading;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: leading,
      title:
          titleWidget ??
          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: actions,
    ),
    body: SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppTokens.contentWidth),
          child: ListView(
            key: PageStorageKey(title),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(
              AppTokens.pagePadding,
              8,
              AppTokens.pagePadding,
              32,
            ),
            children: [
              if (heading != null) ...[
                Text(
                  heading!,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
              ],
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              ...children,
            ],
          ),
        ),
      ),
    ),
  );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {super.key, this.action});
  final String title;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 28, bottom: 14),
    child: Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        ?action,
      ],
    ),
  );
}
