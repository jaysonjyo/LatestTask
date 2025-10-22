import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Result<Failure, AuthEntity>> signIn({
    required String countryCode,
    required String phone,
  });
}
