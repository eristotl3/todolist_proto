class AppException implements Exception {
  final String message;
  final Object? cause;

  const AppException(this.message, {this.cause});

  @override
  String toString() => 'AppException: $message';
}

class EmailConfirmationPendingException extends AppException {
  const EmailConfirmationPendingException()
      : super(
          'Account created! Check your email and confirm your address before signing in.',
        );
}
