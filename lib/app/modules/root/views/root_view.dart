/*
 * File name: root_view.dart
 * Last modified: 2022.10.16 at 12:23:15
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:beauty_salons_owner/common/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_widgets/custom_bottom_nav_bar.dart';
import '../../global_widgets/main_drawer_widget.dart';
import '../controllers/root_controller.dart';

class RootView extends GetView<RootController> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    controller.onInit();
    return Obx(() {
      return WillPopScope(
        onWillPop: controller.currentIndex.value!=0?()async{
          controller.currentIndex.value = 0;
          return Future.value();
        }:Helper().onWillPop,
        child: Scaffold(
          key: scaffoldKey,
          drawer: MainDrawerWidget(),
          body: controller.currentPage,
          /*bottomNavigationBar: CustomBottomNavigationBar(
            backgroundColor: context.theme.scaffoldBackgroundColor,
            itemColor: context.theme.colorScheme.secondary,
            currentIndex: controller.currentIndex.value,
            onChange: (index) {
              if(index!=3){
                controller.changePage(index);
              }else{
                scaffoldKey.currentState.openDrawer();
              }

            },
            children: [
              CustomBottomNavigationItem(
                icon: Icons.home_outlined,
                label: "Home".tr,
              ),
              CustomBottomNavigationItem(
                icon: Icons.star_border,
                label: "Reviews".tr,
              ),
              CustomBottomNavigationItem(
                icon: Icons.chat_outlined,
                label: "Chats".tr,
              ),
              CustomBottomNavigationItem(
                icon: Icons.person_outline,
                label: "Account".tr,
              ),
            ],
          ),*/
        ),
      );
    });
  }
}
