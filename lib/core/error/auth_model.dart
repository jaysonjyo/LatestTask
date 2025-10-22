class AuthModel {
  AuthModel({
      this.status, 
      this.privilage, 
      this.token, 
      this.phone,});

  AuthModel.fromJson(dynamic json) {
    status = json['status'];
    privilage = json['privilage'];
    token = json['token'] != null ? Token.fromJson(json['token']) : null;
    phone = json['phone'];
  }
  bool? status;
  bool? privilage;
  Token? token;
  String? phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['privilage'] = privilage;
    if (token != null) {
      map['token'] = token?.toJson();
    }
    map['phone'] = phone;
    return map;
  }

}

class Token {
  Token({
      this.refresh, 
      this.access,});

  Token.fromJson(dynamic json) {
    refresh = json['refresh'];
    access = json['access'];
  }
  String? refresh;
  String? access;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['refresh'] = refresh;
    map['access'] = access;
    return map;
  }

}