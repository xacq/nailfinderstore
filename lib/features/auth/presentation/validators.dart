///codex/add-email-and-password-validation-utilities
/// Utility helpers for validating auth related fields.
///
/// These can be reused across forms so the validation rules live in a single
/// place and stay in sync.
bool isValidEmail(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return false;

  const pattern = r'^[\w\.\-+]+@[\w\.-]+\.[a-zA-Z]{2,}$';
  return RegExp(pattern).hasMatch(trimmed);
}

/// Returns the list of unmet password recommendations for [value].
///
/// When the returned list is empty the password is considered valid for the
/// current set of rules.
List<String> passwordIssues(String value) {
  final trimmed = value.trim();
  final issues = <String>[];

  if (trimmed.length < 8) {
    issues.add('La contraseña debe tener al menos 8 caracteres.');
  }
  if (!RegExp(r'[A-Za-z]').hasMatch(trimmed)) {
    issues.add('Incluye al menos una letra.');
  }
  if (!RegExp(r'[0-9]').hasMatch(trimmed)) {
    issues.add('Incluye al menos un número.');
  }

  return issues;

class AuthValidators {
  AuthValidators._();

  static final RegExp _emailRegExp = RegExp(
    r'^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$',
    caseSensitive: false,
  );

  static bool isValidEmail(String value) {
    return _emailRegExp.hasMatch(value.trim());
  }
///main
}
