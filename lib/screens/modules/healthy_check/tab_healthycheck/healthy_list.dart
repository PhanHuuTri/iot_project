// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:web_iot/core/base/blocs/block_state.dart';
// import 'package:web_iot/core/modules/healthycheck/models/healthy_model.dart';
// import 'package:web_iot/screens/modules/smart_parking/component/export_file.dart';
// import 'package:web_iot/widgets/data_table/table_pagination.dart';
// import 'package:web_iot/widgets/debouncer/debouncer.dart';
// import 'package:web_iot/widgets/joytech_components/joytech_components.dart';
// import 'package:web_iot/widgets/table_columns/table_column_date_time.dart';
// import '../../../../core/modules/healthycheck/blocs/Healthy/healthy_bloc.dart';
// import '../../../../core/modules/smart_parking/models/vehicle_event_model.dart';
// import '../../../../core/modules/user_management/models/account_model.dart';
// import '../../../../main.dart';
// import '../../../../widgets/calendar_popup/calendar_popup.dart';
// import '../../../../widgets/data_table/table_component.dart';
// import '../../../../widgets/table/dynamic_table.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xl;
// import '../../smart_parking/component/export_file.dart';
// import 'package:web_iot/core/modules/face_recog/blocs/event/event_bloc.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';

// final heakthyListKey = GlobalKey<_HealthyListState>();

// class HealthyList extends StatefulWidget {
//   final HealthyBloc healthyBloc;
//   final String route;
  
//   final TextEditingController keyword;
//   final Function(
//     int,String,String, {
//     required int from,
//     required int to,
//   }) fetchHealthyListData;
//   final AccountModel currentUser;

//   const HealthyList({
//     Key? key,
//     required this.keyword,
//     required this.fetchHealthyListData,
//     required this.healthyBloc,
//     required this.route,
//     required this.currentUser,
//   }) : super(key: key);

//   @override
//   _HealthyListState createState() => _HealthyListState();
// }

// class _HealthyListState extends State<HealthyList> {
//   late Debouncer _debouncer;
//   final _dateController = TextEditingController();
//   final _eventController = TextEditingController();
//   final _now = DateTime.now();
//   late int _fromDate;
//   late int _toDate;
//   late DateTime startDate;
//   late DateTime endDate;
//   final double columnSpacing = 50;
//   bool isWarning = false;
//   String _errorMessage = '';
//   bool _allowExport = false;
//   final List<String> _eventType = [];
//   int eventSelectedList = 0;
//   String _hint = '';
//   final _eventBloc = EventBloc();
//   final _eventOperationBloc = EventBloc();
//   bool _isDownloading = false;
//   int _limit = 20;
//   int _count = 0;
//   int _page = 0;
//   String? selectedValue;
  

//   @override
//   void initState() {
    
//     startDate = DateTime(1970, 1,1, 0, 0);
//     endDate = DateTime(_now.year, _now.month, _now.day, 23, 59);
//     _fromDate = startDate.millisecondsSinceEpoch;
//     _toDate = endDate.millisecondsSinceEpoch;
//     widget.fetchHealthyListData(1,'','', from:0,to: 9999999999999,);
//     _getPerrmisson();
//     _debouncer = Debouncer(delayTime: const Duration(milliseconds: 500));
//     checkDialogPop(context);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _debouncer.dispose();
//     super.dispose();
    
