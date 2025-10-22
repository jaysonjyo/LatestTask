import 'dart:io';
import '../../domain/entities/feed_entity.dart';

abstract class CreateFeedRepository {
  Future<FeedEntity> createFeed({
    required File video,
    required File image,
    required String desc,
    required List<int> category,
    required String accessToken,
  });
}
