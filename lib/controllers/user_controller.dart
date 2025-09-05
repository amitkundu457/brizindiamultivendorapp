import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController {
  Future<User> getUser() async {
    return await AuthService.fetchUser();
  }
}
