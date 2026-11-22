import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/empty_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/calibration/presentation/pages/calibration_page.dart';
import '../../features/capture/presentation/pages/capture_page.dart';
import '../../features/capture/presentation/pages/end_capture_page.dart';
import '../../features/capture/presentation/pages/side_capture_page.dart';
import '../../features/capture/presentation/pages/image_review_page.dart';
import '../../features/capture/domain/capture_session.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/history/presentation/pages/sample_detail_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/results/presentation/pages/results_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/study/presentation/pages/study_page.dart';
import '../../features/study/presentation/pages/grade_detail_page.dart';
import '../../features/study/presentation/pages/grade_comparison_page.dart';
import '../../features/sync/presentation/pages/sync_page.dart';
import '../../shared/widgets/main_navigation_shell.dart';
import '../l10n/l10n.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = createAppRouter();
  ref.onDispose(router.dispose);
  return router;
});

GoRouter createAppRouter({
  String initialLocation = RouteNames.splash,
}) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    GoRoute(path: RouteNames.splash, builder: (_, _) => const SplashPage()),
    GoRoute(
      path: RouteNames.onboarding,
      builder: (_, _) => const OnboardingPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (_, _, shell) => MainNavigationShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: RouteNames.home, builder: (_, _) => const HomePage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.capture,
              builder: (_, _) => const CapturePage(),
              routes: [
                GoRoute(path: 'end', builder: (_, _) => const EndCapturePage()),
                GoRoute(
                  path: 'side',
                  builder: (_, _) => const SideCapturePage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.history,
              builder: (_, _) => const HistoryPage(),
              routes: [
                GoRoute(
                  path: 'samples/:sampleId',
                  builder: (_, state) => SampleDetailPage(
                    sampleId: state.pathParameters['sampleId']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: RouteNames.sync, builder: (_, _) => const SyncPage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.study,
              builder: (_, _) => const StudyPage(),
              routes: [
                GoRoute(
                  path: 'compare',
                  builder: (_, state) => GradeComparisonPage(
                    initialGradeId: state.uri.queryParameters['first'],
                  ),
                ),
                GoRoute(
                  path: 'grades/:gradeId',
                  builder: (_, state) => GradeDetailPage(
                    gradeId: state.pathParameters['gradeId']!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(path: RouteNames.settings, builder: (_, _) => const SettingsPage()),
    GoRoute(path: RouteNames.profile, builder: (_, _) => const ProfilePage()),
    GoRoute(path: RouteNames.login, builder: (_, _) => const LoginPage()),
    GoRoute(path: RouteNames.register, builder: (_, _) => const RegisterPage()),
    GoRoute(
      path: RouteNames.calibration,
      builder: (_, _) => const CalibrationPage(),
    ),
    GoRoute(path: RouteNames.reports, builder: (_, _) => const ReportsPage()),
    GoRoute(path: RouteNames.results, builder: (_, _) => const ResultsPage()),
    for (final view in CaptureView.values)
      GoRoute(
        path: RouteNames.cameraSandbox(view.name),
        builder: (_, _) => view == CaptureView.end
            ? const EndCapturePage(sandbox: true)
            : const SideCapturePage(sandbox: true),
        routes: [
          GoRoute(
            path: 'review',
            builder: (_, _) => ImageReviewPage(view: view),
          ),
        ],
      ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: EmptyState(
              title: context.l10n.pageNotFound,
              message: context.l10n.pageNotFoundBody,
              icon: Icons.wrong_location_outlined,
              action: OutlinedButton(
                onPressed: () => context.go(RouteNames.home),
                child: Text(context.l10n.goHome),
              ),
            ),
          ),
        ),
      ),
    ),
  ),
);
