import '../../data/models/my_feed_model.dart';

abstract class MyFeedRepository {
  Future<MyFeedModelClass> getMyFeeds(String token);
}
