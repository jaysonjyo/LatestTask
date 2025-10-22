class MyFeedEntity {
  final int id;
  final String? description;
  final String? image;
  final String? video;
  final List<int> likes;
  final List<int> dislikes;
  final List<int> bookmarks;
  final List<int> hide;
  final String? createdAt;
  final bool follow;
  final FeedUserEntity? user;

  MyFeedEntity({
    required this.id,
    this.description,
    this.image,
    this.video,
    this.likes = const [],
    this.dislikes = const [],
    this.bookmarks = const [],
    this.hide = const [],
    this.createdAt,
    this.follow = false,
    this.user,
  });
}

class FeedUserEntity {
  final int id;
  final String? name;
  final String? image;

  FeedUserEntity({
    required this.id,
    this.name,
    this.image,
  });
}
