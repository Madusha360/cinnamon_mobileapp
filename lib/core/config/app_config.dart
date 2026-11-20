abstract final class AppConfig {
  static const name = 'QuillGrade';
  static const version = '0.1.0';
  // Reserved for the Phase 7 adapter. No network requests occur in Phase 1.
  static const apiBaseUrl = String.fromEnvironment('QUILLGRADE_API_BASE_URL');
  static const defaultMarkerSizeMm = 20.0;
}
