import 'package:armoyu_desktop/app/services/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsAppearanceView extends StatelessWidget {
  const SettingsAppearanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ThemeController>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TEMA',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Uygulamanın görünümünü açık ya da koyu moda göre değiştir.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => Card(
                child: Column(
                  children: [
                    ListTile(
                      onTap: controller.enableDarkTheme,
                      leading: Icon(
                        Icons.dark_mode,
                        color: controller.isDarkMode
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                      ),
                      title: const Text('Koyu Tema'),
                      subtitle:
                          const Text('Daha düşük parlaklıkta koyu görünüm.'),
                      trailing: controller.isDarkMode
                          ? Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : const Icon(Icons.circle_outlined),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      onTap: controller.enableLightTheme,
                      leading: Icon(
                        Icons.light_mode,
                        color: controller.isDarkMode
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text('Açık Tema'),
                      subtitle: const Text('Aydınlık ve daha parlak görünüm.'),
                      trailing: controller.isDarkMode
                          ? const Icon(Icons.circle_outlined)
                          : Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: controller.isDarkMode,
                onChanged: controller.toggleTheme,
                title: const Text('Koyu tema kullan'),
                subtitle: const Text('Açık ve koyu arasında hızlı geçiş yap.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
