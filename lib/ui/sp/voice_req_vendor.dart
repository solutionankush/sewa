import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:sewa/backend_work/apis.dart';
import 'package:sewa/common/colors.dart';
import 'package:sewa/common/functions.dart';
import 'package:sewa/common/widgets.dart';
import 'package:sewa/ui/common/img_view.dart';
import 'package:sizer/sizer.dart';

import '../../common/variables.dart' as Variables;

class VoiceReqVendor extends StatefulWidget {
  const VoiceReqVendor({Key? key}) : super(key: key);

  @override
  _VoiceReqVendorState createState() => _VoiceReqVendorState();
}

class _VoiceReqVendorState extends State<VoiceReqVendor> {
  List voiceReqList = [];
  List<bool> isPlaying = [];
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();

  @override
  void initState() {
    super.initState();
    getVoiceReq();
    _mPlayer!.openAudioSession();
    if (!kIsWeb) {
      var status = Permission.microphone.request();
      status.then((stat) {
        if (stat != PermissionStatus.granted) {
          throw RecordingPermissionException(
              'Microphone permission not granted');
        }
      });
    }
  }

  getVoiceReq() async {
    EasyLoading.show(
        status: 'Loading.....', maskType: EasyLoadingMaskType.black);
    var response = await http.post(Api.getData, body: {
      "get_data": "voiceReqVendor",
      "id": Variables.userUId,
    });
    var jsonData = jsonDecode(response.body);
    setState(() {
      voiceReqList = jsonData;
    });
    for (int i = 0; i < voiceReqList.length; i++) {
      isPlaying.add(false);
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    Widget _viewScreen() {
      return Center(
        child: ListView(
          children: [
            if (voiceReqList.length > 0) ...[
              for (int i = 0; i < voiceReqList.length; i++) ...[
                Widgets.sizedBox(10, 0),
                ListTile(
                  onTap: voiceReqList[i]['remark'].toString().contains('Complete') ? null : () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () async {
                                EasyLoading.show(
                                    status: 'Loading....',
                                    maskType: EasyLoadingMaskType.black);
                                var res =
                                    await http.post(Api.updateData, body: {
                                  "update_data": "voiceComplete",
                                  "id": voiceReqList[i]['id'],
                                });
                                EasyLoading.dismiss();
                                if (jsonDecode(res.body)) {
                                  EasyLoading.showSuccess(
                                      'Updated successfully',
                                      maskType: EasyLoadingMaskType.black);
                                  Navigator.pop(context);
                                } else {
                                  EasyLoading.showError('Updated Failed',
                                      maskType: EasyLoadingMaskType.black);
                                }
                              },
                              child: Text('Complete'),
                            ),
                          ],
                        ),
                      ),
                    ).then((value) {
                      getVoiceReq();
                      setState(() {});
                    });
                  },
                  leading: voiceReqList[i]['voice']
                      .toString()
                      .split('/')
                      .last
                      .split('.')
                      .last ==
                      'jpg'
                      ? InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ImgView(img: "${Api.baseURL}${voiceReqList[i]['voice']}"),));
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          "${Api.baseURL}${voiceReqList[i]['voice']}"),
                    ),
                  )
                      : IconButton(
                    onPressed: () async {
                      var length = isPlaying.length;
                      if (!isPlaying[i]) {
                        isPlaying.replaceRange(
                          0,
                          length,
                          [
                            for (int i = 0; i < length; i++) ...[false]
                          ],
                        );
                      }
                      setState(() {
                        isPlaying[i] = !isPlaying[i];
                      });
                      if (isPlaying[i]) {
                        if (isPlaying[i] != _mPlayer!.isPlaying) {
                          _mPlayer!.stopPlayer();
                        }
                        _mPlayer!.setSubscriptionDuration(Duration(minutes: 5));
                        _mPlayer!.startPlayer(
                          fromURI: Api.baseURL + voiceReqList[i]['voice'],
                          whenFinished: () {
                            setState(() {
                              isPlaying[i] = false;
                            });
                          },
                        );
                      } else {
                        _mPlayer!.stopPlayer();
                      }
                    },
                    icon: Icon(
                      isPlaying[i] ? Icons.pause : Icons.play_arrow,
                      color: MyColors.highlightColor,
                    ),
                  ),
                  title: Text('User: ${voiceReqList[i]['user_name']}'),
                  subtitle: Text('Remark: ${voiceReqList[i]['remark'] ?? ''}'),
                  trailing: IconButton(
                    onPressed: voiceReqList[i]['remark'].toString().contains('Complete') ? null : () {
                      var number = voiceReqList[i]['user_mobile'];
                      var pLen = number.length;
                      if (pLen == 10) {
                        number = '+91' + number;
                      }
                      Fun.call(number);
                    },
                    icon: Icon(
                      voiceReqList[i]['remark'].toString().contains('Complete') ? FontAwesomeIcons.solidCheckCircle: FontAwesomeIcons.phone,
                      color: voiceReqList[i]['remark'].toString().contains('Complete') ? Colors.green : MyColors.themeColor,
                    ),
                  ),
                )
              ]
            ] else ...[
              Widgets.sizedBox(40.h, 0),
              Center(
                child: Text('not have any voice request by you'),
              )
            ]
          ],
        ),
      );
    }

    return Widgets.scaffoldWithoutDrawer(
        'Voice Request', _viewScreen(), context, null);
  }
}
