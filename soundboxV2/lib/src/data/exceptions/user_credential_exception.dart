class UserCredentialException implements Exception {
  const UserCredentialException({required this.type, this.message, this.value});

  final UserCredentialExceptionType type;
  final String? message;
  final String? value;
}

enum UserCredentialExceptionType {
  notFound,
  invalidMPin,
  invalidDeviceId,
  invalidMobileNumber
}