//   }
// final List<String> items = [
//   'Tất cả',
//   'Người lạ',
//   'Không khẩu trang',
//   'Mở thất bại',
// ];
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, size) {
//       return Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 if (isWarning)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 16),
//                     child: Container(
//                       height: 32,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(2),
//                         color: AppColor.error,
//                       ),
//                       child: Center(
//                         child: Text(
//                           ScreenUtil.t(I18nKey.warning)!,
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyText1!
//                               .copyWith(color: AppColor.white),
//                         ),
//                       ),
//                     ),
//                   ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
//                   child: _filtersInput(),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   child: _buildActions(),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//             child: StreamBuilder(
//               stream: widget.healthyBloc.allData,
//               builder: (context,
//                   AsyncSnapshot<ApiResponse<HealthylListModel>> snapshot) {
//                 if (snapshot.hasData) {
//                   final meta = snapshot.data!.model!.meta;
//                   return Column(
//                         children: [
//                           _buildTable(),
//                           TablePagination(
//                         onFetch: (page) {
//                           widget.fetchHealthyListData(page,'',selectedValue!, from: _fromDate,to: _toDate);
//                         },
//                     pagination: meta,
//                   ),
//                         ],
//                       );
//                 } else if (snapshot.hasError) {
//                   return Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(snapshot.error.toString()),
//                   );
//                 }
//                 return Align(
//                   alignment: Alignment.centerLeft,
//                   child: JTCircularProgressIndicator(
//                     size: 20,
//                     strokeWidth: 1.5,
//                     color: Theme.of(context).textTheme.button!.color!,
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       );
//     });
//   }
  
// //các filters thời gian, sự kiện, tìm kiếm
//   Widget _filtersInput() {
//     final normalStyle = Theme.of(context).textTheme.bodyText1;
//     final displayedFormat = ScreenUtil.t(I18nKey.formatDMY)! + ', HH:mm';
//     _dateController.text =
//         '${DateFormat(displayedFormat).format(startDate)} - ${DateFormat(displayedFormat).format(endDate)}';
//     _eventController.text="Các sự kiện: quá nhiệt, người lạ, không khẩu trang";
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//           width: 387,//387
//           child: JTTitleButtonFormField(
//             title: ScreenUtil.t(I18nKey.time),
//             titleStyle: Theme.of(context).textTheme.bodyText2,
//             textAlignVertical: TextAlignVertical.center,
//             readOnly: true,
//             controller: _dateController,
//             style: normalStyle,
//             decoration: InputDecoration(
//               fillColor: AppColor.secondaryLight,
//               enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: AppColor.secondaryLight,
//                 ),
//                 borderRadius: BorderRadius.circular(4.0),
//               ),
//               hintText: ScreenUtil.t(I18nKey.startTime)! +
//                   ' - ' +
//                   ScreenUtil.t(I18nKey.endTime)!,
//               prefixIcon: ButtonTheme(
//                 minWidth: 30,
//                 height: 30,
//                 child: Icon(
//                   Icons.date_range_outlined,
//                   size: 16,
//                   color: normalStyle!.color,
//                 ),
//               ),
//             ),
//             onPressed: () {
//               showDialog<dynamic>(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return CalendarPopupView(
//                       barrierDismissible: false,
//                       initialStartDate: startDate,
//                       initialEndDate: endDate,
//                       maximumDate: endDate,
//                       contentPadding: const EdgeInsets.symmetric(vertical: 16),
//                       onApplyClick: (DateTime startData, DateTime endData) {
//                         setState(() {
//                           startDate = startData;
//                           endDate = endData;
//                           _dateController.text =
//                               '${DateFormat(displayedFormat).format(startDate)} - ${DateFormat(displayedFormat).format(endDate)}';
//                           _fromDate = startDate.millisecondsSinceEpoch;
//                           _toDate = endDate.millisecondsSinceEpoch;
//                           widget.fetchHealthyListData(1,widget.keyword.toString(),selectedValue!,from: _fromDate,to: _toDate);
//                         });
//                       },
//                     );
//                   });
//             },
//           ),
//         ),
//         const Padding(
//           padding: EdgeInsets.only(top: 8, bottom: 5),
//           child: Text('Sự kiện'),),
//         Padding(
//           padding:const EdgeInsets.only(top: 5,bottom: 5),
//           child: SizedBox(
//             width: 387,
//             child: InputDecorator(
//               decoration: const InputDecoration(border: OutlineInputBorder()),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton2(
                  
//                   dropdownDecoration: BoxDecoration(
                    
//                     borderRadius: BorderRadius.circular(10),
//                      boxShadow:const <BoxShadow>[ //apply shadow on Dropdown button
//                       BoxShadow(
//                           color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
//                           blurRadius: 3) //blur radius of shadow
//                     ],
                    
//                     color: Colors.white,
                    
