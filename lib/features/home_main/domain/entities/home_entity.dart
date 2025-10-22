import '../../data/models/home_model.dart';

class HomeEntity {
  final User? user;
  final String userName;
  final List<String> banners;
  final List<CategoryDict> categoryDict;
  final List<ResultItem> results;

  HomeEntity({
    this.user,
    required this.userName,
    required this.banners,
    required this.categoryDict,
    required this.results,
  });
}
