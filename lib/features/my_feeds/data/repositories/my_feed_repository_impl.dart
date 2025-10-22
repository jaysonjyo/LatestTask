import '../../domain/repositories/my_feed_repository.dart';
import '../datasources/my_feed_remote_data_source.dart';
import '../models/my_feed_model.dart';

class MyFeedRepositoryImpl implements MyFeedRepository {
  final MyFeedRemoteDataSource remoteDataSource;

  MyFeedRepositoryImpl(this.remoteDataSource);

  @override
  Future<MyFeedModelClass> getMyFeeds(String token) {
    return remoteDataSource.fetchMyFeeds(token);
  }
}
