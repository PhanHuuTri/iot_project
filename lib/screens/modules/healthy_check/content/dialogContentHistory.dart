import 'package:flutter/material.dart';
import 'package:web_iot/config/svg_constants.dart';
import 'package:web_iot/main.dart';
import 'package:intl/intl.dart';
import 'package:web_iot/screens/modules/healthy_check/modelDialog/dialogfilterevenhistory.dart';
import 'package:web_iot/screens/modules/healthy_check/modelDialog/filter_model.dart';

import '../../../../core/modules/healthycheck/models/healthy_model.dart';

class ContentHistory extends StatelessWidget {
  final HistoryModel history;
  const ContentHistory({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
        ),
        Align(
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: 1.5 / 2,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.green[700],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    //height: 300,
                    child: ClipRRect(
                        child: Image.network(
                      history.urlImage,
                      fit: BoxFit.cover,
                    )),
                  ),
                  Container(
                    //height: 250,
                    padding:const EdgeInsets.all(15) ,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: Colors.white
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        borderRadius:const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration:const BoxDecoration(
                              border: Border(right: BorderSide(color: Colors.grey))
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 230,
                                  child: ListTile(
                                    contentPadding:const EdgeInsets.all(0.0),
                                    leading:const Icon(Icons.alarm),
                                    title:_formatDateTime(history.createTime) ,
                                  ),
                                ),
                                SizedBox(
                                  width: 230,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(0.0),
                                    leading:const Icon(Icons.video_camera_front),
                                    title:Text(history.channelName) ,
                                  ),
                                ),
                                SizedBox(
                                  width: 230,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(0.0),
                                    leading:const Icon(Icons.fmd_good),
                                    title:Text(history.region) ,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //const Divider(color: Colors.grey,),
                          Column(
                            children: [
                              //RichText(text: 'text'),
                              SizedBox(
                                width: 230,
                                child: ListTile(
                                  leading:SvgIcon(SvgIcons.mask,color: Colors.green,),
                                  title:Text(history.mask=='yes'?'Có mang khẩu trang':'Không mang khẩu trang',style: TextStyle(color: history.mask=='yes'?Colors.green:Colors.red,),) ,
                                ),
                              ),
                              SizedBox(
                                width: 230,
                                child: ListTile(
                                  leading: SvgIcon(SvgIcons.nothermometer,color: Colors.green),
                                  title:Text(history.highTemperature=='yes'?'Nhiệt độ cao':'Nhiệt độ bình thường',style: TextStyle(color:history.highTemperature=='yes'?Colors.red: Colors.green,),) ,
                                ),
                              ),
                              const SizedBox(
                                width: 230,
                                child: ListTile(
                                  leading: Icon( Icons.fact_check,color: Colors.green),
                                  title:Text('Đã sử lý',style: TextStyle(color: Colors.green,),) ,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
  
  Widget _formatDateTime(dynamic value){
    final format =ScreenUtil.t(I18nKey.formatDMY)! + ', HH:mm:ss';
    String _displayedValue = '';
    if (value is int) {
      if (value != 0) {
        final _dateTime = DateTime.fromMillisecondsSinceEpoch(value);
        final _dateTimeLocal = _dateTime.toLocal();
        _displayedValue = DateFormat(format).format(_dateTimeLocal);
      }
    } else if (value is String) {
      final _dateTime = DateTime.tryParse(value );
      final _dateTimeLocal = _dateTime!.toLocal();
      _displayedValue = DateFormat(format).format(_dateTimeLocal);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
      child: Text(_displayedValue,),
    );
  }
}
