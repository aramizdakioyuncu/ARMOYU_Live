import 'package:armoyu_desktop/app/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TurboView extends StatelessWidget {
  const TurboView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppbarWidget.buildAppBar(label: "TURBO"),
                  const SizedBox(height: 24),
                  const Text(
                    "Bir sunucuya takviye yap ve herkes için avantajlar aç",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.amber),
                  ),
                  const SizedBox(height: 16),
                  const CircleAvatar(),
                  const SizedBox(height: 8),
                  const Text("sunucu adı"),
                  const Text("nitro yok"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Bu Sunucuya Nitro Al"),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(
                    width: double.infinity,
                    child: LinearProgressIndicator(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