//                   ),
//                   isExpanded: true,
//                         hint: Text(
//                           'Chọn sự kiện',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Theme.of(context).hintColor,
//                           ),
//                         ),
//                         items: _addDividersAfterItems(items),
//                         customItemsHeights: _getCustomItemsHeights(),
//                         value: selectedValue,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedValue = value! as String;
//                             if(selectedValue == 'Tất cả') {
//                               widget.fetchHealthyListData(1,widget.keyword.toString(),'',from: _fromDate,to: _toDate);
//                               return;
//                             }
//                             widget.fetchHealthyListData(1,widget.keyword.toString(),selectedValue!,from: _fromDate,to: _toDate);
//                           });
//                         },
//                         buttonHeight: 40,
//                         dropdownMaxHeight: 200,
//                         buttonWidth: 140,
//                         itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       ),
//               ),
//             ),
//           ),
//         ),
//           ],
//         ),
//         SizedBox(
//           width: 437,
//           child: JTSearchField(
//             controller: widget.keyword,
//             // hintText: ScreenUtil.t(I18nKey.searchLicensePlatesUserName)!,
//             hintText: "Nhập tên nhân viên",
//             onPressed: () {
//               setState(
//                 () {
//                   if (widget.keyword.text.isEmpty) return;
//                   widget.keyword.text = '';
//                 },
//               );
//             },
//             onChanged: (newValue) {
//                _debouncer.debounce(afterDuration: (){
//                   widget.fetchHealthyListData(1,widget.keyword.toString(),selectedValue!,from: _fromDate,to: _toDate);
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }
//   checkDialogPop(BuildContext context) async {
//     if (checkRoute(widget.route) != true) {
//       if (Navigator.of(context).canPop()) {
//         Navigator.of(context).pop();
//       }
//     }
//   }

