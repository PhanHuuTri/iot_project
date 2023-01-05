import 'package:flutter/material.dart';
import 'package:web_iot/core/modules/smart_parking/models/vehicle_event_model.dart';
import 'package:web_iot/main.dart';
import 'package:intl/intl.dart';

class DialogVehicleEvent extends StatefulWidget {
  final VehicleEventModel vehicleEvent;
  const DialogVehicleEvent({Key? key, required this.vehicleEvent})
      : super(key: key);

  @override
  State<DialogVehicleEvent> createState() => _DialogVehicleEventState();
}

class _DialogVehicleEventState extends State<DialogVehicleEvent> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 4;
    return Material(
      color: Colors.transparent,
      child: SafeArea(
          child: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: width,
              child: AspectRatio(
                aspectRatio: 1 / 1.35,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            ScreenUtil.t(I18nKey.details)!,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )),
                      const Divider(
                        color: Colors.grey,
                        height: 2,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            ScreenUtil.t(I18nKey.image)!,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: ClipRRect(
                          child: Image.asset(widget.vehicleEvent.cardGroupName=='oto'?"assets/images/car.jpg":"assets/images/bike.jpg",
                              width: width - 20,
                              height: width * 0.60,
                              fit: BoxFit.cover),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: width * 0.4 - 5,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: ScreenUtil.t(
                                                I18nKey.licensePlate),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold))
                                      ])),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: ScreenUtil.t(I18nKey.timeIn),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold))
                                      ])),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: ScreenUtil.t(I18nKey.timeOut),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold))
                                      ])),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: ScreenUtil.t(
                                                I18nKey.vehicleType),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold))
                                      ])),
                                    ),
                                  ]),
                            ),
                            SizedBox(
                              width: width * 0.6 - 15,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: widget.vehicleEvent
                                                        .plateNumber ==
                                                    ''
                                                ? '51A-34512'
                                                : widget
                                                    .vehicleEvent.plateNumber,
                                            style: const TextStyle(
                                                color: Colors.black))
                                      ])),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: _parseDisplayedDateTime(
                                                widget.vehicleEvent.dateTimeIn),
                                            style: const TextStyle(
                                                color: Colors.black))
                                      ])),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: _parseDisplayedDateTime(widget
                                                .vehicleEvent.dateTimeOut),
                                            style: const TextStyle(
                                                color: Colors.black))
                                      ])),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: widget
                                                .vehicleEvent.cardGroupName!='oto'?ScreenUtil.t(I18nKey.bikeAndAnotherVehicle)!:ScreenUtil.t(I18nKey.car)!,
                                            style: const TextStyle(
                                                color: Colors.black))
                                      ])),
                                    ),
                                  ]),
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.only(right: 10,bottom: 5),
                          width: 100,
                          child: ElevatedButton(
                            style: const ButtonStyle(backgroundColor:MaterialStatePropertyAll<Color>(Colors.green) ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: Center(child: Text(ScreenUtil.t(I18nKey.back)!,style:const TextStyle(color: Colors.white),),
                            ),
                          ),
                      ),
                        ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  String _parseDisplayedDateTime(String? value) {
    ScreenUtil.init(context);
    if (value != null && value.isNotEmpty) {
      final _date =
          DateTime.fromMillisecondsSinceEpoch(int.parse(value) * 1000);
      final _displayText =
          DateFormat(ScreenUtil.t(I18nKey.formatDMY)! + ', HH:mm')
              .format(_date);
      return _displayText;
    }
    return '';
  }
}
