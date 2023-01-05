import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconData {
  String path;
  SvgIconData({required this.path});
}

class SvgIcons {
  static SvgIconData smartMeeting =
      SvgIconData(path: 'assets/svg/smartMeeting.svg');

  static SvgIconData smartParking =
      SvgIconData(path: 'assets/svg/smartParking.svg');

  static SvgIconData faceRecognition =
      SvgIconData(path: 'assets/svg/faceID.svg');

  static SvgIconData buildingManagement =
      SvgIconData(path: 'assets/svg/buildingManagement.svg');

  static SvgIconData healthyCheck =
      SvgIconData(path: 'assets/svg/healthyCheck.svg');

  static SvgIconData occupancyMonitor =
      SvgIconData(path: 'assets/svg/occupancyMonitor.svg');

  static SvgIconData riskManagement =
      SvgIconData(path: 'assets/svg/riskManagement.svg');

  static SvgIconData userManagement =
      SvgIconData(path: 'assets/svg/userManagement.svg');

  static SvgIconData dashboard = SvgIconData(path: 'assets/svg/dashboard.svg');
//error
  static SvgIconData home = SvgIconData(path: 'assets/svg/home.svg');

  static SvgIconData notification =
      SvgIconData(path: 'assets/svg/notification.svg');

  static SvgIconData newA = SvgIconData(path: 'assets/svg/@.svg');

  static SvgIconData setting = SvgIconData(path: 'assets/svg/setting.svg');

//ok
  static SvgIconData account = SvgIconData(path: 'assets/svg/account.svg');

  static SvgIconData check = SvgIconData(path: 'assets/svg/check.svg');
//warning
  static SvgIconData edit = SvgIconData(path: 'assets/svg/edit.svg');

  static SvgIconData feedBack = SvgIconData(path: 'assets/svg/feedBack.svg');

  static SvgIconData hidden = SvgIconData(path: 'assets/svg/hidden.svg');

  static SvgIconData logout = SvgIconData(path: 'assets/svg/logout.svg');

  static SvgIconData password = SvgIconData(path: 'assets/svg/password.svg');

  static SvgIconData report = SvgIconData(path: 'assets/svg/report.svg');

  static SvgIconData support = SvgIconData(path: 'assets/svg/support.svg');

  static SvgIconData telephone = SvgIconData(path: 'assets/svg/telephone.svg');

  static SvgIconData language = SvgIconData(path: 'assets/svg/language.svg');

  static SvgIconData bicycle = SvgIconData(path: 'assets/svg/bicycle.svg');

  static SvgIconData bike = SvgIconData(path: 'assets/svg/bike.svg');

  static SvgIconData car = SvgIconData(path: 'assets/svg/car.svg');
  //faceReco
  static SvgIconData faceRecoUser = SvgIconData(path: 'assets/svg/user.svg');

  static SvgIconData fingerprint =
      SvgIconData(path: 'assets/svg/fingerprint.svg');

  static SvgIconData face = SvgIconData(path: 'assets/svg/happy.svg');

  static SvgIconData card = SvgIconData(path: 'assets/svg/credit-card.svg');

  static SvgIconData device = SvgIconData(path: 'assets/svg/device.svg');

  static SvgIconData door = SvgIconData(path: 'assets/svg/door.svg');

  static SvgIconData accessGroup = SvgIconData(path: 'assets/svg/group.svg');
  static SvgIconData mask = SvgIconData(path: 'assets/svg/mask.svg');
  static SvgIconData nomask = SvgIconData(path: 'assets/svg/no_mask.svg');
  static SvgIconData thermometer = SvgIconData(path: 'assets/svg/thermometer.svg');
  static SvgIconData nothermometer = SvgIconData(path: 'assets/svg/no_thermometer.svg');
}

class SvgIcon extends StatelessWidget {
  const SvgIcon(
    this.icon, {
    Key? key,
    this.size,
    this.color,
    this.semanticLabel,
  }) : super(key: key);

  final SvgIconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon.path,
      width: size,
      height: size,
      color: color,
      semanticsLabel: semanticLabel,
    );
  }
}
