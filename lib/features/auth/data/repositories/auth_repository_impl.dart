
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_ds.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  AuthRepositoryImpl(this.remote);

  @override
  Future<Result<Failure, AuthEntity>> signIn({
    required String countryCode,
    required String phone,
  }) async {
    try {
      final model = await remote.signIn(
        countryCode: countryCode,
        phone: phone,
      );
      return Result.ok(model.toEntity());
    } on DioException catch (e) {
      return Result.err(NetworkFailure(e.message ?? 'Sign-in failed'));
    } catch (e) {
      return Result.err(NetworkFailure('Unexpected error: $e'));
    }
  }
}
