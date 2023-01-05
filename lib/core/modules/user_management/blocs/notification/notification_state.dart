import 'package:equatable/equatable.dart';
import '../../../../../main.dart';
import '../../models/notification_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitialState extends NotificationState {}

class NotificationWaitingState extends NotificationState {}

class NotificationFetchDoneState extends NotificationState {
  final ApiResponse<NotificationListModel> data;

  const NotificationFetchDoneState(this.data);
  @override
  List<Object> get props => [data];
}

class NotificationFetchFailState extends NotificationState {
  final String? code;
  final String? message;

  const NotificationFetchFailState({
    this.code,
    this.message,
  });
  @override
  List<Object> get props => [code!, message!];
}

class NotificationExceptionState extends NotificationState {
  final String? code;
  final String? message;

  const NotificationExceptionState({
    this.code,
    this.message,
  });
  @override
  List<Object> get props => [code!, message!];
}

class ReadNotificationDoneState extends NotificationState {
  final ApiResponse<NotificationModel?> data;

  const ReadNotificationDoneState(this.data);
  @override
  List<Object> get props => [data];
}

class NotificationUnreadTotalDoneState extends NotificationState {
  final ApiResponse<UnreadTotalModel?> data;
  final String notiId;

  const NotificationUnreadTotalDoneState(this.data, this.notiId);
  @override
  List<Object> get props => [data, notiId];
}

class NotificationReadAllDoneState extends NotificationState {
  final ApiResponse<UnreadTotalModel?> data;

  const NotificationReadAllDoneState(this.data);
  @override
  List<Object> get props => [data];
}
