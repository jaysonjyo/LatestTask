import 'package:flutter/cupertino.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/usecases/get_home_data.dart';

enum HomeStatus { idle, loading, success, failure }

class HomeProvider extends ChangeNotifier {
  final GetHomeData getHomeData;

  HomeProvider(this.getHomeData);

  HomeStatus status = HomeStatus.idle;
  HomeEntity? entity;
  Failure? failure;

  Future<void> loadHome(String token) async {
    status = HomeStatus.loading;
    notifyListeners();

    final result = await getHomeData(token);
    if (result.isRight) {
      entity = result.right;
      status = HomeStatus.success;
    } else {
      failure = result.left;
      status = HomeStatus.failure;
    }

    notifyListeners();
  }
}
