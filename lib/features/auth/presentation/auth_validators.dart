class AuthValidators {
  const AuthValidators._();

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)+)([A-Za-z]{2,})$',
    );
    return emailRegex.hasMatch(email);
  }
}
