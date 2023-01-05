import 'package:flutter/material.dart';
import 'package:web_iot/core/modules/smart_parking/blocs/vehicle/vehicle_bloc.dart';
import 'package:web_iot/core/modules/smart_parking/models/vehicle_event_model.dart';
import 'package:web_iot/main.dart';
import 'package:web_iot/widgets/debouncer/debouncer.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';

class TextFieldCombo extends StatefulWidget {
  final VehicleBloc vehicleBloc;
  final VehicleBloc vehicleExceptionBloc;
  final int fromDate;
  final int toDate;
  final TextEditingController keyword;
  final TextEditingController keywordmain;
  final Function(
    int,
    int,
    String, {
    required int from,
    required int to,
  }) fetchParkingListData;
  final Function(
    int,
    String, {
    required int from,
    required int to,
  }) fetchParkingfiler;
  final Function(
    int, {
    required int from,
    required int to,
  }) fetchParkingExceptionData;
  const TextFieldCombo(
      {Key? key,
      required this.fetchParkingExceptionData,
      required this.fromDate,
      required this.toDate,
      required this.keyword,
      required this.vehicleBloc,
      required this.vehicleExceptionBloc,
      required this.fetchParkingfiler,
      required this.fetchParkingListData, required this.keywordmain})
      : super(key: key);

  @override
  State<TextFieldCombo> createState() => _TextFieldComboState();
}

class _TextFieldComboState extends State<TextFieldCombo> {
  int? _selectedPlace;
  late Debouncer _debouncer;
  @override
  void initState() {
    _debouncer = Debouncer(delayTime: const Duration(milliseconds: 500));
    _debouncer.debounce(afterDuration: () {
      widget.fetchParkingfiler(
        200,
        '',
        from: widget.fromDate,
        to: widget.toDate,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: parkSelectedList == 0
            ? widget.vehicleBloc.allData
            : widget.vehicleExceptionBloc.allData,
        builder: (context,
            AsyncSnapshot<ApiResponse<VehicleEventListModel?>> snapshot) {
          if (snapshot.hasData) {
            final vehicles = snapshot.data!.model!.records;
            final meta = snapshot.data!.model!.meta;
            List<VehicleEventModel> _filterNumber =
                vehicles.where((item) => item.plateNumber != '').toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: JTSearchField(
                    controller: widget.keyword,
                    hintText:
                        ScreenUtil.t(I18nKey.searchLicensePlatesUserName)!,
                    onPressed: () {
                      setState(
                        () {
                          if (widget.keyword.text.isEmpty) return;
                          widget.keyword.text = '';
                          if (parkSelectedList == 0) {
                            widget.fetchParkingfiler(
                              200,
                              '',
                              from: widget.fromDate,
                              to: widget.toDate,
                            );
                          } else {
                            widget.fetchParkingExceptionData(
                              1,
                              from: widget.fromDate,
                              to: widget.toDate,
                            );
                          }
                        },
                      );
                    },
                    onChanged: (newValue) {
                      setState(() {
                        //widget.keyword.text = newValue;
                        if (parkSelectedList == 0) {
                          widget.fetchParkingfiler(
                            200,
                            newValue,
                            from: widget.fromDate,
                            to: widget.toDate,
                          );
                        } else {
                          widget.fetchParkingExceptionData(
                            1,
                            from: widget.fromDate,
                            to: widget.toDate,
                          );
                        }
                      });
                    },
                  ),
                ),
                LayoutBuilder(
                  builder: (p0, p1) {
                    return SizedBox(
                      width: 250,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            _filterNumber.length > 7 ? 7 : _filterNumber.length,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedPlace = 0;
                                  widget.keyword.text = '';
                                  if (parkSelectedList == 0) {
                                    widget.fetchParkingfiler(
                                      200,
                                      '',
                                      from: widget.fromDate,
                                      to: widget.toDate,
                                    );
                                  } else {
                                    widget.fetchParkingExceptionData(
                                      1,
                                      from: widget.fromDate,
                                      to: widget.toDate,
                                    );
                                  }
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: ListTile(
                                  title:
                                      Text(ScreenUtil.t(I18nKey.deleteFilter)!),
                                  trailing: const Icon(
                                    Icons.close,
                                    size: 18,
                                  ),
                                ),
                              ),
                            );
                          } else if (index == 6) {
                            return MaterialButton(
                              color: Colors.blue[300],
                              onPressed: () {
                                setState(() {
                                  widget.fetchParkingListData(
                                    1,
                                    5,
                                    widget.keyword.text,
                                    from: widget.fromDate,
                                    to: widget.toDate,
                                  );
                                  widget.keywordmain.text= widget.keyword.text;
                                });
                                Navigator.of(context).pop();
                              },
                              child: Center(
                                child: Text(ScreenUtil.t(I18nKey.confirm)!),
                              ),
                            );
                          } else {
                            return InkWell(
                              onTap: () {
                                widget.keyword.text =
                                    _filterNumber[index - 1].plateNumber;
                                setState(() {
                                  _selectedPlace = index - 1;
                                });
                              },
                              child: ListTile(
                                title: _filterNumber[index - 1].plateNumber ==
                                        ''
                                    ? Text(
                                        ScreenUtil.t(I18nKey.noData)!,
                                      )
                                    : Text(
                                        _filterNumber[index - 1].plateNumber),
                                trailing: index - 1 == _selectedPlace
                                    ? const Icon(
                                        Icons.check,
                                      )
                                    : const SizedBox(),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Align(
              alignment: Alignment.center,
              child: Text(snapshot.error.toString()),
            );
          }
          return Align(
            alignment: Alignment.center,
            child: JTCircularProgressIndicator(
              size: 20,
              strokeWidth: 1.5,
              color: Theme.of(context).textTheme.button!.color!,
            ),
          );
        });
  }
}
