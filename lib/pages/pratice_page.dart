import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dj/extension.dart';
import 'package:flutter_dj/helper/snackbar_helper.dart';
import 'package:flutter_dj/model/app_model.dart';
import 'package:flutter_dj/pages/setting_page.dart';
import 'package:flutter_dj/simple_widget/simple_button.dart';
import 'package:flutter_dj/simple_widget/simple_text.dart';
import 'package:provider/provider.dart';

enum PraticeType {
  co2,
  o2,
}

class PraticePageViewmodel extends ChangeNotifier {
  bool _isCounting = false;
  bool get isCounting => _isCounting;
  set isCounting(newValue) {
    _isCounting = newValue;
    if (newValue) {
      startTimer();
    }
    notifyListeners();
  }

  PraticeType _type = PraticeType.co2;
  PraticeType get type => _type;
  set type(newValue) {
    _type = newValue;
    maxTime = maxTime;
    notifyListeners();
  }

  toggleType(PraticeType ttype) {
    type = ttype;
  }

  var second = 1;

  int _maxTime = 0;
  int get maxTime => _maxTime;
  set maxTime(newValue) {
    _maxTime = newValue;

    switch (type) {
      case PraticeType.co2:
        var breathTimeBaseline = 150;
        List<int> copyList = List.from(breathTimeList);

        for (var i = 0; i < copyList.length; i++) {
          copyList[i] = breathTimeBaseline - 15 * i;
        }

        _breathTimeList = copyList;

        List<int> copyHoldList = List.from(_holdTimeList);

        for (var i = 0; i < copyHoldList.length; i++) {
          copyHoldList[i] = _maxTime ~/ 2;
        }
        _holdTimeList = copyHoldList;

        break;
      case PraticeType.o2:
        var breathTimeBaseline = 120;
        List<int> copyList = List.from(breathTimeList);

        for (var i = 0; i < copyList.length; i++) {
          copyList[i] = breathTimeBaseline;
        }

        _breathTimeList = copyList;

        List<int> copyHoldList = List.from(_holdTimeList);

        for (var i = 0; i < copyHoldList.length; i++) {
          var tempTime = int.parse(_maxTime.toString());
          switch (i) {
            case 0:
              double multipliedDouble = tempTime * 0.3;
              copyHoldList[i] = multipliedDouble.toInt();
            case 1:
              double multipliedDouble = tempTime * 0.4;
              copyHoldList[i] = multipliedDouble.toInt();
            case 2:
              double multipliedDouble = tempTime * 0.5;
              copyHoldList[i] = multipliedDouble.toInt();
            case 3:
              double multipliedDouble = tempTime * 0.58;
              copyHoldList[i] = multipliedDouble.toInt();
            case 4:
              double multipliedDouble = tempTime * 0.66;
              copyHoldList[i] = multipliedDouble.toInt();
            case 5:
              double multipliedDouble = tempTime * 0.75;
              copyHoldList[i] = multipliedDouble.toInt();
            case 6:
              double multipliedDouble = tempTime * 0.83;
              copyHoldList[i] = multipliedDouble.toInt();
            case 7:
              double multipliedDouble = tempTime * 0.83;
              copyHoldList[i] = multipliedDouble.toInt();
              break;
          }
        }
        _holdTimeList = copyHoldList;

        break;
    }

    notifyListeners();
  }

  List<int> _holdTimeList = [0, 0, 0, 0, 0, 0, 0, 0];
  List<int> get holdTimeList => _holdTimeList;
  set holdTimeList(newValue) {
    _holdTimeList = newValue;
    notifyListeners();
  }

  List<int> _breathTimeList = [0, 0, 0, 0, 0, 0, 0, 0];
  List<int> get breathTimeList => _breathTimeList;
  set breathTimeList(newValue) {
    _breathTimeList = newValue;
    notifyListeners();
  }

  Timer? _timer;

  updateTime(int count) {
    //雙數是呼吸
    if (count % 2 == 0) {
      List<int> tempBreathList = List.from(breathTimeList);
      for (var i = 0; i <= count; i++) {
        if (tempBreathList[i] != 0) {
          tempBreathList[i] = tempBreathList[i] - second;
          if (tempBreathList[i] <= 0) {
            tempBreathList[i] = 0;
            currentCount += 1;
          }
          break;
        }
      }
      breathTimeList = tempBreathList;
    } else {
      //單數是閉氣
      List<int> tempHoldList = List.from(holdTimeList);
      for (var i = 0; i <= count; i++) {
        if (tempHoldList[i] != 0) {
          tempHoldList[i] = tempHoldList[i] - second;
          if (tempHoldList[i] <= 0) {
            tempHoldList[i] = 0;
            currentCount += 1;
          }
          break;
        }
      }
      holdTimeList = tempHoldList;
    }
  }

  var currentCount = 0;

  resetAll() {
    currentCount = 0;
    isCounting = false;
    _timer?.cancel();

    List<int> copyList = List.from(breathTimeList);
    var breathTimeBaseline = 150;
    for (var i = 0; i < copyList.length; i++) {
      copyList[i] = breathTimeBaseline - 15 * i;
    }

    _breathTimeList = copyList;

    List<int> copyHoldList = List.from(_holdTimeList);

    for (var i = 0; i < copyHoldList.length; i++) {
      copyHoldList[i] = _maxTime ~/ 2;
    }
    _holdTimeList = copyHoldList;
  }

  startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentCount > (breathTimeList.length + holdTimeList.length) - 1) {
        _timer?.cancel();
        resetAll();
      } else {
        updateTime(currentCount);
      }
    });
  }
}

class PraticePage extends StatefulWidget {
  const PraticePage({super.key});

  @override
  State<PraticePage> createState() => _PraticePageState();
}

class _PraticePageState extends State<PraticePage> {
  final PraticePageViewmodel viewModel = PraticePageViewmodel();

  @override
  Widget build(BuildContext context) {
    var appModel = context.read<AppModel>();
    viewModel.maxTime = 120;
    final lostLifeLabel = Selector<AppModel, int>(
        selector: (p0, p1) => p1.life,
        builder: (context, lostLife, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SimpleText(
                text: "剩餘訓練次數：$lostLife次",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                align: TextAlign.right,
              ).padding(),
            ],
          );
        });

    final maxTimeLabel = Selector<PraticePageViewmodel, int>(
        selector: (p0, p1) => p1.maxTime,
        builder: (context, maxTime, child) {
          return [
            SimpleText(
              text:
                  "${(maxTime ~/ 60).toString().padLeft(2, '0')}:${(maxTime % 60).toString().padLeft(2, '0')}",
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )
          ].row().padding();
        });

    final changeTypeMaxTimeRow = Selector<PraticePageViewmodel, PraticeType>(
      selector: (p0, p1) => p1.type,
      builder: (context, type, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SimpleButton(
              buttontitle: "CO2",
              backgroundColor:
                  type == PraticeType.co2 ? Colors.green : Colors.transparent,
              cornerRadius: 15,
              fontSize: 24,
              buttonAction: () {
                viewModel.toggleType(PraticeType.co2);
              },
            ),
            maxTimeLabel.flexible(),
            SimpleButton(
              buttontitle: "O2",
              backgroundColor:
                  type == PraticeType.o2 ? Colors.green : Colors.transparent,
              fontSize: 24,
              cornerRadius: 15,
              buttonAction: () {
                viewModel.toggleType(PraticeType.o2);
              },
            ),
          ],
        ).padding();
      },
    );

    final slider = Column(
      children: [
        const SimpleText(
          text: "請輸入您最佳的閉氣時間，並選擇訓練模式",
          align: TextAlign.center,
          fontSize: 16,
        ),
        Selector<PraticePageViewmodel, int>(
            selector: (p0, p1) => p1.maxTime,
            builder: (context, maxTime, child) {
              return Slider(
                min: 0.0,
                max: 60 * 10,
                value: maxTime.toDouble(),
                onChanged: (newValue) {
                  viewModel.maxTime = newValue.toInt();
                },
              );
            }),
      ],
    );

    final breathColumn = Column(
      children: [
        Selector<PraticePageViewmodel, List<int>>(
            selector: (p0, p1) => p1.breathTimeList,
            builder: (context, breathTimeList, child) {
              var textList = breathTimeList
                  .map((e) => SimpleText(
                        text:
                            "${(e ~/ 60).toString().padLeft(2, '0')}:${(e % 60).toString().padLeft(2, '0')}",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ))
                  .toList();
              return Column(
                children: textList..insert(0, const SimpleText(text: "呼吸")),
              );
            }),
      ],
    );

    final holdColumn = Column(
      children: [
        Selector<PraticePageViewmodel, List<int>>(
            selector: (p0, p1) => p1.holdTimeList,
            builder: (context, holdTimeList, child) {
              var textList = holdTimeList
                  .map((e) => SimpleText(
                        text:
                            "${(e ~/ 60).toString().padLeft(2, '0')}:${(e % 60).toString().padLeft(2, '0')}",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ))
                  .toList();
              return Column(
                children: textList..insert(0, const SimpleText(text: "閉氣")),
              );
            }),
      ],
    );

    final timeRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [breathColumn.flexible(), holdColumn.flexible()],
    );

    final startButton = Selector<PraticePageViewmodel, bool>(
      selector: (p0, p1) => p1.isCounting,
      builder: (context, isCounting, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SimpleButton(
              buttontitle: isCounting ? "結束" : "開始",
              titleColor: Colors.black,
              fontSize: 22,
              cornerRadius: 15,
              buttonMiniSize: const Size(200, 45),
              backgroundColor: isCounting ? Colors.red : Colors.green,
              buttonAction: () async {
                if (appModel.life <= 0 && !isCounting) {
                  showAppSnackBar("沒有額度囉，請至設定頁購買。", context);
                  return;
                }
                viewModel.isCounting = !viewModel.isCounting;
                if (!viewModel.isCounting) {
                  viewModel.resetAll();
                } else {
                  context.read<AppModel>().saveData(addLife: -1);
                }
              },
            ).padding(),
          ],
        ); // replace this with your desired widget
      },
    );

    return ChangeNotifierProvider<PraticePageViewmodel>.value(
      value: viewModel,
      builder: (context, child) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text("潛水訓練器"),
              actions: [
                SimpleButton(
                  buttonIcon: Icons.settings,
                  borderColor: Colors.transparent,
                  iconColor: Colors.black,
                  buttonAction: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SettingPage(),
                    ));
                  },
                )
              ],
            ),
            body: Column(
              children: [
                lostLifeLabel,
                slider,
                changeTypeMaxTimeRow,
                startButton,
                timeRow,
              ],
            ).singleChildScrollView()); // replace this with your desired widget
      },
    );
  }
}
