import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/feed_entity.dart';
import '../../domain/usecases/create_feed.dart';

class CreateFeedProvider extends ChangeNotifier {
  final CreateFeed createFeedUseCase;
  CreateFeedProvider(this.createFeedUseCase);

  bool isLoading = false;
  FeedEntity? response;

  Future<void> createNewFeed({
    required File video,
    required File image,
    required String desc,
    required List<int> category,
    required String accessToken,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      response = await createFeedUseCase(
        video: video,
        image: image,
        desc: desc,
        category: category,
        accessToken: accessToken,
      );
    } catch (e) {
      print("Error creating feed: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
