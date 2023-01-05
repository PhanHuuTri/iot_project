import 'package:web_iot/main.dart';

class RoomModel extends BaseModel {
  final List<dynamic> images;
  final String status;
  final int capacity;
  final int createdTime;
  final int updatedTime;
  final String _id;
  final String name;
  final dynamic location;
  final String area;
  final String userCreated;
  final String userUpdated;
  final int v;

  RoomModel.fromJson(Map<String, dynamic> json)
      : images = json['images'] ?? '',
        status = json['status'] ?? '',
        capacity = json['capacity'] ?? '',
        createdTime = json['createdTime'] ?? '',
        updatedTime = json['updatedTime'] ?? '',
        _id = json['_id'] ?? '',
        name = json['name'] ?? '',
        location = json['location'] ?? '',
        area = json['area'] ?? '',
        userCreated = json['userCreated'] ?? '',
        userUpdated = json['userUpdated'] ?? '',
        v = json['v'] ?? '';

  Map<String, dynamic> toJson() => {
        'images': images,
        'status': status,
        'capacity': capacity,
        'createdTime': createdTime,
        'updatedTime': updatedTime,
        '_id': _id,
        'name': name,
        'location': location,
        'area': area,
        'userCreated': userCreated,
        'userUpdated': userUpdated,
        'v': v,
      };
}

class RoomListModel extends BaseModel {
  List<RoomModel> _data = [];
  Paging _metaData = Paging.fromJson({});

  RoomListModel.fromJson(Map<String, dynamic> parsedJson) {
    List<RoomModel> tmp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      var result = BaseModel.fromJson<RoomModel>(parsedJson['data'][i]);
      tmp.add(result);
    }
    _data = tmp;
    _metaData = Paging.fromJson(parsedJson['meta_data']);
  }

  List<RoomModel> get records => _data;

  Paging get meta => _metaData;
}
