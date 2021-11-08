// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';
import 'package:horizontal_card_pager/card_item.dart';
import './archive.dart';
import './inbox.dart';
import './report_incident.dart';
import 'change_password.dart';
import '../theme/storage.dart';

class Cards extends Container {
  @override
  Widget build(BuildContext context) {
    List<CardItem> items = [
      IconTitleCardItem(
        text: 'reportIncidents'.tr,
        iconData: Icons.report,
      ),
      IconTitleCardItem(
        text: "Inbox".tr,
        iconData: Icons.inbox,
      ),
      IconTitleCardItem(
        text: "Archive".tr,
        iconData: Icons.archive,
      ),
      IconTitleCardItem(
        text: "Environment",
        iconData: Icons.agriculture,
      ),
      IconTitleCardItem(
        text: "ChangePassword".tr,
        iconData: Icons.password,
      ),
      IconTitleCardItem(
        text: "userProfile".tr,
        iconData: Icons.manage_accounts,
      ),
    ];

    return HorizontalCardPager(
      initialPage: 2,
      onPageChanged: (page) => print("page : $page"),
      onSelectedItem: (page) => OpenPage(page),
      items: items,
    );
  }
}

void OpenPage(page) {
  // OpenPage(int page);
  print('asasas' + page.toString());
  if (page.toString() == '1') {
    Get.to(InboxPage(), arguments: {'userId': box.read('userId').toString()});
  }
  if (page.toString() == '2') {
    // Get.offNamed('/archive');
    Get.to(Archive(), arguments: {'userId': box.read('userId').toString()});
  }
  if (page.toString() == '4') {
    // Get.offNamed('/archive');
    Get.to(ChangePassword(),
        arguments: {'userId': box.read('userId').toString()});
  }
  if (page.toString() == '0') {
    final List<String> records;
    Get.to(ReportIncident(
      onSaved: () => {},
      title: 'Report',
      records: '',
    ));
  }
}