//   _getPerrmisson() {
//   }
//   fetchData({
//     List<String>? eventType,
//     String? hint,
//   }) {
//     setState(() {
//       if (eventType != null) {
//         if (_eventType != eventType) {
//           if (_eventType.isNotEmpty) {
//             _eventType.clear();
//           }
//           _eventType.addAll(eventType);
//         }
//       }
//       if (eventSelectedList == 0) {
//         Map<String, dynamic> params = {
//           'fromDate': _fromDate,
//           'toDate': _toDate,
//           'doorID': widget.keyword.text,
//           'limit': 10,
//           'eventType': _eventType,
//         };
//         if (hint != null && hint.isNotEmpty) {
//           _hint = hint;
//           params['hint'] = _hint;
//         } else {
//           _hint = '';
//         }
//         _eventBloc.fetchEventsData(params: params);
//       } else {
//         Map<String, dynamic> params = {
//           'fromDate': _fromDate,
//           'toDate': _toDate,
//           'limit': 10,
//           'page': 1,
//           'doorID': widget.keyword.text,
//         };
//         if (eventType != null && eventType.isNotEmpty) {
//           params['eventType'] = eventType;
//         }
//         _eventOperationBloc.fetchOperationData(params: params);
//       }
//     });
//   }
// //Phần phía sau 2 nút tab
//   Widget _buildActions() {
//     final enable = _allowExport && _dateController.text.isNotEmpty;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             // _buildTabButton(),
//             const Spacer(),
//             JTExportButton(
//               enable: enable,
//               onPressed: enable
//                   ? () {
//                       showDialog(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (context) {
//                           return ConfirmExportDialog(
//                             onPressed: () {}
//                           );
//                         },
//                       );
//                     }
//                   : null,
//             ),
//           ],
//         ),
//         if (_errorMessage.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(4.0),
//                 border: Border.all(
//                   color: Theme.of(context).errorColor,
//                   width: 1,
//                 ),
//               ),
//               child: Padding(
//                 child: Text(
//                   _errorMessage,
//                   style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                       fontStyle: FontStyle.italic,
//                       color: Theme.of(context).errorColor),
//                 ),
//                 padding: const EdgeInsets.all(16),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildTable() {
//     final List<TableHeader> tableHeaders = [
//       TableHeader(
//         title: ScreenUtil.t(I18nKey.no)!.toUpperCase(),
//         width: 60,
//         isConstant: true,
//       ),
//       TableHeader(
//         title: 'Phòng',
//         width: 120,
//         isConstant: true,
//       ),
//       TableHeader(
//         title: 'Ngày cập nhật',
//         width: 150,
//         isConstant: true,
//       ),
//       TableHeader(
//         title: 'Ngày tạo',
//         width: 150,
//         isConstant: true,
//       ),
//       TableHeader(
//         title: 'Thiết bị',
//         width: 200,
//         isConstant: true,
//       ),
//       TableHeader(
//         title: 'Người tạo',
//         width: 200,
//       ),
//       TableHeader(
//         title:'Người update',
//         width: 200,
//         isConstant: true,
//       ),
//       TableHeader(
//         title:'Sự kiện',
//         width: 150,
//         isConstant: true,
//       ),
//     ];
//     return Stack(
//       children:[
//         StreamBuilder(
//         stream:  widget.healthyBloc.allData,
//         builder: (context, AsyncSnapshot<ApiResponse<HealthylListModel>> snapshot) {
//           if(snapshot.hasData){
//             final healthys = snapshot.data!.model!.records;
//             final meta = snapshot.data!.model!.meta;
//             _page = meta.page;
//               _count = healthys.length;
//             return Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 16),
//                       child: LayoutBuilder(
//                         builder: (context, size) {
//                           return DynamicTable(
//                             columnWidthRatio: tableHeaders,
//                             numberOfRows: healthys.length,
//                             rowBuilder: (index) => _rowFor(
//                               item: healthys[index],
//                               index: index,
//                               meta: meta,
//                             ),
//                             hasBodyData: true,
//                             tableBorder: Border.all(color: AppColor.black, width: 1),
//                             headerBorder: TableBorder(
//                               bottom: BorderSide(color: AppColor.noticeBackground),
//                             ),
//                             headerStyle: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: AppColor.black,
//                               fontStyle: FontStyle.normal,
//                             ),
//                             bodyBorder: TableBorder(
//                               horizontalInside: BorderSide(
//                                 color: AppColor.noticeBackground,
//                               ),
//                           ),
//                         );
//                       },
//                     )
//                   ),
//                   if (healthys.isEmpty)
//                       Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Text(ScreenUtil.t(I18nKey.noData)!),
//                         ),
//                       ),
//                 ]
//               );
//           }else if (snapshot.hasError) {
//                 return Padding(
//                   padding: const EdgeInsets.only(top: 8, bottom: 16),
//                   child: snapshot.error.toString().trim() == 'request timeout'
//                       ? Text(ScreenUtil.t(I18nKey.requestTimeOut)!)
//                       : Text(snapshot.error.toString()),
//                 );
//               }
//           return const SizedBox();
//         } ,
//       ),
//       StreamBuilder(
//           stream: widget.healthyBloc.allDataState,
//           builder: (context, state) {
//             if (!state.hasData || state.data == BlocState.fetching) {
//               return Center(
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 8),
//                   child: JTCircularProgressIndicator(
//                     size: 24,
//                     strokeWidth: 2.0,
//                     color: Theme.of(context).textTheme.button!.color!,
//                   ),
//                 ),
//               );
//             }
//             return const SizedBox();
//           },
//         ),
//       ] 
//     );
//   }

//   TableRow _rowFor({
//     required HealthylModel item,
//     required Paging meta,
//     required int index,
//   }) {
//     final recordOffset = meta.recordOffset;
//     return TableRow(
//       children: [
//         tableCellText(
//             title: '${recordOffset + index + 1}', alignment: Alignment.center),
//         tableCellText(
//             title: item.room , alignment: Alignment.center),
//         tableCellText(
//           child: TableColumnDateTime(
//               value: item.updatedTime,
//               displayedFormat:  ScreenUtil.t(I18nKey.formatDMY)!,
//             ),
          
//           // title: item.updatedTime.toString(),
//         ),
//          tableCellText(
//           alignment: Alignment.center,
//           child: TableColumnDateTime(
//               value: item.createdTime,
//               displayedFormat:  ScreenUtil.t(I18nKey.formatDMY)!,
//             ),
//           // title: item.updatedTime.toString(),
//         ),
//         tableCellText(
//           title:item.device,
//         ),
//         tableCellText(
//           title: item.userCreate,
//         ),
//         tableCellText(
//           title: item.userUpdate,
//         ),
//         tableCellText(
//           title: item.event,
//         ),
//       ],
//     );
//   }
    

