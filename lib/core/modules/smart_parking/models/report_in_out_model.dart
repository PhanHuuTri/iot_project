import '../../../rest/models/rest_api_response.dart';

class ReportInOutModel extends BaseModel {
  final int _stt;
  final String _date;
  final int _totalIn;
  final int _totalOut;
  final List<InOutModel> _inOutByHour = [];

  ReportInOutModel.fromJson(Map<String, dynamic> json)
      : _stt = json['STT'],
        _date = json['Date'] ?? '',
        _totalIn = json['TotalIn'],
        _totalOut = json['TotalOut'] {
    _inOutByHour.addAll(BaseModel.mapList<InOutModel>(
      json: json,
      key: 'InOutByHour',
    ));
  }

  Map<String, dynamic> toJson() => {
        'STT': _stt,
        'Date': _date,
        'TotalIn': _stt,
        'TotalOut': _date,
        'InOutByHour': _inOutByHour.map((e) => e.toJson()).toList(),
      };

  int get stt => _stt;
  String get date => _date;
  int get totalIn => _totalIn;
  int get totalOut => _totalOut;
  List<InOutModel> get inOutByHour => _inOutByHour;
}

class InOutModel extends BaseModel {
  final int _index;
  final String _hours;
  final VehicleModel _inVehicle;
  final VehicleModel _outVehicle;

  InOutModel.fromJson(Map<String, dynamic> json)
      : _index = json['Index'],
        _hours = json['Hours'] ?? '',
        _inVehicle = BaseModel.map<VehicleModel>(json: json, key: 'In'),
        _outVehicle = BaseModel.map<VehicleModel>(json: json, key: 'Out');

  Map<String, dynamic> toJson() => {
        'Index': _index,
        'Hours': _hours,
        'In': _inVehicle,
        'Out': _outVehicle,
      };
  int get index => _index;
  String get hours => _hours;
  VehicleModel get inVehicle => _inVehicle;
  VehicleModel get outVehicle => _outVehicle;
}

class VehicleModel extends BaseModel {
  final int _car;
  final int _moto;
  final int _bicycle;

  VehicleModel.fromJson(Map<String, dynamic> json)
      : _car = json['Car'],
        _moto = json['Moto'],
        _bicycle = json['Bicycle'];

  Map<String, dynamic> toJson() => {
        'Car': _car,
        'Moto': _moto,
        'Bicycle': _bicycle,
      };

  int get car => _car;
  int get moto => _moto;
  int get bicycle => _bicycle;
}

class ListReportInOutModel extends BaseModel {
  List<ReportInOutModel> _data = [];

  ListReportInOutModel.listDynamic(List<dynamic> list) {
    List<ReportInOutModel> tmp = [];
    for (int i = 0; i < list.length; i++) {
      var result = BaseModel.fromJson<ReportInOutModel>(list[i]);
      tmp.add(result);
    }
    _data = tmp;
  }

  List<ReportInOutModel> get records => _data;
}
