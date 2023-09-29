import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dj/extension.dart';
import 'package:flutter_dj/model/app_model.dart';
import 'package:flutter_dj/pages/setting_page.dart';
import 'package:flutter_dj/simple_widget/simple_button.dart';
import 'package:flutter_dj/simple_widget/simple_text.dart';
import 'package:provider/provider.dart';

class PraticePageViewmodel extends ChangeNotifier {
  bool _isCounting = false;
  bool get isCounting => _isCounting;
  set isCounting(newValue) {
    _isCounting = newValue;
    notifyListeners();
  }

  int _maxTime = 120;
  int get maxTime => _maxTime;
  set maxTime(newValue) {
    _maxTime = newValue;

    List<int> copyList = List.from(breathTimeList);

    var breathTimeBaseline = 150;
    for (var i = 0; i < copyList.length; i++) {
      copyList[i] = breathTimeBaseline - 15 * i;
    }

    _breathTimeList = copyList;

    List<int> copyHoldList = List.from(_holdTimeList);

    for (var i = 0; i < copyHoldList.length; i++) {
      copyHoldList[i] = newValue ~/ 2;
    }
    _holdTimeList = copyHoldList;

    notifyListeners();
  }

  List<int> _holdTimeList = [0, 0, 0, 0, 0, 0, 0, 0];
  List<int> get holdTimeList => _holdTimeList;
  set bholdTimeList(newValue) {
    _holdTimeList = newValue;
    notifyListeners();
  }

  List<int> _breathTimeList = [0, 0, 0, 0, 0, 0, 0, 0];
  List<int> get breathTimeList => _breathTimeList;
  set breathTimeList(newValue) {
    _breathTimeList = newValue;
    notifyListeners();
  }
}

class PraticePage extends StatefulWidget {
  PraticePage({super.key});

  @override
  State<PraticePage> createState() => _PraticePageState();
}

class _PraticePageState extends State<PraticePage> {
  final PraticePageViewmodel viewModel = PraticePageViewmodel();

  @override
  Widget build(BuildContext context) {
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

    final slider = Selector<PraticePageViewmodel, int>(
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
        });

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
                children: textList,
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
                children: textList,
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
              buttonAction: () {
                viewModel.isCounting = !viewModel.isCounting;
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
                maxTimeLabel,
                slider,
                startButton,
                timeRow
              ],
            ).singleChildScrollView()); // replace this with your desired widget
      },
    );
  }
}