// List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
//   List<DropdownMenuItem<String>> _menuItems = [];
//   for (var item in items) {
//     _menuItems.addAll(
//       [
//         DropdownMenuItem<String>(
//           value: item,
//           child: Padding(
            
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Text(
//               item,
//               style: const TextStyle(
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ),
//         //If it's last item, we will not add Divider after it.
//         if (item != items.last)
//           const DropdownMenuItem<String>(
//             enabled: false,
//             child: Divider(),
//           ),
//       ],
//     );
//   }
//   return _menuItems;
// }

// List<double> _getCustomItemsHeights() {
//   List<double> _itemsHeights = [];
//   for (var i = 0; i < (items.length * 2) - 1; i++) {
//     if (i.isEven) {
//       _itemsHeights.add(40);
//     }
//     //Dividers indexes will be the odd indexes
//     if (i.isOdd) {
//       _itemsHeights.add(4);
//     }
//   }
//   return _itemsHeights;
// }

//   String _parseDisplayedDateTime(String? value) {
//     ScreenUtil.init(context);
//     if (value != null && value.isNotEmpty) {
//       final _date =
//           DateTime.fromMillisecondsSinceEpoch(int.parse(value) * 1000);
//       final _displayText =
//           DateFormat(ScreenUtil.t(I18nKey.formatDMY)! + ', HH:mm')
//               .format(_date);
//       return _displayText;
//     }
//     return '';
//   }

//   List<xl.ExcelDataRow> _buildExcel(
//     List<VehicleEventModel> data,
//     bool isException,
//   ) {
//     List<xl.ExcelDataRow> excelDataRows = <xl.ExcelDataRow>[];

//     excelDataRows = data.map<xl.ExcelDataRow>((VehicleEventModel reportModel) {
//       return xl.ExcelDataRow(
//         cells: <xl.ExcelDataCell>[
//           xl.ExcelDataCell(
//               columnHeader: ScreenUtil.t(I18nKey.no)!.toUpperCase(),
//               value: data.indexOf(reportModel) + 1),
//           // xl.ExcelDataCell(
//           //   columnHeader: ScreenUtil.t(I18nKey.floor)!,
//           //   value: '',
//           // ),
//           xl.ExcelDataCell(
//             columnHeader: ScreenUtil.t(I18nKey.licensePlate)!,
//             value: reportModel.plateNumber,
//           ),
//           xl.ExcelDataCell(
//             columnHeader: ScreenUtil.t(I18nKey.timeIn)!,
//             value: _parseDisplayedDateTime(reportModel.dateTimeIn),
//           ),
//           xl.ExcelDataCell(
//             columnHeader: ScreenUtil.t(I18nKey.timeOut)!,
//             value: _parseDisplayedDateTime(reportModel.dateTimeOut),
//           ),
//           xl.ExcelDataCell(
//             columnHeader: ScreenUtil.t(I18nKey.status)!,
//             value: isException
//                 ? reportModel.eventType
//                 : ScreenUtil.t(I18nKey.success)!,
//           ),
//           xl.ExcelDataCell(
//             columnHeader: ScreenUtil.t(I18nKey.vehicleType)!,
//             value: reportModel.cardGroupName,
//           ),
//         ],
//       );
//     }).toList();

//     return excelDataRows;
//   }

//   Future<void> exportDataGridToExcel({
//     required List<VehicleEventModel> data,
//     bool isException = false,
//   }) async {
//     final workbook = xl.Workbook();
//     xl.Style headerStyle;
//     xl.Style headerSubStyle;
//     xl.Style tableContentStyle;
//     xl.Style signStyle;

//     final xl.Worksheet sheet = workbook.worksheets[0];
//     const int rowIndex = 4;
//     const int colIndex = 3;

