import '../../domain/entities/feed_entity.dart';

class CreateFeedModel extends FeedEntity {
  CreateFeedModel({super.message, super.status});

  factory CreateFeedModel.fromJson(Map<String, dynamic> json) {
    return CreateFeedModel(
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
    };
  }
}
