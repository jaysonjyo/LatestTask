import '../../domain/entities/home_entity.dart';

class HomeModel {
  HomeModel({
    this.user,
    this.banners,
    this.categoryDict,
    this.results,
    this.status,
    this.next,
  });

  User? user;
  List<String>? banners;
  List<CategoryDict>? categoryDict;
  List<ResultItem>? results;
  bool? status;
  bool? next;

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      banners: json['banners'] != null ? List<String>.from(json['banners']) : [],
      categoryDict: (json['category_dict'] as List?)
          ?.map((v) => CategoryDict.fromJson(v))
          .toList(),
      results: (json['results'] as List?)
          ?.map((v) => ResultItem.fromJson(v))
          .toList(),
      status: json['status'],
      next: json['next'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'banners': banners,
      'category_dict': categoryDict?.map((e) => e.toJson()).toList(),
      'results': results?.map((e) => e.toJson()).toList(),
      'status': status,
      'next': next,
    };
  }
}

class ResultItem {
  ResultItem({
    this.id,
    this.description,
    this.image,
    this.video,
    this.likes,
    this.createdAt,
    this.follow,
    this.user,
  });

  int? id;
  String? description;
  String? image;
  String? video;
  List<int>? likes;
  String? createdAt;
  bool? follow;
  MiniUser? user;

  factory ResultItem.fromJson(Map<String, dynamic> json) {
    return ResultItem(
      id: json['id'],
      description: json['description'],
      image: json['image'],
      video: json['video'],
      likes: json['likes'] != null ? List<int>.from(json['likes']) : [],
      createdAt: json['created_at'],
      follow: json['follow'],
      user: json['user'] != null ? MiniUser.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'image': image,
      'video': video,
      'likes': likes,
      'created_at': createdAt,
      'follow': follow,
      'user': user?.toJson(),
    };
  }
}

class MiniUser {
  MiniUser({
    this.id,
    this.name,
    this.image,
  });

  int? id;
  String? name;
  String? image;

  factory MiniUser.fromJson(Map<String, dynamic> json) {
    return MiniUser(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'image': image};
}

class CategoryDict {
  CategoryDict({
    this.id,
    this.title,
  });

  String? id;
  String? title;

  factory CategoryDict.fromJson(Map<String, dynamic> json) {
    return CategoryDict(
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title};
}

class User {
  User({
    this.id,
    this.uniqueId,
    this.name,
    this.phone,
    this.image,
    this.coins,
    this.credit,
    this.debit,
  });

  int? id;
  String? uniqueId;
  String? name;
  String? phone;
  String? image;
  int? coins;
  dynamic credit;
  dynamic debit;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      uniqueId: json['unique_id'],
      name: json['name'],
      phone: json['phone'],
      image: json['image'],
      coins: json['coins'],
      credit: json['credit'],
      debit: json['debit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unique_id': uniqueId,
      'name': name,
      'phone': phone,
      'image': image,
      'coins': coins,
      'credit': credit,
      'debit': debit,
    };
  }
}

/// ✅ Mapper: Converts Model → Entity for domain layer
extension HomeModelMapper on HomeModel {
  HomeEntity toEntity() {
    return HomeEntity(
      user: user,
      userName: user?.name ?? '',
      banners: banners ?? [],
      categoryDict: categoryDict ?? [],
      results: results ?? [],
    );
  }
}
