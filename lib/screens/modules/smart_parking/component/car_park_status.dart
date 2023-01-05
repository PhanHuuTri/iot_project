import 'package:flutter/material.dart';
import 'package:web_iot/core/modules/smart_parking/blocs/barrier_bloc/barrier_bloc.dart';
import 'package:web_iot/core/modules/smart_parking/blocs/empty_slot/empty_slot_bloc.dart';
import 'package:web_iot/core/modules/smart_parking/blocs/report_in_out/report_in_out_bloc.dart';
import 'package:web_iot/core/modules/smart_parking/models/barrier_model.dart';
import 'package:web_iot/core/modules/smart_parking/models/empty_slot_model.dart';
import 'package:web_iot/main.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';
import 'dart:async';

class CarParkStatus extends StatefulWidget {
  final Function(int) changeTab;
  final EmptySlotBloc motoEmptySlotBloc;
  final EmptySlotBloc carEmptySlotBloc;
  final EmptySlotBloc carAndBikeEmptySlotBloc;
  final BarrierBloc barrierBloc;
  final ReportInOutBloc reportInOutBloc;
  final Function() fetchCarAndBike;
  final Function(String) fetchBarrier;
  const CarParkStatus(
      {Key? key,
      required this.changeTab,
      required this.motoEmptySlotBloc,
      required this.carEmptySlotBloc,
      required this.reportInOutBloc,
      required this.fetchBarrier,
      required this.barrierBloc,
      required this.carAndBikeEmptySlotBloc,
      required this.fetchCarAndBike})
      : super(key: key);

  @override
  State<CarParkStatus> createState() => _CarParkStatusState();
}

