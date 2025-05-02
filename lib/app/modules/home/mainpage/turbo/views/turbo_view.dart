import 'package:armoyu_desktop/app/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TurboView extends StatelessWidget {
  const TurboView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppbarWidget.buildAppBar(label: "TURBO"),
          const Text(
            "Bir sunucuya takviye yap ve herkes için avantajlar aç",
            style: TextStyle(color: Colors.amber),
          ),
          const CircleAvatar(),
          const Text("sunucu adı"),
          const Text("nitro yok"),
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Bu Sunucuya Nitro Al"),
          ),
          const SizedBox(
            width: 500,
            child: LinearProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