//     headerStyle = workbook.styles.add('headerStyle');
//     headerStyle.fontName = 'Roboto';
//     headerStyle.fontSize = 18;
//     headerStyle.bold = true;
//     headerStyle.hAlign = xl.HAlignType.center;
//     headerStyle.vAlign = xl.VAlignType.center;
//     headerStyle.borders.left.lineStyle = xl.LineStyle.thin;
//     headerStyle.borders.right.lineStyle = xl.LineStyle.thin;
//     headerStyle.borders.top.lineStyle = xl.LineStyle.thin;
//     headerStyle.borders.all.color = '#000000';
//     final header = sheet.getRangeByName('C2:I2');
//     header.merge();
//     header.setValue(ScreenUtil.t(I18nKey.vehicleList)!);
//     header.cellStyle = headerStyle;
//     header.rowHeight = 25;

//     headerSubStyle = workbook.styles.add('headerSubStyle');
//     headerSubStyle.fontName = 'Roboto';
//     headerSubStyle.fontSize = 13;
//     headerSubStyle.wrapText = true;
//     headerSubStyle.hAlign = xl.HAlignType.left;
//     headerSubStyle.vAlign = xl.VAlignType.center;
//     headerSubStyle.borders.left.lineStyle = xl.LineStyle.thin;
//     headerSubStyle.borders.right.lineStyle = xl.LineStyle.thin;
//     headerSubStyle.borders.bottom.lineStyle = xl.LineStyle.thin;
//     headerSubStyle.borders.all.color = '#000000';
//     final headerSub = sheet.getRangeByName('C3:I3');
//     headerSub.cellStyle = headerSubStyle;
//     headerSub.merge();
//     headerSub
//         .setValue('${ScreenUtil.t(I18nKey.time)!}: ${_dateController.text}');
//     headerSub.cellStyle = headerSubStyle;
//     headerSub.rowHeight = 60;

//     sheet.enableSheetCalculations();
//     sheet.importData(_buildExcel(data, isException), rowIndex, colIndex);
//     sheet.setRowHeightInPixels(rowIndex, 30);

//     tableContentStyle = workbook.styles.add('tableContentStyle');
//     tableContentStyle.borders.all.lineStyle = xl.LineStyle.thin;
//     tableContentStyle.borders.all.color = '#000000';
//     tableContentStyle.fontName = 'Roboto';
//     tableContentStyle.fontSize = 13;
//     tableContentStyle.wrapText = true;
//     tableContentStyle.hAlign = xl.HAlignType.center;
//     tableContentStyle.vAlign = xl.VAlignType.center;

//     for (var r = rowIndex; r <= data.length + 1 + colIndex; r++) {
//       for (var c = colIndex; c < 7 + colIndex; c++) {
//         sheet.autoFitColumn(r);
//         if (r == rowIndex) {
//           sheet.getRangeByIndex(r, c).cellStyle = tableContentStyle;
//           sheet.getRangeByIndex(r, c).cellStyle.bold = true;
//         } else {
//           sheet.getRangeByIndex(r, c).cellStyle = tableContentStyle;
//         }
//       }
//     }
//     final lastCellIndex = data.length + colIndex;

//     signStyle = workbook.styles.add('signStyle');
//     signStyle.fontName = 'Roboto';
//     signStyle.fontSize = 13;
//     signStyle.hAlign = xl.HAlignType.center;
//     signStyle.vAlign = xl.VAlignType.center;

//     sheet
//         .getRangeByName('H${lastCellIndex + 3}')
//         .setValue(ScreenUtil.t(I18nKey.reporter)!);
//     sheet.getRangeByName('H${lastCellIndex + 3}').cellStyle = signStyle;
//     sheet.getRangeByName('H${lastCellIndex + 3}').cellStyle.bold = true;

//     sheet
//         .getRangeByName('H${lastCellIndex + 4}')
//         .setValue('(${ScreenUtil.t(I18nKey.signature)!})');
//     sheet.getRangeByName('H${lastCellIndex + 4}').cellStyle = signStyle;

//     final List<int> bytes = workbook.saveAsStream();
//     workbook.dispose();
//     await saveAndLaunchFile(
//         bytes, ScreenUtil.t(I18nKey.vehicleList)! + '.xlsx');
//   }
// }

// class T {
// }
