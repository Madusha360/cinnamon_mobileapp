import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/l10n/l10n.dart';

class MainNavigationShell extends StatelessWidget {
  const MainNavigationShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    final items = [
      (text.home, Icons.grid_view_outlined, Icons.grid_view_rounded),
      (
        text.capture,
        Icons.center_focus_strong_outlined,
        Icons.center_focus_strong_rounded,
      ),
      (text.history, Icons.history_outlined, Icons.history_rounded),
      (text.sync, Icons.cloud_sync_outlined, Icons.cloud_sync_rounded),
      (text.study, Icons.auto_stories_outlined, Icons.auto_stories_rounded),
    ];
    void select(int index) => navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
    final wide = MediaQuery.sizeOf(context).width >= 720;
    return Scaffold(
      body: wide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: select,
                  labelType: NavigationRailLabelType.all,
                  groupAlignment: -0.6,
                  destinations: [
                    for (final item in items)
                      NavigationRailDestination(
                        icon: Icon(item.$2),
                        selectedIcon: Icon(item.$3),
                        label: Text(item.$1),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: navigationShell),
              ],
            )
          : navigationShell,
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: select,
              destinations: [
                for (final item in items)
                  NavigationDestination(
                    icon: Icon(item.$2),
                    selectedIcon: Icon(item.$3),
                    label: item.$1,
                  ),
              ],
            ),
    );
  }
}
