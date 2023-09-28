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
    notifyListeners();
  }
}

class PraticePage extends StatelessWidget {
  PraticePage({super.key});

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
              text: "${viewModel.maxTime ~/ 60}:${viewModel.maxTime % 60}",
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
              children: [lostLifeLabel, maxTimeLabel, slider, startButton],
            ).singleChildScrollView()); // replace this with your desired widget
      },
    );
  }
}