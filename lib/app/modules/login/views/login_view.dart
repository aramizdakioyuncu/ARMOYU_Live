import 'package:armoyu_desktop/app/modules/login/controllers/login_controller.dart';
import 'package:armoyu_desktop/app/widgets/appbar_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 960;

        return Scaffold(
          backgroundColor: const Color(0xFF0A0A0A),
          body: Column(
            children: [
              AppbarWidget.buildAppBar(),
              Expanded(
                child: isCompact
                    ? Column(
                        children: [
                          SizedBox(
                            height: constraints.maxHeight < 720 ? 220 : 260,
                            child: _BrandingPanel(),
                          ),
                          Expanded(
                            child: _FormPanel(
                              controller: controller,
                              compact: true,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: _BrandingPanel(),
                          ),
                          Expanded(
                            flex: 4,
                            child: _FormPanel(controller: controller),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BrandingPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF180000),
            Color(0xFF0D0D0D),
            Color(0xFF130808),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -80,
            child: _DecorativeCircle(size: 320, opacity: 0.05),
          ),
          Positioned(
            bottom: -120,
            right: -70,
            child: _DecorativeCircle(size: 420, opacity: 0.04),
          ),
          Positioned(
            top: 180,
            right: 60,
            child: _DecorativeCircle(size: 130, opacity: 0.07),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1A1A1A),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://storage.aramizdakioyuncu.com/galeri/ana-yapi/armoyu64.png",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const SizedBox(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.games, color: Colors.red, size: 40),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  "ARMOYU",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Topluluğunu Bul, Grubuna Katıl",
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 13,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 56),
                const _FeatureRow(
                  icon: Icons.groups_outlined,
                  text: "Grup Sohbetleri",
                ),
                const SizedBox(height: 18),
                const _FeatureRow(
                  icon: Icons.mic_none_outlined,
                  text: "Sesli Odalar",
                ),
                const SizedBox(height: 18),
                const _FeatureRow(
                  icon: Icons.sports_esports_outlined,
                  text: "Oyun Toplulukları",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _DecorativeCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.red.withValues(alpha: opacity),
          width: 1.5,
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.red.withValues(alpha: 0.75), size: 17),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF777777),
            fontSize: 13,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _FormPanel extends StatelessWidget {
  final LoginController controller;
  final bool compact;

  const _FormPanel({required this.controller, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF111111),
      child: compact
          ? SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 340),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _LoginForm(controller: controller, compact: true),
                  ),
                ),
              ),
            )
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 340),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: _LoginForm(controller: controller),
                ),
              ),
            ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final LoginController controller;
  final bool compact;

  const _LoginForm({required this.controller, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
          compact ? MainAxisAlignment.start : MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hoş Geldin",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "Hesabına giriş yap",
          style: TextStyle(
            color: Color(0xFF555555),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 40),
        const _InputLabel("KULLANICI ADI"),
        const SizedBox(height: 8),
        _InputField(
          controller: controller.usernameController.value,
          hintText: "Kullanıcı adını gir",
          prefixIcon: Icons.person_outline,
          autofocus: true,
          onSubmitted: (_) => controller.login(
            controller.usernameController.value.text,
            controller.userpasswordController.value.text,
          ),
        ),
        const SizedBox(height: 20),
        const _InputLabel("PAROLA"),
        const SizedBox(height: 8),
        Obx(
          () => _InputField(
            controller: controller.userpasswordController.value,
            hintText: "Parolayı gir",
            prefixIcon: Icons.lock_outline,
            obscureText: !controller.isPasswordVisible.value,
            onSubmitted: (_) => controller.login(
              controller.usernameController.value.text,
              controller.userpasswordController.value.text,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordVisible.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF555555),
                size: 18,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Obx(
          () => CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: controller.rememberPassword.value,
            onChanged: (value) {
              controller.rememberPassword.value = value ?? false;
            },
            title: const Text(
              "Şifremi hatırla",
              style: TextStyle(
                color: Color(0xFFCCCCCC),
                fontSize: 13,
              ),
            ),
            activeColor: Colors.red,
            checkColor: Colors.white,
            dense: true,
          ),
        ),
        Obx(
          () => controller.loginErrorMessage.value == null
              ? const SizedBox.shrink()
              : Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A1414),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: Colors.red.withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: Colors.red, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.loginErrorMessage.value!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        const SizedBox(height: 32),
        Obx(
          () => _LoginButton(
            isLoading: controller.loginprocess.value,
            onPressed: controller.loginprocess.value
                ? null
                : () => controller.login(
                      controller.usernameController.value.text,
                      controller.userpasswordController.value.text,
                    ),
          ),
        ),
        const SizedBox(height: 40),
        Center(
          child: Text(
            "v1.0.0.0",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.12),
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

class _InputLabel extends StatelessWidget {
  final String text;

  const _InputLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF777777),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final bool autofocus;
  final Widget? suffixIcon;
  final ValueChanged<String>? onSubmitted;

  const _InputField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.autofocus = false,
    this.suffixIcon,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      autofocus: autofocus,
      onSubmitted: onSubmitted,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF3A3A3A), fontSize: 14),
        prefixIcon: Icon(prefixIcon, color: const Color(0xFF4A4A4A), size: 18),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF252525)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF252525)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _LoginButton({required this.onPressed, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          disabledBackgroundColor: Colors.red.withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Giriş Yap",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
