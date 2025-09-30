const String backendBaseUrl = String.fromEnvironment(
  'BACKEND_BASE_URL',
  defaultValue: 'http://localhost:3000',
);

const String defaultBusinessId = String.fromEnvironment(
  'DEFAULT_BUSINESS_ID',
  defaultValue: '1',
);
