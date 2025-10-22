import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/home_entity.dart';

abstract class HomeRepository {
  Future<Result<Failure, HomeEntity>> getHomeData(String token);
}
