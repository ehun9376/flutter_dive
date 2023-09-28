import 'package:flutter/material.dart';
import 'package:flutter_dj/extension.dart';
import 'package:flutter_dj/model/app_model.dart';
import 'package:flutter_dj/simple_widget/simple_button.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("設定"),
      ),
      body: Selector<AppModel, List<DataModel>>(
          selector: (p0, p1) => p1.dataModels,
          builder: (context, list, child) {
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return createRow(list[index]);
              },
            );
          }),
    );
  }

  Widget createRow(DataModel model) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SimpleButton(
              buttontitle: "點我購買 ${model.title}",
              fontSize: 20,
              buttonIcon: Icons.business_center_outlined,
              iconSize: 30,
              segmented: Segmented.leftToRight,
              imageTextSpace: 20,
              buttonAction: () {
                //TODO: - IAP
              },
            ),
          ],
        ),
        Container(
          color: Colors.grey[500],
          height: 2,
        )
      ],
    ).padding();
  }
}
