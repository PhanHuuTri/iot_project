// import 'package:web_iot/core/modules/user_management/models/account_model.dart';
import 'package:web_iot/main.dart';

class HealthylModel extends BaseModel {
  final String _id;
  final String _room;
  final String _device;
  final String _userCreate;
  final String _userUpdate;
  final String _event;
  final int _updatedTime;
  final int _createdTime;
  // final UserModel _user;

  HealthylModel.fromJson(Map<String,dynamic> json)
    :_id =json['_id']??'',
    _room = json['roomHealthyCheck']??'',
    _device = json['device_name']??'',
    _userCreate = json['user_name_created']??'',
    _userUpdate =json['user_name_updated']??'',
    _event =json['event']??'',
    _updatedTime =json['updated_time']??'',
    
    // _user=BaseModel.mapuser<UserModel>(
    //     json: json,
    //     key: 'users'
    //   ),
    _createdTime = json['created_time']??'';
      
  

  Map<String,dynamic> toJson()=>{
    '_id':_id,
    'roomHealthyCheck':_room,
    'device_name':_device,
    'user_name_created':_userCreate,
    'user_name_updated':_userUpdate,
    // 'user_updated':_user.toJson(),
    'event':_event,
    'updated_time':_updatedTime,
    'created_time':_createdTime,
  };

  String get id => _id;
  String get room => _room;
  String get device => _device;
  String get userCreate => _userCreate;
  String get userUpdate => _userUpdate;
  // UserModel get user => _user;
  String get event => _event;
  int get updatedTime => _updatedTime;
  int get createdTime => _createdTime;

  // _fetchUserDataId( String  id) {
  //   _userBloc.fetchDataById(id);
  // }
}
class EditHeathyModel extends EditBaseModel{
  String id='';
  String room ='';
  String device ='';
  String userCreate='';
  String userUpdate='';
  // String user='';
  String event ='';
  int updatedTime=0;
  int createdTime=0;

  EditHeathyModel.fromModel(HealthylModel? heathyl){
    id = heathyl?.id??'';
    room = heathyl?.room??'';
    device = heathyl?.device??'';
    userCreate=heathyl?.userCreate??'';
    userUpdate=heathyl?.userUpdate??'';
    // user = heathyl?.user?.id??'';
    event = heathyl?.event??'';
    updatedTime = heathyl?.updatedTime??0;
    createdTime =heathyl?.createdTime??0;
  }
  Map<String,dynamic> toEditInfoJson(){
    Map<String,dynamic> params ={
      'roomHealthyCheck':room,
      'device_name':device,
      // 'user_updated':user,
      'user_name_created':userCreate,
      'user_name_updated':userUpdate,
      'event':event,
      'updated_time':updatedTime,
      'created_time':createdTime,
    };
    return params;
  }
}
class HealthylListModel extends BaseModel{
  List<HealthylModel> _data=[];
  Paging _metaData = Paging.fromJson({});

  HealthylListModel.fromJson(Map<String,dynamic> parsedJson){
    List<HealthylModel> tmp =[];
    for(int i = 0; i< parsedJson['data'].length;i++){
      var result = BaseModel.fromJson<HealthylModel>(parsedJson['data'][i]);
      tmp.add(result);
    }
    _data =tmp;
    _metaData = Paging.fromJson(parsedJson['meta_data']);
  }
  List<HealthylModel> get records => _data;
  Paging get meta => _metaData;
}

//Camera device model
class HealthylDeviceModel extends BaseModel{
  final String _id;
  final String _name;
  final String _description;
  //final String _serial;
  final String _ip;
  final String _port;
  final String _status;

  HealthylDeviceModel.fromJson(Map<String,dynamic> json)
  : _id = json['_id']??'',
  _name=json['name']??'',
  _description=json['description'],
  //_serial = json['serialNumber']??'',
  _ip = json['ip']??'',
  _port = json['port']??'',
  _status = json['status']??'';

   Map<String,dynamic> toJson()=>{
    '_id':_id,
    'name':_name,
    'description':_description,
    //'serialNumber':_serial,
    'ip':_ip,
    'port':_port,
    'status':_status,
  };

  String get id => _id;
  String get name => _name;
  String get description => _description;
  //String get serial => _serial;
  String get ip => _ip;
  String get port => _port;
  String get status => _status;
}
class EditHealthylDeviceModel extends EditBaseModel{
  String id='';
  String name ='';
  String description='';
  String serial ='';
  String ip ='';
  String port='';
  String status='';

