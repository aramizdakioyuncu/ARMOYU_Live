import 'package:armoyu_desktop/app/services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServersController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  Rxn<List<APIGroupListDetail>> groupList = Rxn();
  var groupproccess = false.obs;
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 7, vsync: this);

    fetchgroups();
  }

  fetchgroups() async {
    if (groupproccess.value) {
      return;
    }

    groupproccess.value = true;
    GroupListResponse response =
        await ARMOYU.service.groupServices.groupList(page: 1);

    groupproccess.value = false;

    if (!response.result.status) {
      return;
    }
    groupList.value ??= [];
    for (APIGroupListDetail element in response.response!.groups) {
      groupList.value!.add(element);
    }
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
  }
}
