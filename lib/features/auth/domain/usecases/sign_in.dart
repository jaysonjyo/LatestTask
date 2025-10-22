import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';
import '../entities/auth_entity.dart';

class SignIn {
  final AuthRepository repository;
  SignIn(this.repository);

  Future<Result<Failure, AuthEntity>> call({
    required String countryCode,
    required String phone,
  }) async {
    if (phone.isEmpty) {
      return Result.err(ValidationFailure('Phone number required'));
    }
    return await repository.signIn(countryCode: countryCode, phone: phone);
  }
}
