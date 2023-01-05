class UserData {
  int id = -1;
  String token = '';

  UserData({this.id = -1, this.token = ''});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['token'] = token;
    return data;
  }
}
