import 'package:dio/dio.dart';
import 'features/auth/data/datasources/auth_remote_ds.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/sign_in.dart';
import 'features/create_feed/data/datasources/create_feed_remote_ds.dart';
import 'features/create_feed/domain/repositories/create_feed_repository.dart';
import 'features/create_feed/domain/usecases/create_feed.dart';
import 'features/create_feed/presentation/providers/create_feed_provider.dart';
import 'features/home_main/data/datasources/home_remote_ds.dart';
import 'features/home_main/data/repositories/home_repository_impl.dart';
import 'features/home_main/domain/usecases/get_home_data.dart';
import 'features/home_main/presentation/providers/home_provider.dart';
import 'features/my_feeds/data/datasources/my_feed_remote_data_source.dart';
import 'features/my_feeds/data/repositories/my_feed_repository_impl.dart';
class Gateway {
  final Dio dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 20)));
  final String baseUrl = 'https://frijo.noviindus.in/api';

  // auth dependencies
  late final authRemote = AuthRemoteDataSourceImpl(dio, baseUrl:baseUrl);
  late final authRepo = AuthRepositoryImpl(authRemote);
  late final signIn = SignIn(authRepo);


  //home_main
  late final homeRepo = HomeRepositoryImpl(dio, baseUrl: baseUrl);
  late final getHomeData = GetHomeData(homeRepo);
  late final homeProvider = HomeProvider(getHomeData);

  // ✅ my_feeds
  late final myFeedRemote = MyFeedRemoteDataSource(dio, baseUrl: baseUrl);
  late final myFeedRepository = MyFeedRepositoryImpl(myFeedRemote);

// ================= CREATE FEED (NEW) =================
  late final createFeedRemote = CreateFeedRemoteDataSourceImpl(dio: dio);
  late final createFeedRepository = CreateFeedRepositoryImpl(remoteDataSource: createFeedRemote);
  late final createFeedUseCase = CreateFeed(createFeedRepository);
  late final createFeedProvider = CreateFeedProvider(createFeedUseCase);
}
//
// import 'package:dio/dio.dart';
//
// // AUTH
// import 'features/auth/data/datasources/auth_remote_ds.dart';
// import 'features/auth/data/repositories/auth_repository_impl.dart';
// import 'features/auth/domain/usecases/sign_in.dart';
//
// // HOME MAIN
// import 'features/home_main/data/datasources/home_remote_ds.dart';
// import 'features/home_main/data/repositories/home_repository_impl.dart';
// import 'features/home_main/domain/usecases/get_home_data.dart';
// import 'features/home_main/presentation/providers/home_provider.dart';
//
// // MY FEEDS
// import 'features/my_feeds/data/datasources/my_feed_remote_data_source.dart';
// import 'features/my_feeds/data/repositories/my_feed_repository_impl.dart';
//
// // CREATE FEED
// import 'features/create_feed/data/datasources/create_feed_remote_ds.dart';
// import 'features/create_feed/data/repositories/create_feed_repository_impl.dart';
// import 'features/create_feed/domain/usecases/create_feed.dart';
// import 'features/create_feed/presentation/providers/create_feed_provider.dart';
//
// class Gateway {
//   final Dio dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 20)));
//   final String baseUrl = 'https://frijo.noviindus.in/api';
//
//   // ================= AUTH =================
//   late final authRemote = AuthRemoteDataSourceImpl(dio, baseUrl: baseUrl);
//   late final authRepo = AuthRepositoryImpl(authRemote);
//   late final signIn = SignIn(authRepo);
//
//   // ================= HOME MAIN =================
//   late final homeRemote = HomeRemoteDataSourceImpl(dio, baseUrl: baseUrl);
//   late final homeRepo = HomeRepositoryImpl(homeRemote);
//   late final getHomeData = GetHomeData(homeRepo);
//   late final homeProvider = HomeProvider(getHomeData);
//
//   // ================= MY FEEDS =================
//   late final myFeedRemote = MyFeedRemoteDataSource(dio, baseUrl: baseUrl);
//   late final myFeedRepository = MyFeedRepositoryImpl(myFeedRemote);
//
//
// }
