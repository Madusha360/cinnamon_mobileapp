abstract final class RouteNames {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const capture = '/capture';
  static const endCapture = '/capture/end';
  static const sideCapture = '/capture/side';
  static String cameraSandbox(String view) => '/camera/$view';
  static String imageReview(String view) => '/camera/$view/review';
  static const history = '/history';
  static String sampleDetail(String id) =>
      '/history/samples/${Uri.encodeComponent(id)}';
  static const sync = '/sync';
  static const study = '/study';
  static const settings = '/settings';
  static const profile = '/profile';
  static const login = '/login';
  static const register = '/register';
  static const calibration = '/calibration';
  static const reports = '/reports';
  static const results = '/results';
  static const gradeComparison = '/study/compare';
  static String gradeDetail(String id) =>
      '/study/grades/${Uri.encodeComponent(id)}';
}
