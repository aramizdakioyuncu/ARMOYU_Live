import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TurbopaymentWidget {
  static void paymentWidget(BuildContext context) {
    var counter = 0.obs;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    height: 150,
                    width: 450,
                    fit: BoxFit.cover,
                    imageUrl:
                        "https://t3.ftcdn.net/jpg/05/87/76/86/360_F_587768634_XDhjx96Xl5ao8QuD6thw4IeCvrxEdxFM.jpg",
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text("Planı Seç > Ödeme > İncele"),
                        const SizedBox(height: 10),
                        const Text(
                          """Sunucu Takviyeleri ile bir sunucunun havalı olmasına yardım et. İstediğin zaman satın alabilirsin, veya istediğin zaman iptal edebilirsin.""",
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () => counter.value < 1
                                        ? null
                                        : counter.value--,
                                    child: Container(
                                      width: 40,
                                      height: 30,
                                      color: Colors.grey.shade800,
                                      child: const Icon(
                                        Icons.remove,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    height: 30,
                                    child: Center(
                                      child: Obx(
                                        () => Text(
                                          counter.value.toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => counter.value++,
                                    child: Container(
                                      width: 40,
                                      height: 30,
                                      color: Colors.grey.shade800,
                                      child: const Icon(
                                        Icons.add,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: Center(
                                child: Text(
                                  "Sunucu Takviyesi",
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Center(
                                child: Text(
                                  "₺97,25 / Aylık",
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Ara Toplam",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Obx(
                              () => Text(
                                "₺${counter.value * 97.25}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            const Text(" / Ay"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Son fiyat ve para birimi, seçtiğin ödeme yöntemine göre değişebilir.",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.speed),
                                  Text(
                                    "Turbo ile her ay %20 indirimli alışveriş yapabilirsin.",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "ÖDEME YÖNTEMİ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const LinearBorder(),
                                  backgroundColor: Colors.grey.shade800,
                                ),
                                onPressed: () {},
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.credit_card),
                                    SizedBox(width: 5),
                                    Text("Kart"),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const LinearBorder(),
                                  backgroundColor: Colors.grey.shade800,
                                ),
                                onPressed: () {},
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.paypal_rounded),
                                    SizedBox(width: 5),
                                    Text("PayPal"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  label: const Text("Kart Numarası"),
                                  hintText: "Kart Numarası",
                                  filled: true,
                                  fillColor: Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    label: const Text("SON KULLANMA TARİHİ"),
                                    hintText: "AA/YY",
                                    filled: true,
                                    fillColor: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "Güvenlik Kodu",
                                    filled: true,
                                    fillColor: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  label: const Text("KARTIN ÜZERİNDEKİ İSİM"),
                                  hintText: "İsim",
                                  filled: true,
                                  fillColor: Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Ödeme işlemleri burada yapılacak
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                  shape: const LinearBorder(),
                  backgroundColor: Colors.grey.shade900),
              child: const Text("Vazgeç"),
            ),
            ElevatedButton(
              onPressed: () {
                // Ödeme işlemleri burada yapılacak
              },
              style: ElevatedButton.styleFrom(
                  shape: const LinearBorder(), backgroundColor: Colors.red),
              child: const Text("Ödeme Yap"),
            ),
          ],
        );
      },
    );
  }
}
