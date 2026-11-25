/// Base URL backend Django.
///
/// Default ke http://10.0.2.2:8000 (alamat laptop kalau dilihat dari emulator Android).
/// Kalau jalan di Chrome, timpa pakai: --dart-define=API_BASE_URL=http://localhost:8000
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);