  EditHealthylDeviceModel.fromModel(HealthylDeviceModel? device){
    id=device?.id ??'';
    name=device?.name??'';
    description=device?.description??'';
    //serial=device?.serial??'';
    ip=device?.ip ??'';
    port=device?.port ??'';
    status = device?.status ??'';
  }
  Map<String,dynamic> toEditInfoJson(){
    Map<String,dynamic> params={
      'serialNumber':serial,
      'ip':ip,
      'port':port,
      'status':status,
    };
    return params;
  }
}
class HealthylDeviceListModel extends BaseModel{
  List<HealthylDeviceModel> _data =[];
  Paging _metaData = Paging.fromJson({});

  HealthylDeviceListModel.fromJson(Map<String,dynamic> parsedJson){
    List<HealthylDeviceModel> tmp=[];
    for(int i=0;i<parsedJson['data'].length; i++){
      var result = BaseModel.fromJson<HealthylDeviceModel>(parsedJson['data'][i]);
      tmp.add(result);
    }
    _data=tmp;
    _metaData=Paging.fromJson(parsedJson['meta_data']);
  }
  List<HealthylDeviceModel> get records => _data;
  Paging get meta => _metaData;
}
class HistoryModel extends BaseModel{
  final String _id;
  final String _urlImage;
  final int _createdTime;
  final int _updatedTime;
  final String _gender;
  final String _status;
  final double _currTemperature;
  final String _channelName;
  final String _userUpdate;
  final String  _mask;
  final String _highTemperature;
  final String _region;

  HistoryModel.fromJson(Map<String,dynamic> json)
  : _id=json['_id']??'',
  _urlImage=json['imgUrl']??'',
  _createdTime=json['created_time']??0,
  _updatedTime=json['updated_time']??0,
  _gender=json['gender']??'',
  _status=json['status']??'',
  _currTemperature= json['currTemperature']??'',
  _channelName=json['channelName']??'',
  _userUpdate = json['user_updated']??'',
  _mask = json['mask']??'',
  _region = json['region']??'',
  _highTemperature=json['highTemperature']??'';

  Map<String,dynamic> toJson()=>{
    '_id': _id,
    'imgUrl': _urlImage,
    'created_time':_createdTime,
    'updated_time':_updatedTime,
    'gender': _gender,
    'status': _status,
    'currTemperature':_currTemperature,
    'channelName': _channelName,
    'user_name_updated': _userUpdate,
    'mask':_mask,
    'region':_region,
    'highTemperature':_highTemperature
  };

  String get id=>_id;
  String get urlImage => _urlImage;
  int get createTime => _createdTime;
  String get gender=>_gender;
  String get status =>_status;
  double get currTemperature => _currTemperature;
  String get channelName =>_channelName;
  String get userUpdate =>_userUpdate;
  String get mask => _mask;
  String get region=> _region;
  String get highTemperature => _highTemperature;
}
class EditHistoryModel extends EditBaseModel{
  String id ='';
  String eventID ='';
  String urlImage ='';
  int createTime=0;
  String gender='';
  String status='';
  String channelName='';
  String userUpdate='';

  EditHistoryModel.fromModel(HistoryModel? history){
    id=history?.id??'';
    urlImage=history?.urlImage??'';
    createTime=history?.createTime??0;
    gender=history?.gender??'';
    status=history?.status??'';
    channelName=history?.channelName??'';
    userUpdate=history?.userUpdate??'';
  }
  Map<String,dynamic> toEditInfoJson(){
    Map<String,dynamic> params={
      'eventId':eventID,
      'urlImage':urlImage,
      'gender':gender,
      'created_time':createTime,
      'status':status,
      'channelName':channelName,
      'userLastUpdate':userUpdate,
    };
    return params;
  }
}
class HistorylListModel extends BaseModel{
  List<HistoryModel> _data=[];
  Paging _metaData = Paging.fromJson({});

  HistorylListModel.fromJson(Map<String,dynamic> parsedJson){
    List<HistoryModel> tmp =[];
    for(int i = 0; i< parsedJson['data'].length;i++){
      var result = BaseModel.fromJson<HistoryModel>(parsedJson['data'][i]);
      tmp.add(result);
    }
    _data =tmp;
    _metaData = Paging.fromJson(parsedJson['meta_data']);
  }
  List<HistoryModel> get records => _data;
  Paging get meta => _metaData;
}
class DeviceModelID extends BaseModel{
  final DeviceInfoModel _DeviceInfo;

