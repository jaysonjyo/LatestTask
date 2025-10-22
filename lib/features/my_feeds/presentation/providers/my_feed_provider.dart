import 'package:flutter/material.dart';
import '../../data/models/my_feed_model.dart';
import '../../data/repositories/my_feed_repository_impl.dart';

enum MyFeedStatus { initial, loading, success, failure }

class MyFeedProvider with ChangeNotifier {
  final MyFeedRepositoryImpl repository;

  MyFeedProvider(this.repository);

  MyFeedStatus status = MyFeedStatus.initial;
  MyFeedModelClass? entity;
  String? error;

  Future<void> loadMyFeeds(String token) async {
    status = MyFeedStatus.loading;
    notifyListeners();

    try {
      entity = await repository.getMyFeeds(token);
      status = MyFeedStatus.success;
    } catch (e) {
      error = e.toString();
      status = MyFeedStatus.failure;
    }
    notifyListeners();
  }
}
