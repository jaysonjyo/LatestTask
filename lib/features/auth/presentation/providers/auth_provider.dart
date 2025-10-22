import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/sign_in.dart';

enum AuthStatus { idle, loading, success, failure }

class AuthProvider extends ChangeNotifier {
  final SignIn signInUC;
  AuthProvider(this.signInUC);

  AuthStatus status = AuthStatus.idle;
  AuthEntity? user;
  Failure? failure;

  Future<void> signIn(String code, String phone) async {
    status = AuthStatus.loading;
    notifyListeners();

    final result = await signInUC(countryCode: code, phone: phone);
    if (result.isRight) {
      user = result.right;
      status = AuthStatus.success;
    } else {
      failure = result.left;
      status = AuthStatus.failure;
    }
    notifyListeners();
  }
}
