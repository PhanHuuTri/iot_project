import 'package:web_iot/core/logger/logger.dart';
import 'package:web_iot/core/modules/face_recog/models/event_model.dart';
import 'package:web_iot/core/modules/smart_parking/models/barrier_model.dart';
import 'package:web_iot/core/modules/smart_parking/models/report_full_slot.dart';
import 'package:web_iot/core/modules/smart_parking/models/webview_model.dart';
// import 'package:web_iot/screens/modules/healthy_check/tab_healthycheck/healthy_list.dart';
import '../../authentication/models/status.dart';
import '../../modules/face_recog/models/dashboard_model.dart';
import '../../modules/face_recog/models/device_model.dart';
import '../../modules/face_recog/models/door_model.dart';
import '../../modules/face_recog/models/face_user_model.dart';
import '../../modules/smart_parking/models/empty_slot_model.dart';
import '../../modules/smart_parking/models/report_in_out_model.dart';
import '../../modules/smart_parking/models/vehicle_event_model.dart';
import '../../modules/user_management/models/account_model.dart';
import '../../modules/user_management/models/module_model.dart';
import '../../modules/user_management/models/notification_model.dart';
import '../../modules/user_management/models/role_model.dart';
import '../../modules/healthycheck/models/healthy_model.dart';

class ApiError implements Exception {
  String _errorCode = '';
  String _errorMessage = '';

  ApiError.fromJson(Map<String, dynamic>? parsedJson) {
    if (parsedJson?['error_code'] != null) {
      _errorCode = parsedJson?['error_code']?.toString() ?? '';
    }
    _errorMessage = parsedJson?['error_message'] ?? '';
  }

  String get errorCode => _errorCode;
  String get errorMessage => _errorMessage;

  @override
  String toString() {
    return _errorMessage;
  }
}

class ApiResponse<T> {
  ApiError? _error;
  T? _model;

  ApiResponse(T? m, ApiError? e) {
    _model = m;
    _error = e;
  }

  ApiError? get error => _error;
  T? get model => _model;
}

