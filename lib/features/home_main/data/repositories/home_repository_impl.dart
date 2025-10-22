import 'package:dio/dio.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../models/home_model.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/error/failures.dart';

class HomeRepositoryImpl implements HomeRepository {
  final Dio dio;
  final String baseUrl;

  HomeRepositoryImpl(this.dio, {required this.baseUrl});

  @override
  Future<Result<Failure, HomeEntity>> getHomeData(String token) async {
    try {
      final response = await dio.get(
        '$baseUrl/home',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final model = HomeModel.fromJson(response.data);
      return Result.ok(model.toEntity());
    } catch (e) {
      // ✅ Use concrete Failure (ServerFailure)
      return Result.err(ServerFailure(e.toString()));
    }
  }
}
