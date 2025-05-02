import 'package:armoyu_desktop/app/data/models/player_model.dart';
import 'package:armoyu_desktop/app/services/armoyu_services.dart';
import 'package:armoyu_desktop/app/widgets/profile_widget.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/sources/social/bundle/posts_bundle.dart';
import 'package:armoyu_widgets/sources/social/bundle/story_bundle.dart';
import 'package:get/get.dart';

class SocialController extends GetxController {
  late PostsWidgetBundle widgetposts;
  late StoryWidgetBundle widgetStory;
  @override
  void onInit() {
    super.onInit();

    widgetStory = ARMOYU.widget.social.widgetStorycircle();

    widgetposts = ARMOYU.widget.social.posts(
      context: Get.context!,
      profileFunction: (
          {required avatar,
          required banner,
          required displayname,
          required userID,
          required username}) {
        ProfileWidget.showProfileDialog(
          Get.context!,
          user: Player(
            user: User(
              userID: userID,
              displayName: displayname!.obs,
              userName: username.obs,
              avatar: avatar,
              banner: banner,
            ),
          ),
        );
      },
    );
  }
}
