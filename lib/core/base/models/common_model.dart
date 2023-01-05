class Paging {
  final int _totalRecords;
  final int _limit;
  final int _page;
  final int _totalPage;

  Paging.fromJson(Map<String, dynamic> json)
      : _totalRecords = json['total_records'] ?? 0,
        _totalPage = json['total_page'] ?? 0,
        _limit = int.tryParse(json['limit']?.toString() ?? '0') ?? 0,
        _page = int.tryParse(json['page']?.toString() ?? '0') ?? 0;

  Paging.fromParkingJson(Map<String, dynamic> json)
      : _totalRecords = json['TotalItem'] ?? 0,
        _totalPage = json['TotalPage'] ?? 0,
        _limit = int.tryParse(json['PageSize']?.toString() ?? '0') ?? 0,
        _page = int.tryParse(json['PageIndex']?.toString() ?? '0') ?? 0;

  int get limit => _limit;
  int get page => _page;
  int get totalPage => _totalPage;
  int get totalRecords => _totalRecords;

  bool get isFirstPage => page == 1;
  bool get isLastPage => page == totalPage;
  bool get canGoNext => page < totalPage;
  bool get canGoPrevious => page > 1;
  int get nextPage => page + 1;
  int get previousPage => page - 1;
  int get recordOffset => (page - 1) * limit;
}

class StringObject {
  String _original = '';
  String? _edited;
  bool _hasDefault = false;

  StringObject(String val, {bool hasDefault = false}) {
    _original = val;
    _hasDefault = hasDefault;
  }

  String get lastValue => _edited ?? _original;
  bool get hasValue => _hasDefault || isEdited;
  bool get isEdited => _edited != null && _edited != _original;
  setValue(String newValue) => _edited = newValue;
  commit() {
    if (_edited != null) _original = _edited!;
  }
}

class BoolObject {
  bool _original = false;
  bool? _edited;
  bool _hasDefault = false;

  BoolObject(bool value, {bool hasDefault = false}) {
    _original = value;
    _hasDefault = hasDefault;
  }

  bool get lastValue => _edited ?? _original;
  bool get hasValue => _hasDefault || isEdited;
  bool get isEdited => _edited != null && _edited != _original;
  setValue(bool newValue) => _edited = newValue;
  commit() {
    if (_edited != null) _original = _edited!;
  }
}

class IntObject {
  int _original = 0;
  int? _edited;
  bool _hasDefault = false;

  IntObject(int value, {bool hasDefault = false}) {
    _original = value;
    _hasDefault = hasDefault;
  }

  int get lastValue => _edited ?? _original;
  bool get hasValue => _hasDefault || isEdited;
  bool get isEdited => _edited != null && _edited != _original;
  setValue(int newValue) => _edited = newValue;
  commit() {
    if (_edited != null) _original = _edited!;
  }
}

class DoubleObject {
  double _original = 0;
  double? _edited;
  bool _hasDefault = false;

  DoubleObject(double value, {bool hasDefault = false}) {
    _original = value;
    _hasDefault = hasDefault;
  }

  double get lastValue => _edited ?? _original;
  bool get hasValue => _hasDefault || isEdited;
  bool get isEdited => _edited != null && _edited != _original;
  setValue(double newValue) => _edited = newValue;
  commit() {
    if (_edited != null) _original = _edited!;
  }
}
