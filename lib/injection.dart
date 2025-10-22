import 'package:dio/dio.dart';
import 'features/auth/data/datasources/auth_remote_ds.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/sign_in.dart';
class Gateway {
  final Dio dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 20)));
  final String baseUrl = 'https://frijo.noviindus.in/api/otp_verified';

  // auth dependencies
  late final authRemote = AuthRemoteDataSourceImpl(dio, baseUrl: "baseUrl");
  late final authRepo = AuthRepositoryImpl(authRemote);
  late final signIn = SignIn(authRepo);

  // feed dependencies
  // late final feedRemote = FeedRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  // late final feedRepo = FeedRepositoryImpl(feedRemote);
  // late final uploadFeed = UploadFeed(feedRepo);
}