class _CarParkStatusState extends State<CarParkStatus> {
  final _padding = 16.0;
  int? Selecteid;
  Timer? _closeTimer;
  int _timer = 5;
  @override
  void initState() {
    widget.fetchCarAndBike;
    super.initState();
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.carAndBikeEmptySlotBloc.allMotoAndBike,
      builder: (context,
          AsyncSnapshot<ApiResponse<ListMotoAndBikeEmptySlotModel?>> snapshot) {
        if (snapshot.hasData) {
          List<EmptySlotModel> regions = snapshot.data!.model!.records;
          EmptySlotModel b1 = regions.firstWhere(
            (element) => element.floorName == "b1",
          );
          EmptySlotModel b2 = regions.firstWhere(
            (element) => element.floorName == "b2",
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildTabButton(),
                  ],
                ),
              ),
              parkSelecttabbasment == 0
                  ? _buildScreenB1(b1.regions,b1.floorName)
                  : _buildScreenB2(b2.regions,b2.floorName)
            ],
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            height: 48,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                snapshot.error.toString(),
              ),
            ),
          );
        }
        return const Align(
          alignment: Alignment.centerLeft,
          child: JTCircularProgressIndicator(
            size: 20,
            strokeWidth: 1.5,
            color: Colors.green,
          ),
        );
      },
    );
  }

  Widget _buildScreenB2(List<RegionModel> b2s,String floor) {
    return Column(
      children: [
        _mapBuild('assets/images/b2.jpg'),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 45, bottom: 20),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              ScreenUtil.t(I18nKey.carParkStatus)!,
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: _parkingStatus(
            title: ScreenUtil.t(I18nKey.car)!,
            child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _totalnumber(b2s, 'available', 100),
                    Wrap(
                      spacing: 24,
                      runSpacing: 16,
                      children: [
                        for (var b2 in b2s)
                        
                          _carEmptySlotStatus(
                              regionModel: b2, status: 'available', floor: floor),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    _totalnumber(b2s, 'unavailable', 100),
                    Wrap(
                      spacing: 24,
                      runSpacing: 16,
                      children: [
                        for (var b2 in b2s)
                        b2.emptySlots.where((element) => element.status=='unavailable',).toList().isEmpty?const SizedBox()
                          :_carEmptySlotStatus(
                              regionModel: b2, status: 'unavailable', floor:floor ),
                      ],
                    ),
                  ],
                )),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        //   child: _parkingStatus(
        //     title: ScreenUtil.t(I18nKey.bikeAndAnotherVehicle)!,
        //     child: Padding(
        //       padding: const EdgeInsets.only(top: 8.0),
        //       child: StreamBuilder(
        //           stream: widget.motoEmptySlotBloc.allMoto,
        //           builder: (context,
        //               AsyncSnapshot<ApiResponse<ListMotoEmptySlotModel?>>
        //                   snapshot) {
        //             if (snapshot.hasData) {
        //               final motoEmptySlots = snapshot.data!.model!.records;
        //               if (motoEmptySlots.isNotEmpty) {
        //                 return Wrap(
        //                   spacing: 24,
        //                   runSpacing: 16,
        //                   children: [
        //                     for (var emptySlot in motoEmptySlots)
        //                       _motoEmptySlotStatus(motoEmptySlot: emptySlot),
        //                   ],
        //                 );
        //               }
        //               return SizedBox(
        //                 height: 48,
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: Center(
        //                     child: Text(
        //                       ScreenUtil.t(I18nKey.noData)!,
        //                     ),
        //                   ),
        //                 ),
        //               );
        //             }
        //             return Align(
        //               alignment: Alignment.centerLeft,
        //               child: JTCircularProgressIndicator(
        //                 size: 20,
        //                 strokeWidth: 1.5,
        //                 color: AppColor.primary,
        //               ),
        //             );
        //           }),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildScreenB1(List<RegionModel> b1s,String floor) {
    return Column(
      children: [
        _mapBuild('assets/images/b1.jpg'),
        _barrierBuild(ScreenUtil.t(I18nKey.barriercontrol)!),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              ScreenUtil.t(I18nKey.carParkStatus)!,
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: _parkingStatus(
            title: ScreenUtil.t(I18nKey.car)!,
            child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _totalnumber(b1s, 'available', 11),
                    Wrap(
                      spacing: 24,
                      runSpacing: 16,
                      children: [
                        for (var b1 in b1s)
                          _carEmptySlotStatus(
                              regionModel: b1, status: 'available', floor: floor),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    _totalnumber(b1s, 'unavailable', 11),
                    Wrap(
                      spacing: 24,
                      runSpacing: 16,
                      children: [
                        for (var b1 in b1s)
                        b1.emptySlots.where((element) => element.status=='unavailable',).toList().isEmpty?const SizedBox()
                          :_carEmptySlotStatus(
                              regionModel: b1, status: 'unavailable', floor:floor ),
                      ],
                    ),
                  ],
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: _parkingStatus(
            title: ScreenUtil.t(I18nKey.bikeAndAnotherVehicle)!,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: StreamBuilder(
                  stream: widget.motoEmptySlotBloc.allMoto,
                  builder: (context,
                      AsyncSnapshot<ApiResponse<ListMotoEmptySlotModel?>>
                          snapshot) {
                    if (snapshot.hasData) {
                      final motoEmptySlots = snapshot.data!.model!.records;
                      if (motoEmptySlots.isNotEmpty) {
                        return Wrap(
                          spacing: 24,
                          runSpacing: 16,
                          children: [
                            for (var emptySlot in motoEmptySlots)
                              _motoEmptySlotStatus(motoEmptySlot: emptySlot),
                          ],
                        );
                      }
                      return SizedBox(
                        height: 48,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              ScreenUtil.t(I18nKey.noData)!,
                            ),
                          ),
                        ),
                      );
                    }
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: JTCircularProgressIndicator(
                        size: 20,
                        strokeWidth: 1.5,
                        color: AppColor.primary,
                      ),
                    );
                  }),
            ),
          ),
        ),
      ],
    );
  }

  void _timerMessage() {
    _timer = 5;
    _closeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timer == 0) {
        timer.cancel();
      } else {
        setState(() {
          _timer--;
        });
      }
    });
  }

  _buildTabButton() {
    final tabs = [ScreenUtil.t(I18nKey.b1)!, ScreenUtil.t(I18nKey.b2)!];

    return LayoutBuilder(builder: (context, size) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var tab in tabs)
            LayoutBuilder(builder: (context, size) {
              final tabIndex = tabs.indexOf(tab);
              final enable = parkSelecttabbasment == tabIndex;

              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: enable ? AppColor.primary : Colors.transparent,
                    border: Border.all(
                      color: enable ? AppColor.primary : AppColor.subTitle,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(
                        child: Text(
                          tab,
                          style: TextStyle(
                            color: enable ? AppColor.white : AppColor.subTitle,
                          ),
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(50),
                    hoverColor: AppColor.secondary2,
                    onTap: () {
                      setState(() {
                        parkSelecttabbasment = tabIndex;
                        // if (parkSelectedList == 0) {
                        //   widget.fetchParkingListData(
                        //     1,
                        //     from: _fromDate,
                        //     to: _toDate,
                        //   );
                        // } else {
                        //   widget.fetchParkingExceptionData(
                        //     1,
                        //     from: _fromDate,
                        //     to: _toDate,
                        //   );
                        // }
                      });
                    },
                  ),
                ),
              );
            }),
        ],
      );
    });
  }

  Widget _mapBuild(String urlmap) {
    final width = MediaQuery.of(context).size.width ;
    return InkWell(
      onTap: () => showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
              ),
              SizedBox(
                width: width-200,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: SizedBox(
                    width: width-200,
                    child: ClipRRect(
                        child: Image.asset(
                      urlmap,
                      fit: BoxFit.cover,
                      width: width-200,
                    )),
                  ),
                ),
              ),
              
            ],
          );
        },
      ),
      child: Container(
        padding:
            const EdgeInsets.only(left: 50, right: 50, top: 20, bottom: 20),
        width: width-800,
        child: ClipRRect(
            child: Image.asset(
          urlmap,
          fit: BoxFit.cover,
          width: width- 800,
        )),
      ),
    );
  }

  Widget _barrierBuild(
    String title,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 35, bottom: 35),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.green[700],
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 130, top: 0, bottom: 20, right: 130),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _barrierbutton(
                  ScreenUtil.t(I18nKey.basmentbarrier)! + " B1-1", 1),
              // const SizedBox(
              //   width: 40,
              // ),
              _barrierbutton(
                  ScreenUtil.t(I18nKey.basmentbarrier)! + " B1-2", 2),
              // const SizedBox(
              //   width: 35,
              // ),
              _barrierbutton(
                  ScreenUtil.t(I18nKey.basmentbarrier)! + " B1-3", 3),
              // const SizedBox(
              //   width: 35,
              // ),
              _barrierbutton(
                  ScreenUtil.t(I18nKey.basmentbarrier)! + " B1-4", 4),
            ],
          ),
        ),
      ],
    );
  }

  Widget _barrierbutton(String namebutton, int id) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 1,
              spreadRadius: 1,
            ),
          ]),
      width: 160,
      height: 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 160,
            height: 160 * 0.7,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child:
                  Image.asset("assets/images/barrier.png", fit: BoxFit.cover),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(namebutton),
          ),
          const SizedBox(
            height: 10,
          ),
          id == Selecteid
              ? StreamBuilder(
                  stream: widget.barrierBloc.barrier,
                  builder: (context,
                      AsyncSnapshot<ApiResponse<BarrierModel?>> snapshot) {
                    if (snapshot.hasData) {
                      debugPrint(snapshot.data!.model!.message);
                      return _timer != 0
                          ? Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              height: 30,
                              color: Colors.red,
                              child: Center(
                                child: Text(
                                  snapshot.data!.model!.message,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))
                          : const SizedBox(height: 30);
                    } else if (snapshot.hasError) {
                      return SizedBox(
                        height: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            snapshot.error.toString(),
                          ),
                        ),
                      );
                    }
                    return const SizedBox(height: 30);
                  },
                )
              : const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextButton(
              onPressed: () {
                _timerMessage();
                setState(() {
                  Selecteid = id;
                  widget.fetchBarrier(id.toString());
                });
              },
              child: Center(child: Text(ScreenUtil.t(I18nKey.openbarrier)!)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalnumber(
      List<RegionModel> regions, String status, int totalBasment) {
    int sum = 0;
    for (RegionModel region in regions) {
      sum +=
          region.emptySlots.where((element) => element.status == status).length;
    }
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints size) {
        return RichText(
            text: TextSpan(children: [
          TextSpan(
              text: status == 'unavailable'
                  ? ScreenUtil.t(I18nKey.totalnumber)! + ": "
                  : ScreenUtil.t(I18nKey.totalnumbernull)! + ": ",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black)),
          TextSpan(
              text: sum.toString() + "/" + totalBasment.toString(),
              style: const TextStyle(
                  fontStyle: FontStyle.italic, color: Colors.black))
        ]));
      },
    );
  }

  Widget _statusText({
    required Color statusColor,
    required String text,
    TextStyle? textStyle,
    Icon? icon,
  }) {
    return Container(
      height: 28,
      constraints: const BoxConstraints(minWidth: 130),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        children: [
          if (icon != null) icon,
          Center(
            child: Text(
              text,
              style: textStyle ?? Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _parkingStatus({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(top: 20, bottom: 20),
        //   child: Text(
        //     title,
        //     style: const TextStyle(
        //         color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        //   ),
        // ),
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Divider(
                  thickness: 0.5,
                ),
              ),
            ),
          ],
        ),
        child,
      ],
    );
  }

  Widget _motoEmptySlotStatus(
      {required MotoEmptySlotModel motoEmptySlot, double width = 550}) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints size) {
      final contentWidth = width;
      final space =
          ((size.maxWidth - _padding) / 2) - (contentWidth + _padding);
      final cardWidth =
          space > 0 ? contentWidth + space : size.maxWidth - _padding;
      final textStyle = Theme.of(context)
          .textTheme
          .headline4!
          .copyWith(color: AppColor.primaryText);
      int emptySlot = 0;
      for (var emptySpace in motoEmptySlot.emptySpaces) {
        emptySlot += emptySpace.emptySlot;
      }
      //final motorParked = 500 - emptySlot;
      final lineColor = emptySlot / 500 > 0.75
          ? Theme.of(context).primaryColor
          : Theme.of(context).errorColor;
      if (motoEmptySlot.floorName == '') {
        return SizedBox();
      }
      return Card(
        elevation: 16,
        color: AppColor.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        shadowColor: AppColor.shadow.withOpacity(0.16),
        child: SizedBox(
          width: cardWidth,
          child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Image.asset("assets/images/parking.jpeg"),
                    ),
                  ),
                ),
              ),
              Container(
                width: cardWidth - 120,
                padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          motoEmptySlot.floorName == 'Tầng 1'
                              ? ScreenUtil.t(I18nKey.floor)! + ' 1'
                              : ScreenUtil.t(I18nKey.floor)! + ' 1',
                          textAlign: TextAlign.left,
                          style: textStyle,
                        ),
                        Text(
                          '$emptySlot/500',
                          style: textStyle,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints size) {
                        return Stack(
                          children: [
                            Container(
                              height: 4,
                              width: size.maxWidth,
                              color: AppColor.emptySlotColor,
                            ),
                            Container(
                              height: 4,
                              width: size.maxWidth * (emptySlot / 500),
                              color: lineColor,
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _carEmptySlotStatus(
      {required RegionModel regionModel,
      double width = 550,
      required String status,required String floor}) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints size) {
      final contentWidth = width;
      final space =
          ((size.maxWidth - _padding) / 2) - (contentWidth + _padding);
      final cardWidth =
          space > 0 ? contentWidth + space : size.maxWidth - _padding;
      final textTheme = Theme.of(context).textTheme;
      final primaryColor = Theme.of(context).primaryColor;
      final floorEmptySlots =
          regionModel.emptySlots.where((element) => element.status == status);
      
      return Card(
        elevation: 16,
        color: AppColor.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        shadowColor: AppColor.shadow.withOpacity(0.16),
        child: SizedBox(
          width: cardWidth,
          child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Image.asset("assets/images/parking_car.jpeg"),
                    ),
                  ),
                ),
              ),
              Container(
                width: cardWidth - 120,
                padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          floor.toUpperCase()+'-' + regionModel.name,
                          textAlign: TextAlign.left,
                          style: textTheme.headline4!
                              .copyWith(color: textTheme.bodyText1!.color),
                        ),
                        _statusText(
                          statusColor: primaryColor.withOpacity(0.1),
                          text: floorEmptySlots.length.toString() +
                              ' ' +
                              (status=='unavailable'?ScreenUtil.t(I18nKey.parkedslots)!:ScreenUtil.t(I18nKey.emptySlots)!),
                          textStyle: textTheme.bodyText1!
                              .copyWith(color: primaryColor, fontSize: 16),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 8, 4),
                      child: Text(
                        status=='unavailable'?ScreenUtil.t(I18nKey.parkedslots)!:ScreenUtil.t(I18nKey.emptySlots)!,
                        textAlign: TextAlign.left,
                        style: textTheme.bodyText2!.copyWith(fontSize: 12),
                      ),
                    ),
                    Wrap(
                      children: [
                        for (var slot in floorEmptySlots)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              width: 80,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    slot.sensorId,
                                    style: textTheme.bodyText1!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
