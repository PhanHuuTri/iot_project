// ignore: file_names
import 'package:flutter/material.dart';
import 'package:web_iot/core/modules/healthycheck/blocs/Healthy/healthy_bloc.dart';
import 'package:web_iot/core/modules/smart_parking/blocs/vehicle/vehicle_bloc.dart';
import 'package:web_iot/core/modules/smart_parking/models/vehicle_event_model.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';

import '../../../core/modules/healthycheck/models/healthy_model.dart';
import '../../../core/modules/user_management/models/notification_model.dart';
import '../../../core/rest/models/rest_api_response.dart';
import '../../../locales/i18n_key.dart';
import '../../../utils/screen_util.dart';
import 'package:intl/src/intl/date_format.dart';

class DialogNoti extends StatefulWidget {
  final NotificationModel notiItem;
  const DialogNoti({required this.notiItem, Key? key}) : super(key: key);

  @override
  State<DialogNoti> createState() => _DialogNotiState();
}

class _DialogNotiState extends State<DialogNoti> {
  final _healthyBloc = HealthyBloc();
  final _vehicleBloc = VehicleBloc();

  @override
  void dispose() {
    _healthyBloc.dispose();
    _vehicleBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.notiItem.category == 'Smart Parking') {
      debugPrint(widget.notiItem.data.idParking);
      return parkingdialog();
    } else if (widget.notiItem.category == 'Healthy Check') {
      return healthydialog();
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: JTCircularProgressIndicator(
          size: 30,
          strokeWidth: 2.0,
          color: Theme.of(context).textTheme.button!.color!,
        ),
      ),
    );
  }
  Widget parkingdialog(){
    return Material(
        color: Colors.black.withOpacity(0.5),
        child: SafeArea(
          child: Stack(children: [
            SizedBox(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: Colors.white),
                width: MediaQuery.of(context).size.width * 0.3,
                height: 300,
                child: FutureBuilder(
                    future: _vehicleBloc.fetchDataByNotiId(widget.notiItem.data.idParking),
                    builder: (context, AsyncSnapshot<NotiDetailModel> snapshot) {
                      //debugPrint('test'+snapshot.data!.body.vi);
                      if (snapshot.hasData) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25),
                                        bottomLeft: Radius.circular(35),
                                        bottomRight: Radius.circular(35))),
                                width: MediaQuery.of(context).size.width,
                                height: 100,
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    widget.notiItem.title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            const TextSpan(
                                                text: '- Sự kiện: ',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: snapshot.data!.body.vi,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontStyle:
                                                        FontStyle.italic))
                                          ]),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: RichText(
                                            text: TextSpan(children: [
                                          const TextSpan(
                                              text: '- Read: ',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text: widget.notiItem.read == true
                                                  ? 'Đã có người đọc'
                                                  : 'Chưa có người đọc',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontStyle: FontStyle.italic)),
                                        ]))),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: RichText(
                                            text: TextSpan(children: [
                                          const TextSpan(
                                              text:
                                                  '- Thời gian sự kiện diễn ra: ',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text: _parseDisplayedDateTime(
                                                  widget.notiItem.createdTime
                                                      .toString()),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontStyle: FontStyle.italic))
                                        ]))),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            const TextSpan(
                                                text: '- Trạng thái sự kiện: ',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: widget.notiItem.isValid==true?'Hợp lệ':'Không hợp lệ',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontStyle:
                                                        FontStyle.italic))
                                          ]),
                                        )),
                                    SizedBox(child: Container())
                                  ],
                                ),
                              ),
                            ]);
                      } else {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: JTCircularProgressIndicator(
                              size: 30,
                              strokeWidth: 2.0,
                              color: Theme.of(context).textTheme.button!.color!,
                            ),
                          ),
                        );
                      }
                    }),
              ),
            )
          ]),
        ));
  }

  Widget healthydialog() {
    return Material(
        color: Colors.black.withOpacity(0.5),
        child: SafeArea(
          child: Stack(children: [
            SizedBox(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: Colors.white),
                width: MediaQuery.of(context).size.width * 0.3,
                height: 300,
                child: FutureBuilder(
                    future: _healthyBloc
                        .fetchDataByHistoryId(widget.notiItem.data.idHealthy),
                    builder: (context, AsyncSnapshot<HistoryModel> snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25),
                                        bottomLeft: Radius.circular(35),
                                        bottomRight: Radius.circular(35))),
                                width: MediaQuery.of(context).size.width,
                                height: 100,
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    widget.notiItem.title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            const TextSpan(
                                                text: '- Gender: ',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: snapshot.data!.gender,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontStyle:
                                                        FontStyle.italic))
                                          ]),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: RichText(
                                            text: TextSpan(children: [
                                          const TextSpan(
                                              text: '- Camera: ',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text:snapshot.data!.channelName,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontStyle: FontStyle.italic)),
                                        ]))),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: RichText(
                                            text: TextSpan(children: [
                                          const TextSpan(
                                              text:
                                                  '- Thời gian sự kiện diễn ra: ',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text: _parseDisplayedDateTime(
                                                  snapshot.data!.createTime
                                                      .toString()),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontStyle: FontStyle.italic))
                                        ]))),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            const TextSpan(
                                                text: '- Mask: ',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: snapshot.data!.mask=='no'?'Không khẩu trang':'Có khẩu trang',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontStyle:
                                                        FontStyle.italic))
                                          ]),
                                        )),
                                        Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            const TextSpan(
                                                text: '- High Temperature: ',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: snapshot.data!.highTemperature=='no'?'Bình thường':'Quá nhiệt',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontStyle:
                                                        FontStyle.italic))
                                          ]),
                                        )),
                                    SizedBox(child: Container())
                                  ],
                                ),
                              ),
                            ]);
                      } else {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: JTCircularProgressIndicator(
                              size: 30,
                              strokeWidth: 2.0,
                              color: Theme.of(context).textTheme.button!.color!,
                            ),
                          ),
                        );
                      }
                    }),
              ),
            )
          ]),
        ));
  }

  String _parseDisplayedDateTime(String? value) {
    ScreenUtil.init(context);
    //final format =ScreenUtil.t(I18nKey.formatDMY)! + ', HH:mm:ss';
    String _displayedValue = '';
    if (value != null && value.isNotEmpty) {
      final _date =
          DateTime.fromMillisecondsSinceEpoch(int.parse(value));
          final _dateTimeLocal = _date.toLocal();
      final _displayText =
          DateFormat(ScreenUtil.t(I18nKey.formatDMY)! + ', HH:mm')
              .format(_dateTimeLocal);
      return _displayText;
    }
    return '';
  }
}
