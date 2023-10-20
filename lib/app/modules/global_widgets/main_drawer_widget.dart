/*
 * File name: main_drawer_widget.dart
 * Last modified: 2022.10.16 at 12:23:15
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:beauty_salons_owner/app/models/salon_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../common/ui.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/settings_service.dart';
import '../custom_pages/views/custom_page_drawer_link_widget.dart';
import '../insights/controllers/insight_controller.dart';
import '../root/controllers/root_controller.dart' show RootController;
import 'drawer_link_widget.dart';

class MainDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //print("dataCheck${Get.isRegistered<RootController>()&&Get.find<RootController>().salons.length>0}");
    //print("${Get.find<RootController>().salons.first.subscriptionEndDate}");
    return Drawer(
      elevation: 0,
      child: ListView(
        children: [
          Obx(() {
            if (!Get.find<AuthService>().isAuth) {
              return GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.LOGIN);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withOpacity(0.1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome".tr, style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.colorScheme.secondary))),
                      SizedBox(height: 5),
                      Text("Login account or create new one for free".tr, style: Get.textTheme.bodyText1),
                      SizedBox(height: 15),
                      Wrap(
                        spacing: 10,
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () {
                              Get.toNamed(Routes.LOGIN);
                            },
                            color: Get.theme.colorScheme.secondary,
                            height: 40,
                            elevation: 0,
                            child: Wrap(
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 9,
                              children: [
                                Icon(Icons.exit_to_app_outlined, color: Get.theme.primaryColor, size: 24),
                                Text(
                                  "Login".tr,
                                  style: Get.textTheme.subtitle1.merge(TextStyle(color: Get.theme.primaryColor)),
                                ),
                              ],
                            ),
                            shape: StadiumBorder(),
                          ),
                          MaterialButton(
                            color: Get.theme.focusColor.withOpacity(0.2),
                            height: 40,
                            elevation: 0,
                            onPressed: () {
                              Get.toNamed(Routes.REGISTER);
                            },
                            child: Wrap(
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 9,
                              children: [
                                Icon(Icons.person_add_outlined, color: Get.theme.hintColor, size: 24),
                                Text(
                                  "Register".tr,
                                  style: Get.textTheme.subtitle1.merge(TextStyle(color: Get.theme.hintColor)),
                                ),
                              ],
                            ),
                            shape: StadiumBorder(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () {
                  Get.find<RootController>().changePageOutRoot(3);
                },
                child: Column(
                  children: [
                    UserAccountsDrawerHeader(
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withOpacity(0.1),
                      ),
                      accountName: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Get.find<AuthService>().user.value.name,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                      accountEmail: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Get.find<AuthService>().user.value.email,
                            style: Theme.of(context).textTheme.caption.copyWith(
                              fontSize: 16
                            ),
                          ),
                        ],
                      ),
                      otherAccountsPictures: [
                        SizedBox(),
                      ],
                      currentAccountPictureSize: Size(MediaQuery.of(context).size.width*.7,80),
                      currentAccountPicture: Column(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(80)),
                                  child: CachedNetworkImage(
                                    height: 80,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    imageUrl: Get.find<AuthService>().user.value.avatar.thumb,
                                    placeholder: (context, url) => Image.asset(
                                      'assets/img/loading.gif',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 80,
                                    ),
                                    errorWidget: (context, url, error) => Icon(Icons.person,size: 32,),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Get.find<AuthService>().user.value.verifiedPhone ?? false
                                      ? Icon(Icons.check_circle, color: Colors.green, size: 24)
                                      : SizedBox(),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                Obx(() =>Get.isRegistered<RootController>()&&!Get.find<RootController>().loading.value&&Get.find<RootController>().salons.length>0?
                Column(
                      children: [

                    Obx(() => Get.find<RootController>().salons.first.subscription?Container(

                        //  height: 40,
                          color: Get.theme.colorScheme.primary,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                flex:2,
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    "Subscribed",
                                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex:3,
                                child: Container(
                                  color: Get.theme.colorScheme.primary,
                                  padding: EdgeInsets.all(10.0),
                               //   height: 40,
                                  width: double.infinity,
                                  child: Text(
                                    "Valid Till - ${Get.find<RootController>().salons.first.subscriptionEndDate}",
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ):
                        Container(
                          //  height: 40,
                          color: Get.theme.colorScheme.primary,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    "Subscribe to go online",
                                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: (){

                                  Get.find<RootController>().razorPayment(context);
                                },
                                child: Container(
                                  color: Colors.green,
                                  padding: EdgeInsets.all(10.0),
                                  width: 100,
                                  //   height: 40,
                                  child: Text(
                                    "Subscribe",
                                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),),
                        Divider(
                          color: Colors.white,
                          height: 1,
                        ),
                        Container(
                          color: Get.theme.colorScheme.primary,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    "Partner ID - ${Get.find<RootController>().salons.first.code}",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                               !Get.find<RootController>().salons.first.subscription?InkWell(
                                onTap: (){

                                  Get.find<RootController>().razorPayment(context);
                                },
                                child: Container(
                                  width: 100,
                                  color: Colors.white,
                                  padding: EdgeInsets.all(10.0),
                                  //   height: 40,
                                  child: Text(
                                    "₹${Get.find<SettingsService>().setting.value.subscriptionAmount}/${Get.find<SettingsService>().setting.value.subscriptionType}",
                                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                              ):SizedBox(),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          color: Get.isRegistered<RootController>()&&(!Get.find<RootController>().salons.first.accepted||Get.find<RootController>().salons.first.closed)?Colors.red:Colors.green,
                          alignment: Alignment.center,
                          child: Text(
                            Get.isRegistered<RootController>()&&!Get.find<RootController>().salons.first.accepted?"Wait for Approval":Get.find<RootController>().salons.first.closed?Get.find<RootController>().salons.first.closedMessage:"Open",
                            style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white),
                          ),
                        ),
                      /*  SwitchListTile(
                          title: Text(
                            "Closed",
                            style: Theme.of(context).textTheme.headline2.copyWith(
                              fontSize: 14.0
                            ),
                          ),
                          contentPadding: EdgeInsets.all(5.0),
                          value: Get.find<RootController>().salons.first.closed,
                          activeColor: Get.theme.colorScheme.secondary,
                          onChanged: (bool val) {
                            Get.find<RootController>().salons.first.closed = val;
                            Get.find<RootController>().salons.refresh();
                            if(val){
                              showDialog<void>(
                                context: context,
                                barrierDismissible: true,
                                // false = user must tap button, true = tap outside dialog
                                builder: (BuildContext dialogContext) {
                                  return  Dialog(
                                    child: SizedBox(
                                      height: 400,
                                      child: SfDateRangePicker(
                                        showActionButtons: true,
                                        enablePastDates: false,
                                        onSelectionChanged: Get.find<RootController>().onSelectionChanged1,
                                        selectionMode: DateRangePickerSelectionMode.range,
                                        initialSelectedRange: PickerDateRange(
                                            DateTime.now(),
                                            DateTime.now().add(const Duration(days: 3))),
                                        onCancel: () {
                                          Get.back();
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text(
                                              'Selection Cancelled',
                                            ),
                                            duration: Duration(milliseconds: 2000),
                                          ));
                                        },
                                        onSubmit: (Object value) {
                                          Get.back();
                                          Get.find<RootController>().updateDuty(true);
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text(
                                              'Selection Confirmed',
                                            ),
                                            duration: Duration(milliseconds: 2000),
                                          ));
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            }else{
                              Get.find<RootController>().updateDuty(false);
                            }


                          },),*/
                      ],
                    ):SizedBox(),),
                  ],
                ),
              );
            }
          }),
          SizedBox(height: 20),
          DrawerLinkWidget(
            icon: Icons.build_circle_outlined,
            text: Get.isRegistered<RootController>()&&Get.find<RootController>().salons.isNotEmpty?"My ${Get.find<RootController>().salons.first.salonCategory.title}":"My Salons",
            onTap: (e) {
              Get.offAndToNamed(Routes.SALONS);
            },
          ),
          if (Get.find<AuthService>().user.value.isSalonOwner)
            DrawerLinkWidget(
              icon: Icons.assignment_outlined,
              text: "Bookings",
              onTap: (e) {
                Get.back();
                Get.find<RootController>().changePage(0);
              },
            ),
          DrawerLinkWidget(
            icon: Icons.folder_special_outlined,
            text: "My Services",
            onTap: (e) {
              if(Get.find<RootController>().salons.isEmpty){
                Get.showSnackbar(Ui.ErrorSnackBar(message: "Please Add Salon"));
              }
              Get.offAndToNamed(Routes.E_SERVICES);
            },
          ),

         // Get.find<AuthService>().user.value.isSalonOwner?
          DrawerLinkWidget(
            icon: Icons.build_circle_outlined,
            text: "Manage Seats",
            onTap: (e) {
              if(Get.find<RootController>().salons.isEmpty){
                Get.showSnackbar(Ui.ErrorSnackBar(message: "Please Add Salon"));
              }
              Get.back();
            Get.toNamed(Routes.MANAGE_SEAT);
            },
          ),
              //:SizedBox(),
          //Get.find<AuthService>().user.value.isSalonOwner?
          DrawerLinkWidget(
            icon: Icons.local_offer_outlined,
            text: "Offers",
            onTap: (e) {
              if(Get.find<RootController>().salons.isEmpty){
                Get.showSnackbar(Ui.ErrorSnackBar(message: "Please Add Salon"));
              }
              Get.back();
              Get.toNamed(Routes.OFFERS);
            },
          ),
          //    :SizedBox(),
          //Get.find<AuthService>().user.value.isSalonOwner?
          DrawerLinkWidget(
            icon: Icons.alarm_off,
            text: "Off Duty",
            onTap: (e) {
              if(Get.find<RootController>().salons.isEmpty){
                Get.showSnackbar(Ui.ErrorSnackBar(message: "Please Add Salon"));
              }
              Get.back();
              Get.toNamed(Routes.OFF_DUTY);
            },
          ),
            //  :SizedBox(),
          DrawerLinkWidget(
            icon: Icons.notifications_none_outlined,
            text: "Notifications",
            onTap: (e) {
              Get.offAndToNamed(Routes.NOTIFICATIONS);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.star,
            text: "Reviews",
            onTap: (e) {
              Get.back();
              Get.find<RootController>().changePage(1);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.person,
            text: "Account",
            onTap: (e) {
              Get.back();
              Get.find<RootController>().changePage(3);
            },
          ),
          /*if (Get.find<AuthService>().user.value.isSalonOwner)
            DrawerLinkWidget(
              icon: Icons.chat_outlined,
              text: "Messages",
              onTap: (e) {
                Get.back();
                Get.find<RootController>().changePage(2);
              },
            ),*/
          if (Get.find<AuthService>().user.value.isSalonOwner)
            DrawerLinkWidget(
              icon: Icons.insert_chart_outlined,
              text: "Business Insights",
              onTap: (e) {
                Get.toNamed(Routes.INSIGHT);
              },
            ),
          if (Get.find<AuthService>().user.value.isSalonOwner)
            if (Get.find<SettingsService>().setting.value.modules.toString().contains("Subscription"))
              ListTile(
                dense: true,
                title: Text(
                  "Subscriptions & Payments".tr,
                  style: Get.textTheme.caption,
                ),
                trailing: Icon(
                  Icons.remove,
                  color: Get.theme.focusColor.withOpacity(0.3),
                ),
              ),
          if (Get.find<AuthService>().user.value.isSalonOwner)
            if (Get.find<SettingsService>().setting.value.modules.toString().contains("Subscription"))
              DrawerLinkWidget(
                icon: Icons.fact_check_outlined,
                text: "Subscriptions History",
                onTap: (e) {
                  Get.offAndToNamed(Routes.SUBSCRIPTIONS);
                },
              ),
          if (Get.find<AuthService>().user.value.isSalonOwner)
            if (Get.find<SettingsService>().setting.value.modules.toString().contains("Subscription"))
              DrawerLinkWidget(
                icon: Icons.auto_awesome_mosaic_outlined,
                text: "Subscription Packages",
                onTap: (e) {
                  Get.offAndToNamed(Routes.PACKAGES);
                },
              ),
          if (Get.find<AuthService>().user.value.isSalonOwner)
            if (Get.find<SettingsService>().setting.value.modules.toString().contains("Subscription"))
              DrawerLinkWidget(
                icon: Icons.account_balance_wallet_outlined,
                text: "Wallets",
                onTap: (e) async {
                  await Get.offAndToNamed(Routes.WALLETS);
                },
              ),
          /*ListTile(
            dense: true,
            title: Text(
              "Application preferences".tr,
              style: Get.textTheme.caption,
            ),
            trailing: Icon(
              Icons.remove,
              color: Get.theme.focusColor.withOpacity(0.3),
            ),
          ),
          if (Get.find<AuthService>().user.value.isSalonOwner)
            DrawerLinkWidget(
              icon: Icons.person_outline,
              text: "Account",
              onTap: (e) {
                Get.back();
                Get.find<RootController>().changePage(3);
              },
            ),
          DrawerLinkWidget(
            icon: Icons.settings_outlined,
            text: "Settings",
            onTap: (e) {
              Get.offAndToNamed(Routes.SETTINGS);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.translate_outlined,
            text: "Languages",
            onTap: (e) {
              Get.offAndToNamed(Routes.SETTINGS_LANGUAGE);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.brightness_6_outlined,
            text: Get.isDarkMode ? "Light Theme" : "Dark Theme",
            onTap: (e) {
              Get.offAndToNamed(Routes.SETTINGS_THEME_MODE);
            },
          ),*/
          ListTile(
            dense: true,
            title: Text(
              "Help & Privacy",
              style: Get.textTheme.caption,
            ),
            trailing: Icon(
              Icons.remove,
              color: Get.theme.focusColor.withOpacity(0.3),
            ),
          ),
          DrawerLinkWidget(
            icon: Icons.help_outline,
            text: "Help & FAQ",
            onTap: (e) {
              Get.offAndToNamed(Routes.HELP);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.headset_mic_outlined,
            text: "Contact Us",
            onTap: (e) {
              Get.offAndToNamed(Routes.CONTACT_US);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.query_stats,
            text: "My Query",
            onTap: (e) {
              Get.offAndToNamed(Routes.QUERY);
            },
          ),
          if (Get.find<AuthService>().user.value.isSalonOwner) CustomPageDrawerLinkWidget(),
          Obx(() {
            if (Get.find<AuthService>().isAuth) {
              return DrawerLinkWidget(
                icon: Icons.logout,
                text: "Logout",
                onTap: (e) async {
                  showDialog(context: context, builder: (ctx){
                    return AlertDialog(
                      title: Text("Logout"),
                      content: Text("do you want to proceed?"),
                      actions: [
                        TextButton(onPressed: (){
                          Get.back();
                        }, child: Text("No"),),
                        TextButton(onPressed: ()async{
                          await Get.find<AuthService>().removeCurrentUser();
                          await Get.offNamedUntil(Routes.LOGIN, (Route route) {
                            if (route.settings.name == Routes.LOGIN) {
                              return true;
                            }
                            return false;
                          });
                        }, child: Text("Yes"),),

                      ],
                    );
                  });

                },
              );
            } else {
              return SizedBox(height: 0);
            }
          }),
          if (Get.find<SettingsService>().setting.value.enableVersion)
            ListTile(
              dense: true,
              title: Text(
                "Version".tr + " " + Get.find<SettingsService>().setting.value.appVersion,
                style: Get.textTheme.caption,
              ),
              trailing: Icon(
                Icons.remove,
                color: Get.theme.focusColor.withOpacity(0.3),
              ),
            )
        ],
      ),
    );
  }
}
