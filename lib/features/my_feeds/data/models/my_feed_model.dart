class MyFeedModelClass {
  int? count;
  String? next;
  dynamic previous;
  List<FeedResult>? results;

  MyFeedModelClass({this.count, this.next, this.previous, this.results});

  factory MyFeedModelClass.fromJson(Map<String, dynamic> json) {
    return MyFeedModelClass(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'] != null
          ? List<FeedResult>.from(
        json['results'].map((x) => FeedResult.fromJson(x)),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'count': count,
    'next': next,
    'previous': previous,
    'results': results?.map((x) => x.toJson()).toList(),
  };
}

class FeedResult {
  int? id;
  String? description;
  String? image;
  String? video;
  List<int>? likes;
  List<int>? dislikes;
  List<int>? bookmarks;
  List<int>? hide;
  String? createdAt;
  bool? follow;
  FeedUser? user;

  FeedResult({
    this.id,
    this.description,
    this.image,
    this.video,
    this.likes,
    this.dislikes,
    this.bookmarks,
    this.hide,
    this.createdAt,
    this.follow,
    this.user,
  });

  factory FeedResult.fromJson(Map<String, dynamic> json) {
    return FeedResult(
      id: json['id'],
      description: json['description'],
      image: json['image'],
      video: json['video'],
      likes: (json['likes'] as List?)?.map((e) => e as int).toList() ?? [],
      dislikes: (json['dislikes'] as List?)?.map((e) => e as int).toList() ?? [],
      bookmarks: (json['bookmarks'] as List?)?.map((e) => e as int).toList() ?? [],
      hide: (json['hide'] as List?)?.map((e) => e as int).toList() ?? [],
      createdAt: json['created_at'],
      follow: json['follow'],
      user: json['user'] != null ? FeedUser.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'image': image,
    'video': video,
    'likes': likes,
    'dislikes': dislikes,
    'bookmarks': bookmarks,
    'hide': hide,
    'created_at': createdAt,
    'follow': follow,
    'user': user?.toJson(),
  };
}

class FeedUser {
  int? id;
  String? name;
  String? image;

  FeedUser({this.id, this.name, this.image});

  factory FeedUser.fromJson(Map<String, dynamic> json) => FeedUser(
    id: json['id'],
    name: json['name'],
    image: json['image'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
  };
}
