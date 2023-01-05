import 'package:flutter/material.dart';
import 'package:web_iot/config/svg_constants.dart';
import 'package:web_iot/main.dart';
//import 'package:web_iot/screens/modules/healthy_check/modelDialog/dialogfilterevenhistory.dart';

import '../modelDialog/dialogfilterevenhistory.dart';
import '../modelDialog/filter_model.dart';
//import '../tab_healthycheck/healthy_history.dart';

class FilterStatus extends StatefulWidget {
  final List<FilterEvent> itemFilter;
  final List<FilterEvent> itemSelectFilter;
  final FilterEventHistory filter;
  final Function addFilterHistory;
  //final FilterEventHistory boolEvent;
  const FilterStatus(
      {required this.itemFilter, Key? key, required this.itemSelectFilter, required this.addFilterHistory, required this.filter})
      : super(key: key);

  @override
  State<FilterStatus> createState() => _FilterStatusState();
}


class _FilterStatusState extends State<FilterStatus> {


  @override
  void dispose(){
    //widget.itemSelectFilter.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics:const NeverScrollableScrollPhysics(),
          itemCount: widget.itemFilter.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: InkWell(
                onTap: () {
                  if(index==0){
                      if(widget.itemFilter[1].check==true&&widget.itemFilter[index].check==false){
                        widget.itemFilter[1].check=false;
                        widget.filter.nohigh=false;
                      }
                      widget.filter.checknohigh();
                    }else if(index==1){
                      if(widget.itemFilter[0].check==true&&widget.itemFilter[index].check==false){
                        widget.itemFilter[0].check=false;
                        widget.filter.high=false;
                      }
                      widget.filter.checkhigh();
                    }else if(index==2){
                      if(widget.itemFilter[3].check==true&&widget.itemFilter[index].check==false){
                        widget.itemFilter[3].check=false;
                        widget.filter.nomask=false;
                      }
                      widget.filter.checkmask();
                    }else if(index==3){
                      if(widget.itemFilter[2].check==true&&widget.itemFilter[index].check==false){
                        widget.itemFilter[2].check=false;
                        widget.filter.mask=false;
                      }
                      widget.filter.checknomask();
                    }
                    widget.itemFilter[index].check=!widget.itemFilter[index].check;
                    setState(() {
                      
                    });
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: SvgIcon(
                              widget.itemFilter[index].urlImage,
                              color: index==1||index==3? Colors.red:Colors.green,
                            ),
                          ),
                          SizedBox(width: 150,child: Text(widget.itemFilter[index].title)),
                          widget.itemFilter[index].check==true?const SizedBox(
                            width: 24,
                            child: Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                          ): SizedBox(child: Container(width: 24,),)
                        ],
                      ),
                    ),
                    const Divider(color: Colors.grey,),
                  ],
                ),
              ),
            );
          },
        ),
        Padding(
              padding: const EdgeInsets.all(0.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    widget.itemFilter.clear();
                    widget.itemFilter.addAll(setItem(widget.filter.set())) ;
                  });
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Row(
                        children:const [
                           Expanded(
                            child: Icon(Icons.close,size: 25,)
                          ),
                           SizedBox(width: 150,child: Text('Xóa tất cả lựa chọn',style: TextStyle(color: Colors.grey),)),
                          SizedBox(),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.grey,),
                  ],
                ),
              ),
            ),
      ],
    );
  }
  List<FilterEvent> setItem(FilterEventHistory filter) {
    return eventHealthy = [
      FilterEvent(
          title: 'Nhiệt độ bình thường',
          urlImage: SvgIcons.nothermometer,
          check: filter.nohigh ?? false),
      FilterEvent(
          title: 'Nhiệt độ cao',
          urlImage: SvgIcons.thermometer,
          check: filter.high ?? false),
      FilterEvent(
          title: 'Có khẩu trang',
          urlImage: SvgIcons.mask,
          check: filter.mask ?? false),
      FilterEvent(
          title: 'Không có khẩu trang',
          urlImage: SvgIcons.nomask,
          check: filter.nomask ?? false),
    ];
  }
}
