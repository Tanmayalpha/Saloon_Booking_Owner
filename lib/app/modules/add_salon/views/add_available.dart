import 'package:beauty_salons_owner/app/models/availability_hour_model.dart';
import 'package:beauty_salons_owner/app/models/media_model.dart';
import 'package:beauty_salons_owner/app/models/salon_model.dart';
import 'package:beauty_salons_owner/app/modules/global_widgets/images_field_widget.dart';
import 'package:beauty_salons_owner/app/modules/global_widgets/multi_select_dialog.dart';
import 'package:beauty_salons_owner/app/modules/global_widgets/select_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../models/main_model.dart';
import '../../../models/setting_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/phone_field_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../../salons/widgets/horizontal_stepper_widget.dart';
import '../../salons/widgets/step_widget.dart';
import '../controllers/add_controller.dart';
import 'package:intl/intl.dart';

class AddAvailableView extends GetView<AddSalonController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    controller.registerFormKey = new GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: (){
        Get.back();
        return Future.value();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Working Days".tr,
            style: Get.textTheme.headline6
                .merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 60),
            child:Container(
              color:Get.theme.scaffoldBackgroundColor ,
              child: HorizontalStepperWidget(
                steps: [
                  StepWidget(
                    title: Text(
                      ("Business details".tr),
                    ),
                    index: Text("1", style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                  StepWidget(
                    title: Text(
                      ("Address".tr),
                    ),
                    index: Text("2", style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                  StepWidget(
                    color: Get.theme.accentColor,
                    title: Text(
                      ("Availability".tr),
                    ),
                    index: Text("3", style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                  StepWidget(
                    title: Text(
                      ("Link".tr),
                    ),
                    color: Get.theme.focusColor,
                    index: Text("4", style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                  StepWidget(
                    title: Text(
                      ("Bank".tr),
                    ),
                    color: Get.theme.focusColor,
                    index: Text("5", style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                ],
                controller: controller.scroll,
              ),
            ),
          ),
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
            onPressed: () => { Get.back()},
          ),
        ),
        body: Form(
          child: ListView(
            primary: true,
            children: [
              /*Container(
                height: 80,
                width: Get.width,
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Get.theme.focusColor.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 5)),
                  ],
                ),
                margin: EdgeInsets.only(bottom: 50),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Working Days".tr,
                        style: Get.textTheme.headline6.merge(TextStyle(
                            color: Get.theme.primaryColor, fontSize: 24)),
                      ),
                      SizedBox(height: 5),
                      // Text("Fill the following credentials to login your account", style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
                    ],
                  ),
                ),
              ),*/
              Obx(() {
                if (controller.loading.isTrue) {
                  return CircularLoadingWidget(height: 300);
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Obx(() {
                        if (controller.availabilityHours.isEmpty)
                          return SizedBox();
                        else
                          return Column(
                            children:
                                controller.availabilityHours.map((element) {
                              int index = controller.availabilityHours
                                  .indexWhere((e) => e == element);
                              return Container(
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 8, right: 8),
                                decoration: BoxDecoration(
                                    color: Get.theme.primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Get.theme.focusColor
                                              .withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: Offset(0, 5)),
                                    ],
                                    border: Border.all(
                                        color: Get.theme.focusColor
                                            .withOpacity(0.05))),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        controller
                                            .availabilityHours[index]
                                            .check = !controller
                                            .availabilityHours[index]
                                            .check;
                                        controller.availabilityHours[index].startAt = controller
                                            .availabilityHours[0].startAt;
                                        controller.availabilityHours[index].endAt = controller
                                            .availabilityHours[0].endAt;
                                        controller.availabilityHours[index].showStartAt = controller
                                            .availabilityHours[0].showStartAt;
                                        controller.availabilityHours[index].showEndAt = controller
                                            .availabilityHours[0].showEndAt;
                                        controller.availabilityHours
                                            .refresh();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(controller
                                              .availabilityHours[index]
                                              .check?Icons.check_circle_outline:Icons.circle_outlined),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            element.day.tr,
                                            style: Get.textTheme.bodyText1,
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                    element.check?Container(
                                      padding: EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                          left: 10,
                                          right: 10),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                          color: Get.theme.primaryColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Get.theme.focusColor
                                                    .withOpacity(0.1),
                                                blurRadius: 10,
                                                offset: Offset(0, 5)),
                                          ],
                                          border: Border.all(
                                              color: Get.theme.focusColor
                                                  .withOpacity(0.05))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Starts At".tr,
                                                  style:
                                                      Get.textTheme.bodyText1,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              MaterialButton(
                                                onPressed: () async {
                                                  final picked = await Ui
                                                      .showTimePickerDialog(
                                                          context,
                                                          element.startAt);
                                                  controller
                                                      .availabilityHours[index]
                                                      .startAt = picked;
                                                  controller
                                                      .availabilityHours[index]
                                                      .showStartAt = Ui.DateFormatString(picked);
                                                  controller.availabilityHours
                                                      .refresh();
                                                },
                                                shape: StadiumBorder(),
                                                color: Get
                                                    .theme.colorScheme.secondary
                                                    .withOpacity(0.1),
                                                child: Text("Time Picker".tr,
                                                    style: Get
                                                        .textTheme.subtitle1),
                                                elevation: 0,
                                                hoverElevation: 0,
                                                focusElevation: 0,
                                                highlightElevation: 0,
                                              ),
                                            ],
                                          ),
                                          element.showStartAt == null
                                              ? Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5),
                                                  child: Text(
                                                    "Pick a time for starts at"
                                                        .tr,
                                                    style:
                                                        Get.textTheme.caption,
                                                  ),
                                                )
                                              : Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5),
                                                  child: Text(
                                                    element.showStartAt,
                                                    style:
                                                        Get.textTheme.bodyText2,
                                                  ),
                                                )
                                        ],
                                      ),
                                    ):SizedBox(),
                                    element.check?Container(
                                      padding: EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                          left: 10,
                                          right: 10),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                          color: Get.theme.primaryColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Get.theme.focusColor
                                                    .withOpacity(0.1),
                                                blurRadius: 10,
                                                offset: Offset(0, 5)),
                                          ],
                                          border: Border.all(
                                              color: Get.theme.focusColor
                                                  .withOpacity(0.05))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Ends At".tr,
                                                  style:
                                                      Get.textTheme.bodyText1,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              MaterialButton(
                                                onPressed: () async {
                                                  final picked = await Ui
                                                      .showTimePickerDialog(
                                                          context,
                                                          element.endAt);
                                                  controller
                                                      .availabilityHours[index]
                                                      .endAt = picked;
                                                  controller
                                                      .availabilityHours[index]
                                                      .showEndAt = Ui.DateFormatString(picked);
                                                  controller.availabilityHours
                                                      .refresh();
                                                },
                                                shape: StadiumBorder(),
                                                color: Get
                                                    .theme.colorScheme.secondary
                                                    .withOpacity(0.1),
                                                child: Text("Time Picker".tr,
                                                    style: Get
                                                        .textTheme.subtitle1),
                                                elevation: 0,
                                                hoverElevation: 0,
                                                focusElevation: 0,
                                                highlightElevation: 0,
                                              ),
                                            ],
                                          ),
                                          element.showEndAt == null
                                              ? Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5),
                                                  child: Text(
                                                    "Pick a time for ends at"
                                                        .tr,
                                                    style:
                                                        Get.textTheme.caption,
                                                  ),
                                                )
                                              : Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5),
                                                  child: Text(
                                                    element.showEndAt,
                                                    style:
                                                        Get.textTheme.bodyText2,
                                                  ),
                                                )
                                        ],
                                      ),
                                    ):SizedBox(),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                      }),
                    ],
                  );
                }
              })
            ],
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.vertical,
              children: [
                SizedBox(
                  width: Get.width,
                  child: BlockButtonWidget(
                    onPressed: () {
                      controller.createAvailabilityHour();
                      //Get.offAllNamed(Routes.PHONE_VERIFICATION);
                    },
                    color: Get.theme.colorScheme.secondary,
                    text: Text(
                      "Next".tr,
                      style: Get.textTheme.headline6
                          .merge(TextStyle(color: Get.theme.primaryColor)),
                    ),
                  ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSalonLevel(Salon _salon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(_salon.address.state?.name ?? '',
            style: Get.textTheme.bodyText2),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  Widget buildCity(Salon _salon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(_salon.address.city?.city ?? '',
            style: Get.textTheme.bodyText2),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}
