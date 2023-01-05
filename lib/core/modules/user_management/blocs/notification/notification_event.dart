import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class NotificationFetchEvent extends NotificationEvent {
  final Map<String, dynamic> params;

  const NotificationFetchEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class ReadNotification extends NotificationEvent {
  final Map<String, dynamic> params;

  const ReadNotification({required this.params});

  @override
  List<Object> get props => [params];
}

class NotificationUnreadTotal extends NotificationEvent {
  final String notiId;

  const NotificationUnreadTotal({this.notiId = ''});

  @override
  List<Object> get props => [notiId];
}

class ReadAllNotification extends NotificationEvent {}
