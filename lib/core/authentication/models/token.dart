class Token {
  String token = '';
  String id = '';

  Token({this.token = '', this.id = ''});

  Token.fromJson(Map<String, dynamic>? json) {
    token = json?['token'] ?? '';
    id = json?['id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    return data;
  }
}
