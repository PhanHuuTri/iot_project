import '../../../rest/models/rest_api_response.dart';

class ListMotoAndBikeEmptySlotModel extends BaseModel {
  List<EmptySlotModel> _data = [];

  ListMotoAndBikeEmptySlotModel.listDynamic(List<dynamic> list) {
    List<EmptySlotModel> tmp = [];
    for (int i = 0; i < list.length; i++) {
      var result = BaseModel.fromJson<EmptySlotModel>(list[i]);
      tmp.add(result);
    }
    _data = tmp;
  }

  List<EmptySlotModel> get records => _data;
}
class EmptySlotModel extends BaseModel {
  final String _floorName;
  final List<RegionModel> _regions= [];

  EmptySlotModel.fromJson(Map<String, dynamic> json)
      :  _floorName = json['floor'] ?? '' {
    _regions.addAll(BaseModel.mapList<RegionModel>(
      json: json,
      key: 'region',
    ));
  }

  Map<String, dynamic> toJson() => {
        'floor': _floorName,
        'EmptySpaces': _regions.map((e) => e.toJson()).toList(),
      };

  String get floorName => _floorName;
  List<RegionModel> get regions => _regions;
}
class RegionModel extends BaseModel{
  final String _name;
  final List<EmptySlotRegionModel> _emptySlots=[];

  RegionModel.fromJson(Map<String,dynamic> json)
  : _name = json['name']??''{
    _emptySlots.addAll(BaseModel.mapList<EmptySlotRegionModel>(json: json, key: 'emptySlots'));
  }
  Map<String,dynamic> toJson()=>{
    'name':_name,
    'emptySlots':_emptySlots.map((e) => e.toJson()).toList()
  };
  String get name => _name;
  List<EmptySlotRegionModel> get  emptySlots =>  _emptySlots;

}
class EmptySlotRegionModel extends BaseModel {
  final String _id;
  final String _plateNumber;
  final String _sensorId;
  final String _slotName;
  final String _region;
  final String _floor;
  final String _status;
  final String _mapImage;
  final String _guideImage;

  EmptySlotRegionModel.fromJson(Map<String, dynamic> json)
      :  _id=json['_id']??'',
      _plateNumber = json['plateNumber']??'',
      _sensorId = json['sensorId']??'',
      _slotName=json['slotName']??'',
      _region = json['region']??'',
      _floor = json['floor']??'',
      _status = json['status']??'',
      _mapImage = json['mapImage']??'',
      _guideImage =json['guideImage']??'';


  Map<String,dynamic> toJson() => {
    '_id':_id,
    'plateNumber':_plateNumber,
    'sensorId':_sensorId,
    'slotName':_slotName,
    'region':_region,
    'floor':_floor,
    'status':_status,
    'mapImage':_mapImage,
    'guideImage':_guideImage
      };

  String get id => _id;
  String get plateNumber => _plateNumber;
  String get sensorId => _sensorId;
  String get slotName => _slotName;
  String get region => _region;
  String get floor => _floor;
  String get  status => _status;
  String get mapImage => mapImage;
  String get guideImage => guideImage;
}

class MotoEmptySlotModel extends BaseModel {
  final String _id;
  final String _floorName;
  final List<MotoEmptySpaceModel> _emptySpaces = [];

  MotoEmptySlotModel.fromJson(Map<String, dynamic> json)
      : _id = json['ID'] ?? '',
        _floorName = json['FloorName'] ?? '' {
    _emptySpaces.addAll(BaseModel.mapList<MotoEmptySpaceModel>(
      json: json,
      key: 'EmptySpaces',
    ));
  }

  Map<String, dynamic> toJson() => {
        'ID': _id,
        'FloorName': _floorName,
        'EmptySpaces': _emptySpaces.map((e) => e.toJson()).toList(),
      };

  String get id => _id;
  String get floorName => _floorName;
  List<MotoEmptySpaceModel> get emptySpaces => _emptySpaces;
}


class MotoEmptySpaceModel extends BaseModel {
  final String _blockName;
  final int _emptySlot;

  MotoEmptySpaceModel.fromJson(Map<String, dynamic> json)
      : _blockName = json['BlockName'] ?? '',
        _emptySlot = json['EmptySlot'] ?? '';

  Map<String, dynamic> toJson() => {
        'BlockName': _blockName,
        'EmptySlot': _emptySlot,
      };

  String get blockName => _blockName;
  int get emptySlot => _emptySlot;
}

class ListMotoEmptySlotModel extends BaseModel {
  List<MotoEmptySlotModel> _data = [];

  ListMotoEmptySlotModel.listDynamic(List<dynamic> list) {
    List<MotoEmptySlotModel> tmp = [];
    for (int i = 0; i < list.length; i++) {
      var result = BaseModel.fromJson<MotoEmptySlotModel>(list[i]);
      tmp.add(result);
    }
    _data = tmp;
  }

  List<MotoEmptySlotModel> get records => _data;
}

class CarEmptySlotModel extends BaseModel {
  final int _id;
  final String _floorName;
  final List<CarEmptySpaceModel> _emptySpaces = [];

  CarEmptySlotModel.fromJson(Map<String, dynamic> json)
      : _id = json['ID'],
        _floorName = json['FloorName'] ?? '' {
    _emptySpaces.addAll(BaseModel.mapList<CarEmptySpaceModel>(
      json: json,
      key: 'EmptySpaces',
    ));
  }

  Map<String, dynamic> toJson() => {
        'ID': _id,
        'FloorName': _floorName,
        'EmptySpaces': _emptySpaces.map((e) => e.toJson()).toList(),
      };

  int get id => _id;
  String get floorName => _floorName;
  List<CarEmptySpaceModel> get emptySpaces => _emptySpaces;
}

class CarEmptySpaceModel extends BaseModel {
  final String _blockName;
  final List<dynamic> _details;

  CarEmptySpaceModel.fromJson(Map<String, dynamic> json)
      : _blockName = json['BlockName'] ?? '',
        _details = json['Details'] ?? [];

  Map<String, dynamic> toJson() => {
        'BlockName': _blockName,
        'Details': _details,
      };

  String get blockName => _blockName;
  List<dynamic> get emptySlot => _details;
}

class ListCarEmptySlotModel extends BaseModel {
  List<CarEmptySlotModel> _data = [];

  ListCarEmptySlotModel.listDynamic(List<dynamic> list) {
    List<CarEmptySlotModel> tmp = [];
    for (int i = 0; i < list.length; i++) {
      var result = BaseModel.fromJson<CarEmptySlotModel>(list[i]);
      tmp.add(result);
    }
    _data = tmp;
  }

  List<CarEmptySlotModel> get records => _data;
}
class CarEmptySlot extends BaseModel{
  final int _available;
  final int _pending;
  final int _unavailable;
  final int _total;

  CarEmptySlot.fromJson(Map<String,dynamic> json)
  :_available=json['available']??0,
  _pending = json['pending']??0,
  _unavailable = json['unavailable']??0,
  _total = json['total']??0;

  Map<String,dynamic> toJson()=>{
    'available':_available,
    'pending':_pending,
    'unavailable':_unavailable,
    'total':_total
  };

  int get available=> _available;
  int get pending=> _pending;
  int get unavailable=> _unavailable;
  int get total=> _total;
}