class BaseModel {
  static T fromJson<T extends BaseModel>(Map<String, dynamic> json) {
    // Models
    if (T == AccountModel) {
      return AccountModel.fromJson(json) as T;
    }
    if (T == AccountListModel) {
      return AccountListModel.fromJson(json) as T;
    }
    // Healthy 
    if(T == HealthylModel){
      return HealthylModel.fromJson(json) as T;
    }
    if(T == HealthylListModel){
      return HealthylListModel.fromJson(json) as T;
    }

    if(T == HealthylDeviceModel){
      return HealthylDeviceModel.fromJson(json) as T;
    }
    if(T == HealthylDeviceListModel){
      return HealthylDeviceListModel.fromJson(json) as T;
    }
    // Healthy History
    if(T == HistoryModel){
      return HistoryModel.fromJson(json) as T;
    }
    if(T == DeviceModelID){
      return DeviceModelID.fromJson(json) as T;
    }
    if(T == DeviceInfoModel){
      return DeviceInfoModel.fromJson(json) as T;
    }
    if(T == HistorylListModel){
      return HistorylListModel.fromJson(json) as T;
    }
    
    //Role
    if (T == RoleModel) {
      return RoleModel.fromJson(json) as T;
    }
    if (T == RoleListModel) {
      return RoleListModel.fromJson(json) as T;
    }
    //Notification
    if (T == NotiDetailModel) {
      return NotiDetailModel.fromJson(json) as T;
    }
    if (T == LanguageModel) {
      return LanguageModel.fromJson(json) as T;
    }
    if (T == NotificationModel) {
      return NotificationModel.fromJson(json) as T;
    }
    if (T == NotificationListModel) {
      return NotificationListModel.fromJson(json) as T;
    }
    if (T == UserIdHealthyModel) {
      return UserIdHealthyModel.fromJson(json) as T;
    }
    // Vehicle
    
    if (T == VehicleEventModel) {
      return VehicleEventModel.fromJson(json) as T;
    }
    if (T == VehicleEventListModel) {
      return VehicleEventListModel.fromJson(json) as T;
    }
    if (T == Status) {
      return Status.fromJson(json) as T;
    }
    if (T == MotoEmptySlotModel) {
      return MotoEmptySlotModel.fromJson(json) as T;
    }
    if (T == MotoEmptySpaceModel) {
      return MotoEmptySpaceModel.fromJson(json) as T;
    }
    if (T == CarEmptySlotModel) {
      return CarEmptySlotModel.fromJson(json) as T;
    }
    if (T == CarEmptySpaceModel) {
      return CarEmptySpaceModel.fromJson(json) as T;
    }
    if (T == ReportInOutModel) {
      return ReportInOutModel.fromJson(json) as T;
    }
    if (T == InOutModel) {
      return InOutModel.fromJson(json) as T;
    }
    if (T == VehicleModel) {
      return VehicleModel.fromJson(json) as T;
    }
    if (T == ModuleModel) {
      return ModuleModel.fromJson(json) as T;
    }
    if (T == ModuleListModel) {
      return ModuleListModel.fromJson(json) as T;
    }
    if (T == PermissionModel) {
      return PermissionModel.fromJson(json) as T;
    }

    if (T == DoorModel) {
      return DoorModel.fromJson(json) as T;
    }
    if (T == EntryDeviceIdModel) {
      return EntryDeviceIdModel.fromJson(json) as T;
    }
    if (T == DoorGroupIdModel) {
      return DoorGroupIdModel.fromJson(json) as T;
    }
    if (T == ExitButtonInputIdModel) {
      return ExitButtonInputIdModel.fromJson(json) as T;
    }
    if (T == RelayOutputIdModel) {
      return RelayOutputIdModel.fromJson(json) as T;
    }
    if (T == DeviceIdModel) {
      return DeviceIdModel.fromJson(json) as T;
    }
    if (T == DoorListModel) {
      return DoorListModel.fromJson(json) as T;
    }
    if (T == EventModel) {
      return EventModel.fromJson(json) as T;
    }
    if (T == EventListModel) {
      return EventListModel.fromJson(json) as T;
    }
    if (T == EventTypeIdModel) {
      return EventTypeIdModel.fromJson(json) as T;
    }
    if (T == EventUserIdModel) {
      return EventUserIdModel.fromJson(json) as T;
    }
    if (T == EventUserGroupIdModel) {
      return EventUserGroupIdModel.fromJson(json) as T;
    }
    if (T == EventDeviceIdModel) {
      return EventDeviceIdModel.fromJson(json) as T;
    }
    if (T == EventTimeZoneModel) {
      return EventTimeZoneModel.fromJson(json) as T;
    }

    if (T == DeviceModel) {
      return DeviceModel.fromJson(json) as T;
    }
    if (T == DeviceListModel) {
      return DeviceListModel.fromJson(json) as T;
    }
    if (T == DeviceTypeIdModel) {
      return DeviceTypeIdModel.fromJson(json) as T;
    }
    if (T == DeviceRs485Model) {
      return DeviceRs485Model.fromJson(json) as T;
    }
    if (T == DeviceGroupIdModel) {
      return DeviceGroupIdModel.fromJson(json) as T;
    }
    if (T == DeviceVersionModel) {
      return DeviceVersionModel.fromJson(json) as T;
    }
    if (T == DeviceLanModel) {
      return DeviceLanModel.fromJson(json) as T;
    }
    if (T == TnaModel) {
      return TnaModel.fromJson(json) as T;
    }
    if (T == TnaKeyModel) {
      return TnaKeyModel.fromJson(json) as T;
    }
    if (T == FaceUserModel) {
      return FaceUserModel.fromJson(json) as T;
    }
    if (T == FaceUserGroupIdModel) {
      return FaceUserGroupIdModel.fromJson(json) as T;
    }
    if (T == FaceUserListModel) {
      return FaceUserListModel.fromJson(json) as T;
    }
    if (T == DashboardModel) {
      return DashboardModel.fromJson(json) as T;
    }
    if (T == DashboardStatusModel) {
      return DashboardStatusModel.fromJson(json) as T;
    }
    if (T == DashboardUser) {
      return DashboardUser.fromJson(json) as T;
    }
    if (T == DashboardDevices) {
      return DashboardDevices.fromJson(json) as T;
    }
    if (T == DashboardDoors) {
      return DashboardDoors.fromJson(json) as T;
    }
    if (T == DashboardAccessGroups) {
      return DashboardAccessGroups.fromJson(json) as T;
    }
    if (T == DashboardFingerTempletes) {
      return DashboardFingerTempletes.fromJson(json) as T;
    }
    if (T == DashboardCards) {
      return DashboardCards.fromJson(json) as T;
    }
    if (T == DashboardZones) {
      return DashboardZones.fromJson(json) as T;
    }
    if (T == DashboardFaces) {
      return DashboardFaces.fromJson(json) as T;
    }
    if (T == DashboardAlertStatisticModel) {
      return DashboardAlertStatisticModel.fromJson(json) as T;
    }
    if (T == DashboardNoticeModel) {
      return DashboardNoticeModel.fromJson(json) as T;
    }
    if (T == DashboardAlertModel) {
      return DashboardAlertModel.fromJson(json) as T;
    }
    if (T == MultipleLanguagesBodyModel) {
      return MultipleLanguagesBodyModel.fromJson(json) as T;
    }
    if (T == ListDeviceResponseModel) {
      return ListDeviceResponseModel.fromJson(json) as T;
    }
    if (T == DeviceResponseModel) {
      return DeviceResponseModel.fromJson(json) as T;
    }
    if (T == ListDoorControlModel) {
      return ListDoorControlModel.fromJson(json) as T;
    }
    if (T == DoorControlModel) {
      return DoorControlModel.fromJson(json) as T;
    }
    if (T == AccessGroupModel) {
      return AccessGroupModel.fromJson(json) as T;
    }
    if (T == ScheduleModel) {
      return ScheduleModel.fromJson(json) as T;
    }
    if (T == DoorStatusModel) {
      return DoorStatusModel.fromJson(json) as T;
    }
    if (T == AccessLevelsModel) {
      return AccessLevelsModel.fromJson(json) as T;
    }
    if (T == FaceRoleModel) {
      return FaceRoleModel.fromJson(json) as T;
    }
    if (T == ListFaceFaceRoleModel) {
      return ListFaceFaceRoleModel.fromJson(json) as T;
    }
    if (T == AlertStatisticModel) {
      return AlertStatisticModel.fromJson(json) as T;
    }
    if (T == AlertEventModel) {
      return AlertEventModel.fromJson(json) as T;
    }
    if (T == AlertEventTypeIdModel) {
      return AlertEventTypeIdModel.fromJson(json) as T;
    }
    if (T == UnreadTotalModel) {
      return UnreadTotalModel.fromJson(json) as T;
    }
    if (T == ReportFullSlotModel) {
      return ReportFullSlotModel.fromJson(json) as T;
    }
    //Alertmodel
    if(T== EventIdModel){
      return EventIdModel.fromJson(json) as T;
    }
    if(T== AlertModel){
      return AlertModel.fromJson(json) as T;
    }
    if(T== DeviceAlert){
      return DeviceAlert.fromJson(json) as T;
    }
    if(T== EventTypeAlert){
      return EventTypeAlert.fromJson(json) as T;
    }
    //parking
    if(T== CarEmptySlot){
      return CarEmptySlot.fromJson(json) as T;
    }
    if(T== WebViewModel){
      return WebViewModel.fromJson(json) as T;
    }
    if(T== BarrierModel){
      return BarrierModel.fromJson(json) as T;
    }
    if(T== EmptySlotModel){
      return EmptySlotModel.fromJson(json) as T;
    }
    if(T== RegionModel){
      return RegionModel.fromJson(json) as T;
    }
    if(T== EmptySlotRegionModel){
      return EmptySlotRegionModel.fromJson(json) as T;
    }
    


    logError("Unknown BaseModel class: $T");
    throw Exception("Unknown BaseModel class: $T");
  }

