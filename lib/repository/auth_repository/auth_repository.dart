import '../../data_provider/auth_provider/auth_provider.dart';
import '../../models/auth_response.dart';

class AuthRepository {
  final AuthProvider authProvider;

  AuthRepository(this.authProvider);

  Future<AuthResponse> login(String email, String password) {
    return authProvider.login(email, password);
  }

  Future<SignupResponse> signup(String email, String name,String address, String phone) {
    return authProvider.signup(email, address,name,phone);
  }

  Future<String> refreshToken(String refreshToken) {
    return authProvider.refreshToken(refreshToken);
  }
}
