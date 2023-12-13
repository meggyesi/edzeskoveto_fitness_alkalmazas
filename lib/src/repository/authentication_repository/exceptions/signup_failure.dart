class SignUpFailure {
  final String message;

  SignUpFailure([this.message = "Unknown error occurred."]);

  factory SignUpFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return SignUpFailure('Please enter a stronger password.');
      case 'invalid-email':
        return SignUpFailure('Please enter a valid email.');
      case 'email-already-in-use':
        return SignUpFailure('An account already exists with that email.');
      case 'operation-not-allowed':
        return SignUpFailure('Operation not allowed.');
      case 'user-disabled':
        return SignUpFailure('User account has been disabled.');
      default:
        return SignUpFailure();
    }
  }
}
