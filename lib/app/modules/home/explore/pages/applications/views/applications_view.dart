import 'package:armoyu_desktop/app/modules/home/explore/pages/applications/controllers/applications_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplicationsView extends StatelessWidget {
  const ApplicationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ApplicationsController());
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 900;

        return Scaffold(
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade900,
                      Colors.blue.shade700,
                      Colors.blue.shade500,
                      Colors.blue.shade300,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                width: double.infinity,
                height: isCompact ? 220 : 250,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TabBar(
                                controller: controller.tabController,
                                dividerColor: Colors.amber,
                                dividerHeight: 0,
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.white60,
                                labelPadding: const EdgeInsets.all(10),
                                indicatorColor: Colors.amber,
                                tabAlignment: TabAlignment.start,
                                isScrollable: true,
                                tabs: const [
                                  Text("Öne Çıkanlar"),
                                  Text("Oyunlar"),
                                  Text("Eğlence"),
                                  Text("Moderasyon ve Araçlar"),
                                  Text("Sosyal"),
                                  Text("Yardımcı"),
                                ],
                              ),
                            ),
                          ),
                          if (!isCompact)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SearchBar(
                                constraints: BoxConstraints(maxWidth: 200),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              """KEYFİNE BAK
                        ANIN TADINI ÇIKAR""",
                              style: TextStyle(
                                fontSize: isCompact ? 32 : 50,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              """Sana uygun oyun ve araçlarla daha kaliteli vakit geçir.""",
                              style: TextStyle(
                                color: Colors.white70,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: isCompact ? 320 : 300,
                    mainAxisExtent: 290,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: CachedNetworkImage(
                                    height: 150,
                                    width: double.infinity,
                                    imageUrl:
                                        "https://imgs.crazygames.com/farm-merge-valley_16x9/20250317164207/farm-merge-valley_16x9-cover?metadata=none&quality=40&width=1200&height=630&fit=crop",
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: -20,
                                  left: 20,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade800,
                                      image: const DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          "https://imgs.crazygames.com/farm-merge-valley_16x9/20250317164207/farm-merge-valley_16x9-cover?metadata=none&quality=40&width=1200&height=630&fit=crop",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Farm Merge Valley",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Oyunlar",
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    child: Text(
                                      "Farm, merge, grow and expand your land! Welcome to the world of farming that gets",
                                      style: TextStyle(color: Colors.white70),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
