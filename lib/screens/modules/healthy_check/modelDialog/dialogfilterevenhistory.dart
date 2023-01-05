import 'package:universal_html/html.dart';

class FilterEventHistory{
  bool? mask=false;
  bool? nomask=false;
  bool? high=false;
  bool? nohigh=false;
  FilterEventHistory({ this.nomask,required this.high,required this.nohigh, required this.mask,});

  FilterEventHistory set(){
    mask=false;
    nomask=false;
    high=false;
    nohigh=false;
    return FilterEventHistory(high: false,nohigh: false,mask: false,nomask: false);
  }
  void clear(){
    mask=null;
    nomask=null;
    high=null;
    nohigh=null;
  }
  void checkmask(){
    if(nomask==true&&mask==false){
      nomask==false;
    }
    mask=!mask!;
  }
  void checknomask(){
    if(mask==true&& nomask==false){
      mask=false;
    }
    nomask=!nomask!;
  }
  void checkhigh(){
    if(nohigh==true&& high==false){
      nohigh=false;
    }
    high=!high!;
  }
  void checknohigh(){
    if(high==true && nohigh==false){
      high=false;
    }
    nohigh=!nohigh!;
  }
}
