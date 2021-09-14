import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sewa/backend_work/apis.dart';
import 'package:sewa/common/colors.dart';
import 'package:sewa/common/functions.dart';
import 'package:sewa/common/widgets.dart';
import 'package:sewa/ui/common/img_view.dart';
import 'package:sizer/sizer.dart';

import '../../common/icons.dart';
import '../../common/variables.dart' as Variables;

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  /*FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  final String _mPath = 'flutter_sound_example.aac';

  String _recorderTxt = '00:00:00';
  String _playerTxt = '00:00:00';
  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;

  @override
  void initState() {
    _mPlayer!.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _mPlayer!.closeAudioSession();
    _mPlayer = null;

    _mRecorder!.closeAudioSession();
    _mRecorder = null;
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openAudioSession();
    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  void record() {
    _mRecorder!
        .startRecorder(
      toFile: _mPath,
    )
        .then((value) {
      setState(() {});
    });

    _mRecorder!.onProgress!.listen((e) {
      var date = DateTime.fromMillisecondsSinceEpoch(e.duration.inMilliseconds,
          isUtc: true);
      var txt = DateFormat('mm:ss:SS').format(date);

      setState(() {
        _recorderTxt = txt.substring(0, 8);
      });
    });
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      setState(() {
        print(value);
        _mplaybackReady = true;
      });
    });
  }

  void play() {
    print('in Play');
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder!.isStopped &&
        _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
            fromURI: _mPath,
            whenFinished: () {
              setState(() {});
            })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {});
    });
  }

  getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
      return null;
    }
    return _mRecorder!.isStopped ? record : stopRecorder;
  }

  getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return _mPlayer!.isStopped ? play : stopPlayer;
  }

  Future<void> seekToPlayer(int milliSecs) async {
    //playerModule.logger.d('-->seekToPlayer');
    try {
      if (_mPlayer!.isPlaying) {
        await _mPlayer!.seekToPlayer(Duration(milliseconds: milliSecs));
      }
    } on Exception catch (err) {
      _mPlayer!.logger.e('error: $err');
    }
    setState(() {});
    //playerModule.logger.d('<--seekToPlayer');
  }
*/

  late Track track;
  String? recordingFile;
  bool loading = true;
  List cityList = [], voiceReqList = [];
  List<bool> isPlaying = [];
  var _city;
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();

  bool _error = false;
  bool _isSelected = false;
  bool _isVoice = false;

  var img;

  @override
  void initState() {
    getCity();
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
    super.initState();
    if (!kIsWeb) {
      getTemporaryDirectory().then((val) {
        var path = '${val.path}/recorded_message.aac';
        Directory(dirname(path)).createSync(recursive: true);
        recordingFile = path;
        track = Track(trackPath: recordingFile);
        loading = false;
        setState(() {});
      });
    }
  }

  void _clean() async {
    if (recordingFile != null) {
      try {
        await File(recordingFile!).delete();
        setState(() {});
      } on Exception {
        // ignore
      }
    }
  }

  _sent(context) async {
    if (_city == null) {
      _error = true;
    } else {
      _error = false;
    }
    setState(() {});

    if (!_error) {
      var data;
      EasyLoading.show(
          status: 'Loading....', maskType: EasyLoadingMaskType.black);
      if (img == null) {
        if (File(recordingFile!).existsSync()) {
          var request = http.MultipartRequest('POST', Api.insertData);
          var multiPartFile = await http.MultipartFile.fromPath(
            "audio",
            recordingFile!,
            contentType: MediaType("audio", "aac"),
          );
          request.fields['insert_data'] = 'voice_req';
          request.fields['user'] = Variables.userUId;
          request.fields['city'] = _city;
          request.files.add(multiPartFile);

          final response = await request.send();
          data = await response.stream.bytesToString();
        } else {
          EasyLoading.showError('First Record voice',
              maskType: EasyLoadingMaskType.black);
        }
      } else {
        var request = http.MultipartRequest('POST', Api.insertData);
        var multiPartFile = await http.MultipartFile.fromPath(
          "img",
          img.path,
        );
        request.fields['insert_data'] = 'img_req';
        request.fields['user'] = Variables.userUId;
        request.fields['city'] = _city;
        request.files.add(multiPartFile);

        final response = await request.send();
        data = await response.stream.bytesToString();
      }
      EasyLoading.dismiss();
      if (data.contains('error')) {
        EasyLoading.showError(
            'some thing is wrong please contact customer care ');
      } else {
        EasyLoading.showSuccess('Successfully sent your voice Request');
        Navigator.pushReplacementNamed(context, Variables.Links.userHome);
      }
    }
  }

  _imagePick() async {
    final picker = ImagePicker();
    var pickedImage = await picker.getImage(
      source: ImageSource.gallery,
    );
    return File(pickedImage!.path);
  }

  getCity() async {
    var response = await http.post(Api.getData, body: {"get_data": "city"});
    var jsonData = jsonDecode(response.body);
    setState(() {
      cityList = jsonData;
    });
  }

  getVoiceReq() async {
    EasyLoading.show(
        status: 'Loading.....', maskType: EasyLoadingMaskType.black);
    var response = await http.post(Api.getData, body: {
      "get_data": "voiceReqUser",
      "user_id": Variables.userUId,
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
  void dispose() {
    _clean();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _speakScreen() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loading ? Container() : _buildRecorder(context),
          ],
        ),
      );
    }

    Widget _viewScreen() {
      return Center(
        child: ListView(
          children: [
            if (voiceReqList.length > 0) ...[
              for (int i = 0; i < voiceReqList.length; i++) ...[
                Widgets.sizedBox(10, 0),
                ListTile(
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
                              _mPlayer!.setSubscriptionDuration(
                                  Duration(minutes: 5));
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
                              isPlaying[i]
                                  ? Icons.stop_circle_outlined
                                  : Icons.play_circle_outline_rounded,
                              color: MyColors.highlightColor),
                        ),
                  title: Text(
                      'Vendor : ${voiceReqList[i]['vendor_name'] ?? 'not appoint'}'),
                  subtitle: Text(
                      'From : ${voiceReqList[i]['city_name']}\nRemark : ${(voiceReqList[i]['remark'] ?? '-')}'),
                  trailing: IconButton(
                    onPressed: voiceReqList[i]['remark'] == 'Complete' || voiceReqList[i]['isCancel'] == '1' ? null : () {
                      var number =
                          voiceReqList[i]['vendor_mobile'] ?? '7974704221';
                      var pLen = number.length;
                      if (pLen == 10) {
                        number = '+91' + number;
                      }
                      Fun.call(number);
                    },
                    icon: Icon(
                      voiceReqList[i]['remark'] == "Complete"
                          ? FontAwesomeIcons.solidCheckCircle
                          : voiceReqList[i]['isCancel'] == '1'
                          ? FontAwesomeIcons.solidTimesCircle
                          : FontAwesomeIcons.phone,
                      color: voiceReqList[i]['remark'] == "Complete"
                          ? Colors.green
                          : voiceReqList[i]['isCancel'] == '1'
                          ? Colors.red
                          : MyColors.themeColor,
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Voice Requests'),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelStyle: TextStyle(fontSize: 0),
            tabs: [
              Tab(
                text: 'View',
                icon: Icon(
                  MyIcons.service,
                  color: Colors.white,
                ),
              ),
              Tab(
                text: 'Speak',
                icon: Icon(
                  MyIcons.mic,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _viewScreen(),
            _speakScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecorder(context) {
    return RecorderPlaybackController(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              value: _city,
              icon: Icon(
                MyIcons.down,
                color: _error ? Theme.of(context).errorColor : Colors.black,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              validator: (_) => _error ? ' Select city first' : null,
              autovalidateMode: AutovalidateMode.always,
              hint: Text('Select City'),
              items: cityList.map(
                (list) {
                  return DropdownMenuItem(
                    child: Text(
                      list['city'].toString(),
                    ),
                    value: list['id'].toString(),
                  );
                },
              ).toList(),
              onChanged: (dynamic value) {
                setState(() {
                  _error = false;
                  _city = value;
                });
              },
            ),
          ),
          if (_isSelected) ...[
            if (_isVoice) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SoundRecorderUI(
                  track,
                  backgroundColor: Colors.blueGrey.shade100,
                  showTrashCan: false,
                  recordingTitle: 'Recording....',
                  stoppedTitle: 'Press "RED" button to start',
                  pausedTitle: 'Recording is Paused',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SoundPlayerUI.fromTrack(
                  track,
                  enabled: false,
                  audioFocus: AudioFocus.requestFocusAndDuckOthers,
                  backgroundColor: Colors.blueGrey.shade100,
                  sliderThemeData: SliderThemeData(
                    activeTrackColor: MyColors.normalColor,
                    thumbColor: MyColors.normalColor,
                  ),
                ),
              ),
            ] else ...[
              Center(
                child: Container(
                  height: 150,
                  width: 150,
                  child: Image.file(
                    img,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async => await _sent(context),
                  icon: Icon(MyIcons.share),
                  label: Text('Sent'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    _isSelected = false;
                    setState(() {});
                  },
                  icon: Icon(MyIcons.back),
                  label: Text('back'),
                ),
              ],
            ),
          ] else ...[
            Text('Select any mode of request you went'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  elevation: 5,
                  child: InkWell(
                    onTap: () async {
                      img = await _imagePick();
                      setState(() {
                        _isSelected = true;
                        _isVoice = false;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Icon(Icons.camera_alt),
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isSelected = true;
                        _isVoice = true;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Icon(Icons.mic),
                    ),
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}