  DeviceModelID.fromJson(Map<String,dynamic> json)
    :_DeviceInfo=BaseModel.map(json: json, key: 'DeviceInfo');
  Map<String,dynamic> toJson()=> {
    'DeviceInfo':_DeviceInfo.toJson()
  };
  DeviceInfoModel get DeviceInfo =>_DeviceInfo;
}
class DeviceInfoModel extends BaseModel{
  final String _version;
  final String _xmlns;
  final String _deviceName;
  final String _deviceID;
  final String _deviceDescription;
  final String _deviceLocation;
  final String _systemContact;
  final String _model;
  final String _serialNumber;
  final String _macAddress;
  final String _firmwareVersion;
  final String _firmwareReleasedDate;
  final String _encoderVersion;
  final String _encoderReleasedDate;
  final String _bootVersion;
  final String _bootReleasedDate;
  final String _hardwareVersion;
  final String _deviceType;
  final String _telecontrolID;
  final String _supportBeep;
  final String _supportVideoLoss;
 final  String _cameraModuleVersion;

  DeviceInfoModel.fromJson(Map<String, dynamic> json) 
   : _version = json['version'],
    _xmlns = json['xmlns'],
    _deviceName = json['deviceName'],
    _deviceID = json['deviceID'],
    _deviceDescription = json['deviceDescription'],
    _deviceLocation = json['deviceLocation'],
    _systemContact = json['systemContact'],
    _model = json['model'],
    _serialNumber = json['serialNumber'],
    _macAddress = json['macAddress'],
    _firmwareVersion = json['firmwareVersion'],
    _firmwareReleasedDate = json['firmwareReleasedDate'],
    _encoderVersion = json['encoderVersion'],
    _encoderReleasedDate = json['encoderReleasedDate'],
    _bootVersion = json['bootVersion'],
    _bootReleasedDate = json['bootReleasedDate'],
    _hardwareVersion = json['hardwareVersion'],
    _deviceType = json['deviceType'],
    _telecontrolID = json['telecontrolID'],
    _supportBeep = json['supportBeep'],
    _supportVideoLoss = json['supportVideoLoss'],
    _cameraModuleVersion = json['cameraModuleVersion'];
  Map<String, dynamic> toJson()=> {
    'version': _version,
    'xmlns': _xmlns,
    'deviceName': _deviceName,
    'deviceID': _deviceID,
    'deviceDescription': _deviceDescription,
    'deviceLocation': _deviceLocation,
    'systemContact': _systemContact,
    'model': _model,
    'serialNumber': _serialNumber,
    'macAddress': _macAddress,
    'firmwareVersion': _firmwareVersion,
    'firmwareReleasedDate': _firmwareReleasedDate,
    'encoderVersion': _encoderVersion,
    'encoderReleasedDate': _encoderReleasedDate,
    'bootVersion': _bootVersion,
    'bootReleasedDate': _bootReleasedDate,
    'hardwareVersion': _hardwareVersion,
    'deviceType': _deviceType,
    'telecontrolID': _telecontrolID,
    'supportBeep': _supportBeep,
    'supportVideoLoss': _supportVideoLoss,
    'cameraModuleVersion': _cameraModuleVersion,
  };
  String get version => _version;
  String get xmlns => _xmlns;
  String get deviceName => _deviceName;
  String get deviceID => _deviceID;
  String get deviceDescription => _deviceDescription;
  String get deviceLocation => _deviceLocation;
  String get systemContact => _systemContact;
  String get model => _model;
  String get serialNumber=> _serialNumber;
  String get macAddress => _macAddress;
  String get firmwareVersion => _firmwareVersion;
  String get firmwareReleasedDate => _firmwareReleasedDate;
  String get encoderVersion => _encoderVersion;
  String get encoderReleasedDate => _encoderReleasedDate;
  String get bootVersion => _bootVersion;
  String get bootReleasedDate => _bootReleasedDate;
  String get hardwareVersion=>_hardwareVersion;
  String get deviceType => _deviceType;
  String get telecontrolID=> _telecontrolID;
  String get supportBeep=>_supportBeep;
  String get supportVideoLoss=>_supportVideoLoss;
  String get cameraModuleVersion=>_cameraModuleVersion;
}