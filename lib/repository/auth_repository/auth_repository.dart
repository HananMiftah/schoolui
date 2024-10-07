import '../../data_provider/auth_provider/auth_provider.dart';
import '../../models/auth_response.dart';

class AuthRepository {
  final AuthProvider authProvider;

  AuthRepository(this.authProvider);

  Future<AuthResponse> login(String email, String password) {
    return authProvider.login(email, password);
  }

  Future<String> refreshToken(String refreshToken) {
    return authProvider.refreshToken(refreshToken);
  }
}
