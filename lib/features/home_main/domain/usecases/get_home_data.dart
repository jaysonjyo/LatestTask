import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeData {
  final HomeRepository repository;

  GetHomeData(this.repository);

  Future<Result<Failure, HomeEntity>> call(String token) {
    return repository.getHomeData(token);
  }
}