  static List<T> mapList<T extends BaseModel>({
    required Map<String, dynamic> json,
    required String key,
    String defaultKey = '_id',
  }) {
    final _results = <T>[];
    if (json[key] != null && json[key] is List<dynamic>) {
      for (var val in json[key]) {
        if (val is String) {
          _results.add(BaseModel.fromJson<T>({defaultKey: val}));
        } else if (val is Map<String, dynamic>) {
          _results.add(BaseModel.fromJson<T>(val));
        } else {
          _results.add(BaseModel.fromJson<T>({}));
        }
      }
    }
    return _results;
  }

  static T listDynamic<T extends BaseModel>(List<dynamic> list) {
    if (T == ListRoleModel) {
      return ListRoleModel.listDynamic(list) as T;
    }
    if (T == ListCarEmptySlotModel) {
      return ListCarEmptySlotModel.listDynamic(list) as T;
    }
    if (T == ListMotoAndBikeEmptySlotModel) {
      return ListMotoAndBikeEmptySlotModel.listDynamic(list) as T;
    }
    if (T == ListMotoEmptySlotModel) {
      return ListMotoEmptySlotModel.listDynamic(list) as T;
    }
    if (T == ListReportInOutModel) {
      return ListReportInOutModel.listDynamic(list) as T;
    }
    if (T == ListVehicleEventModel) {
      return ListVehicleEventModel.listDynamic(list) as T;
    }
    if (T == ListModuleModel) {
      return ListModuleModel.listDynamic(list) as T;
    }

    logError("Unknown BaseModel class: $T");
    throw Exception("Unknown BaseModel class: $T");
  }

