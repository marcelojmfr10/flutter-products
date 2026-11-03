import 'package:flutter_products/features/auth/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepositoryImpl();
});

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  new({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}

final authProvider = NotifierProvider.autoDispose<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  @override
  build() => AuthState();

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(Duration(milliseconds: 500));

    try {
      final user = await _authRepository.login(email, password);
      _setLoggedUser(user);
    } on WrongCredentials {
      logout('Credenciales no son correctas');
    } catch (e) {
      logout('Error no controlado');
    }
  }

  void registerUser(String email, String password, String fullName) async {}

  void checkAuthStatus() async {}

  void _setLoggedUser(User user) {
    state = state.copyWith(user: user, authStatus: AuthStatus.authenticated);
  }

  Future<void> logout(String? errorMessage) async {
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
    );
  }
}
