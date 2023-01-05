
import 'package:web_iot/screens/modules/healthy_check/modelDialog/dialogfilterevenhistory.dart';

import '../../../../config/svg_constants.dart';

class FilterEvent{
  final String title;
  final SvgIconData urlImage;
   bool check;
  FilterEvent( {required this.check,required this.title,required this.urlImage});
}