  static T map<T extends BaseModel>({
    required Map<String, dynamic> json,
    required String key,
    String defaultKey = '_id',
  }) {
    if (json.containsKey(key)) {
      final _val = json[key];
      if (_val is String) {
        return BaseModel.fromJson<T>({defaultKey: _val});
      } else if (_val is Map<String, dynamic>) {
        return BaseModel.fromJson<T>(_val);
      }
    }
    return BaseModel.fromJson({});
  }
  static T mapuser<T extends BaseModel>({
    required Map<String, dynamic> json,
    required String key,
    String defaultKey = 'user_updated',
  }) {
    if (json.containsKey(key)) {
      final _val = json[key];
      if (_val is String) {
        return BaseModel.fromJson<T>({defaultKey: _val});
      } else if (_val is Map<String, dynamic>) {
        return BaseModel.fromJson<T>(_val);
      }
    }
    return BaseModel.fromJson({});
  }
}

class EditBaseModel {
  static T fromModel<T extends EditBaseModel>(BaseModel model) {
    if (T == EditAccountModel) {
      return EditAccountModel.fromModel(model as AccountModel) as T;
    }
    if (model is EditRoleModel) {
      return EditRoleModel.fromModel(model as RoleModel) as T;
    }
    if (T == EditVehicleModel) {
      return EditVehicleModel.fromModel(model as VehicleEventModel) as T;
    }
    if (T == EditFaceRoleModel) {
      return EditFaceRoleModel.fromModel(model as FaceUserModel) as T;
    }
    if (T == EditNotiDetailModel) {
      return EditNotiDetailModel.fromJson(model as NotiDetailModel) as T;
    }
    if (model is EditBarrierModel) {
      return EditBarrierModel.fromModel(model as BarrierModel) as T;
    }
    logError("Unknown EditBaseModel class: $T");
    throw Exception("Unknown EditBaseModel class: $T");
  }

  static Map<String, dynamic> toCreateJson(EditBaseModel model) {
    if (model is EditAccountModel) {
      return model.toCreateJson();
    }
    if (model is EditRoleModel) {
      return model.toCreateJson();
    }
    return {};
  }

  static Map<String, dynamic> toEditInfoJson(EditBaseModel model) {
    if (model is EditAccountModel) {
      return model.toEditInfoJson();
    }
    return {};
  }

  static Map<String, dynamic> toEditJson(EditBaseModel model) {
    if (model is EditAccountModel) {
      return model.toEditJson();
    }
    if (model is EditRoleModel) {
      return model.toEditJson();
    }
    if (model is EditVehicleModel) {
      return model.toEditJson();
    }
    if (model is EditFaceRoleModel) {
      return model.toEditJson();
    }
    return {};
  }
}
