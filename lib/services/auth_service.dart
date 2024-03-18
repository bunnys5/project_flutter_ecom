import 'dart:async';

class AuthService {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  bool isAuthenticated = false;

  Stream<bool> get authState => _verificationNotifier.stream;

  void updateAuthState(bool authState) {
    isAuthenticated = authState;
    _verificationNotifier.add(authState);
  }

  void dispose() {
    _verificationNotifier.close();
  }
}

final authService = AuthService(); // Create a singleton instance
