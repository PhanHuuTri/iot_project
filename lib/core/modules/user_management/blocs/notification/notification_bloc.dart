import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:web_iot/core/modules/user_management/blocs/notification/notification_bloc_public.dart';
import '../../models/notification_model.dart';
import '../../resources/notification/notification_repository.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitialState());

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    try {
      if (event is NotificationFetchEvent) {
        yield NotificationWaitingState();
        final res = await NotificationRepository()
            .fetchAllData<NotificationListModel>(params: event.params);
        // ignore: unnecessary_null_comparison
        if (res != null) {
          yield NotificationFetchDoneState(res);
        } else {
          yield const NotificationFetchFailState(message: 'Lỗi không xác định');
        }
      }
      if (event is ReadNotification) {
        final res = await NotificationRepository()
            .readNoti<NotificationModel>(params: event.params);
        // ignore: unnecessary_null_comparison
        if (res != null) {
          yield ReadNotificationDoneState(res);
        } else {
          yield const NotificationFetchFailState(message: 'Lỗi không xác định');
        }
      }
      if (event is ReadAllNotification) {
        final res =
            await NotificationRepository().notiReadAll<UnreadTotalModel>();
        // ignore: unnecessary_null_comparison
        if (res != null) {
          yield NotificationReadAllDoneState(res);
        } else {
          yield const NotificationFetchFailState(message: 'Lỗi không xác định');
        }
      }
      if (event is NotificationUnreadTotal) {
        final res =
            await NotificationRepository().notiUnreadTotal<UnreadTotalModel>();
        // ignore: unnecessary_null_comparison
        if (res != null) {
          yield NotificationUnreadTotalDoneState(res, event.notiId);
        } else {
          yield const NotificationFetchFailState(message: 'Lỗi không xác định');
        }
      }
    } catch (err) {
      yield const NotificationExceptionState(message: 'Lỗi không xác định');
    }
  }
}
