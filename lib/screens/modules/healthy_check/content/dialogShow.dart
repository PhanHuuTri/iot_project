import 'package:flutter/material.dart';
import 'package:web_iot/core/modules/healthycheck/blocs/Healthy/healthy_bloc.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';

import '../../../../core/modules/healthycheck/models/healthy_model.dart';
import '../../../../core/rest/models/rest_api_response.dart';

class DialogDiveceHealThy extends StatefulWidget {
  final HealthylDeviceModel deviceItem;
  const DialogDiveceHealThy({Key? key, required this.deviceItem})
      : super(key: key);

  @override
  State<DialogDiveceHealThy> createState() => _DialogDiveceHealThyState();
}

class _DialogDiveceHealThyState extends State<DialogDiveceHealThy> {
  final _healthyBloc = HealthyBloc();
  @override
  void dispose() {
    _healthyBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        SizedBox(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Positioned(
          right: 20,
          top: 20,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0, backgroundColor: Colors.transparent),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.close,
                size: 30,
                color: Colors.white,
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 150, bottom: 150),
          child: Align(
              alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: 2,
                child: FutureBuilder(
                  future: _healthyBloc.fetchDataDeviceId(widget.deviceItem.id),
                  builder: (context, AsyncSnapshot<DeviceModelID> snapshot) {
                    if (snapshot.hasData) {
                      final info = snapshot.data!.DeviceInfo;
                      return Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(35)),
                            color: Colors.white,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                title(widget.deviceItem.name),
                                content(info)
                              ],
                            ),
                          ));
                    } else if (snapshot.hasError) {
                      return JTCircularProgressIndicator(
                        size: 20,
                        strokeWidth: 1.5,
                        color: Theme.of(context).textTheme.button!.color!,
                      );
                    } else {
                      return Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(35)),
                            color: Colors.white,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                title(widget.deviceItem.name),
                                JTCircularProgressIndicator(
                                  size: 20,
                                  strokeWidth: 1.5,
                                  color: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .color!,
                                ),
                              ],
                            ),
                          ));
                    }
                  },
                ),
              )),
        ),
      ]),
    );
  }

  Widget title(String name) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
      height: 150,
      decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(35))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: Container(),
          ),
          Text(name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget content(DeviceInfoModel info) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          lineText('- Device Name: ', info.deviceName),
          lineText('- Version: ', info.version),
          lineText('- Device ID: ', info.deviceID),
          lineText('- Device Description: ', info.deviceDescription),
          lineText('- Device Location: ', info.deviceLocation),
          lineText('- System Contact: ', info.systemContact),
          lineText('- Model: ', info.model),
          lineText('- Serial Number: ', info.serialNumber),
          lineText('- Mac Address: ', info.macAddress),
          lineText('- Firmware Version: ', info.firmwareVersion),
          lineText('- Firmware Released Date: ', info.firmwareReleasedDate),
          lineText('- Encoder Version: ', info.encoderVersion),
          lineText('- Encoder Released Date: ', info.encoderReleasedDate),
          lineText('- Boot Version: ', info.bootVersion),
          lineText('- Boot Released Date: ', info.bootReleasedDate),
          lineText('- Hardware Version: ', info.hardwareVersion),
          lineText('- Device Type: ', info.deviceType),
          lineText('- Tele Control ID: ', info.telecontrolID),
          lineText('- Support Beep: ', info.supportBeep),
          lineText('- Support Video Loss: ', info.supportVideoLoss),
          lineText('- Camera Module Version: ', info.cameraModuleVersion),
        ],
      ),
    );
  }

  Widget lineText(String title, String value) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      TextSpan(
          text: value,
          style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
    ]));
  }
}
