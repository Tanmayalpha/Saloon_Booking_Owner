import 'package:beauty_salons_owner/app/models/address_model.dart';
import 'package:beauty_salons_owner/app/models/media_model.dart';
import 'package:beauty_salons_owner/app/models/salon_model.dart';
import 'package:beauty_salons_owner/app/modules/global_widgets/duration_chip_widget.dart';

import 'package:beauty_salons_owner/app/modules/global_widgets/images_field_widget.dart';
import 'package:beauty_salons_owner/app/modules/global_widgets/multi_select_dialog.dart';
import 'package:beauty_salons_owner/app/modules/global_widgets/select_dialog.dart';
import 'package:beauty_salons_owner/app/services/auth_service.dart';
import 'package:beauty_salons_owner/common/location_details.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
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

class AddServiceView extends GetView<AddSalonController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    controller.registerFormKey = new GlobalKey<FormState>();
    //controller.getService();
    return WillPopScope(
      onWillPop: (){
        Get.offAllNamed(Routes.ROOT);
        return Future.value();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Service".tr,
            style: Get.textTheme.headline6
                .merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
            onPressed: () => {Get.offAllNamed(Routes.ROOT)},
          ),
        ),
        body: Obx(() {
          if (controller.loading.isTrue) {
            return CircularLoadingWidget(height: 300);
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
               /* Obx(() {
                  if (controller.services.isEmpty)
                    return SizedBox();
                  else
                    return Container(
                      height: 120,
                      child: ListView.builder(
                          itemCount: controller.services.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            ServiceModel model = controller.services[index];
                            return Container(
                              width: 200,
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(8),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          model.name.tr,
                                          style: Get.textTheme.titleLarge,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            controller.services.removeAt(index);
                                          },
                                          child: Icon(
                                            Icons.close,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Ui.getPrice(
                                        double.parse(model.price),
                                        style: Get.textTheme.headline6,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      DurationChipWidget(
                                          duration: model.duration + "m"),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                }),
                SizedBox(
                  height: 10,
                ),*/
                Obx(() {
                  if (controller.category.isEmpty)
                    return SizedBox();
                  else
                    return Container(
                      height: 60,
                      child: ListView.builder(
                          itemCount: controller.category.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            Category model = controller.category[index];
                            return InkWell(
                              onTap: () {
                                Get.closeAllSnackbars();
                                for(int i = 0;i<controller.services.length;i++){
                                  var model = controller.services[i];
                                  if (model.price == "") {
                                    Get.showSnackbar(
                                        Ui.ErrorSnackBar(
                                            message: "Enter Price Of Added Service"
                                                .toString()));
                                    return;
                                  }
                                  if (model.duration == "") {
                                    Get.showSnackbar(
                                        Ui.ErrorSnackBar(
                                            message:
                                            "Enter Duration Of Added Service"
                                                .toString()));
                                    return;
                                  }
                                }
                                Future((){
                                  controller.category[controller.catIndex.value]
                                      .selected = false;
                                  controller.catIndex.value = index;
                                  controller.category[controller.catIndex.value]
                                      .selected = true;
                                  controller.subIndex.value = 0;
                                  for(int i = 0; i < controller.category[controller.catIndex.value]
                                      .subCategories.length;i++ ){
                                    controller.category[controller.catIndex.value]
                                        .subCategories[i].selected = false;
                                  }
                                  controller.category[controller.catIndex.value]
                                      .subCategories[0].selected = true;
                                  controller.category.refresh();
                                });


                              },
                              child: Container(
                                width: 100,
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: model.selected
                                        ? Get.theme.primaryColorDark
                                        : Get.theme.primaryColor,
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
                                child: Center(
                                  child: Text(
                                    model.name.tr,
                                    style: Get.textTheme.titleLarge.copyWith(
                                        color: model.selected
                                            ? Get.theme.primaryColor
                                            : Get.theme.textTheme.bodyLarge
                                                .color),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                }),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    color: Get.theme.primaryColorDark,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Obx(() {
                            if (controller.category[controller.catIndex.value]
                                .subCategories.isEmpty)
                              return SizedBox();
                            else
                              return Container(
                                padding: EdgeInsets.all(5.0),
                                color: Get.theme.primaryColorDark,
                                child: ListView.builder(
                                    itemCount: controller
                                        .category[controller.catIndex.value]
                                        .subCategories
                                        .length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      Category model = controller
                                          .category[controller.catIndex.value]
                                          .subCategories[index];
                                      return InkWell(
                                        onTap: () async{
                                          Get.closeAllSnackbars();
                                          for(int i = 0;i<controller.services.length;i++){
                                            var model = controller.services[i];
                                            if (model.price == "") {
                                              Get.showSnackbar(
                                                  Ui.ErrorSnackBar(
                                                      message: "Enter Price Of Added Service"
                                                          .toString()));
                                              return;
                                            }
                                            if (model.duration == "") {
                                              Get.showSnackbar(
                                                  Ui.ErrorSnackBar(
                                                      message:
                                                      "Enter Duration Of Added Service"
                                                          .toString()));
                                              return;
                                            }
                                          }
                                          controller.showLoading.value = true;
                                          Future((){
                                            controller
                                                .category[
                                            controller.catIndex.value]
                                                .subCategories[
                                            controller.subIndex.value]
                                                .selected = false;
                                            controller.subIndex.value = index;
                                            controller
                                                .category[
                                            controller.catIndex.value]
                                                .subCategories[
                                            controller.subIndex.value]
                                                .selected = true;
                                            controller.category.refresh();
                                          });
                                          await Future.delayed(Duration(milliseconds: 200));
                                          controller.showLoading.value = false;
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          margin: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: !model.selected
                                                  ? Get.theme.primaryColorDark
                                                  : Get.theme.primaryColor,
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
                                          child: Center(
                                            child: Text(
                                              model.name.tr,
                                              style: Get.textTheme.subtitle1
                                                  .copyWith(
                                                      color: !model.selected
                                                          ? Get.theme
                                                              .primaryColor
                                                          : Get.theme.textTheme
                                                              .bodyLarge.color),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              );
                          }),
                        ),
                        VerticalDivider(),
                        Expanded(
                          flex: 8,
                          child: Obx(() {

                            if (controller
                                .category[controller.catIndex.value]
                                .subCategories[controller.subIndex.value]
                                .services
                                .isEmpty)
                              return SizedBox();
                            else
                              return !controller.showLoading.value?ListView.builder(
                                  itemCount: controller
                                      .category[controller.catIndex.value]
                                      .subCategories[controller.subIndex.value]
                                      .services
                                      .length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    ServiceModel model = controller
                                        .category[controller.catIndex.value]
                                        .subCategories[
                                            controller.subIndex.value]
                                        .services[index];
                                    print(model.price);
                                    return Container(
                                      margin: EdgeInsets.all(5),
                                      padding: EdgeInsets.all(5),
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
                                            CrossAxisAlignment.start,

                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "${model.name.tr}(${model.genderText})",
                                                    style: Get.textTheme.titleLarge,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ),
                                              Obx((){
                                                return  Checkbox(value: controller.services
                                                    .indexWhere(
                                                        (element) =>
                                                    element
                                                        .id ==
                                                        model.id) !=
                                                    -1, onChanged: (value){
                                                  if(value){
                                                    controller.services
                                                        .add(model);
                                                  }else{
                                                    if (controller.services
                                                        .indexWhere(
                                                            (element) =>
                                                        element
                                                            .id ==
                                                            model.id) !=
                                                        -1) {
                                                      controller.services
                                                          .removeAt(controller
                                                          .services
                                                          .indexWhere(
                                                              (element) =>
                                                          element
                                                              .id ==
                                                              model
                                                                  .id));
                                                      // controller.services.add(model);
                                                    } else {

                                                    }
                                                  }
                                                });
                                              }),

                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Obx(() =>   controller.services
                                              .indexWhere(
                                                  (element) =>
                                              element
                                                  .id ==
                                                  model.id) !=
                                              -1?Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: 60,
                                                child: TextFormField(
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                  ),
                                                  initialValue: model.price,
                                                  keyboardType:
                                                  TextInputType.number,
                                                  onChanged: (val) {
                                                    model.price = val;
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: "Price",
                                                    labelText: "Price*",
                                                    labelStyle: TextStyle(
                                                      fontSize: 10.0,
                                                    ),
                                                    contentPadding:
                                                    EdgeInsets.all(10.0),
                                                    hintStyle: TextStyle(
                                                      fontSize: 10.0,
                                                    ),
                                                    isDense: true,
                                                    enabledBorder:
                                                    OutlineInputBorder(),
                                                    focusedBorder:
                                                    OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  var resultingDuration =
                                                  await showDurationPicker(
                                                    context: context,
                                                    initialTime:
                                                    Duration(minutes: 30),
                                                  );
                                                  List<String> time =
                                                  resultingDuration
                                                      .toString()
                                                      .split(":");
                                                  if (time.isNotEmpty) {
                                                    print(time.toList());

                                                    int hours =
                                                    int.parse(time[0]);
                                                    int minute =
                                                    int.parse(time[1]);
                                                    print((hours * 60 + minute)
                                                        .toString());
                                                    model.duration =
                                                        (hours * 60 + minute)
                                                            .toString();
                                                    controller
                                                        .category[controller
                                                        .catIndex.value]
                                                        .subCategories[
                                                    controller
                                                        .subIndex.value]
                                                        .services[index]
                                                        .duration = (hours *
                                                        60 +
                                                        minute)
                                                        .toString();
                                                    controller.category
                                                        .refresh();
                                                  }
                                                  print(resultingDuration);
                                                },
                                                child: Container(
                                                  width: 70,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 12.0,
                                                      horizontal: 8.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                      border: Border.all(
                                                          color: Get
                                                              .theme
                                                              .iconTheme
                                                              .color)),
                                                  child: Text(
                                                    model.duration == "" ||
                                                        model.duration ==
                                                            null
                                                        ? "Duration*"
                                                        : model.duration + "m",
                                                    style: TextStyle(
                                                      fontSize: 10.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              /*Container(
                                                width: 70,
                                                child: TextFormField(
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  readOnly: true,
                                                  initialValue: model.duration,
                                                  onChanged: (val) {
                                                    model.duration = val;
                                                  },
                                                  onTap: () async {

                                                  },
                                                  decoration: InputDecoration(
                                                    labelText: "Duration*",
                                                    hintText: "In Minute",
                                                    contentPadding:
                                                        EdgeInsets.all(10.0),
                                                    hintStyle: TextStyle(
                                                      fontSize: 10.0,
                                                    ),
                                                    labelStyle: TextStyle(
                                                      fontSize: 10.0,
                                                    ),
                                                    isDense: true,
                                                    enabledBorder:
                                                        OutlineInputBorder(),
                                                    focusedBorder:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),*/
                                              /* SizedBox(
                                                width: 5.0,
                                              ),
                                              Container(
                                                width: 70,
                                                child: BlockButtonWidget(
                                                  onPressed: () async {
                                                    if (model.price == "") {
                                                      Get.showSnackbar(
                                                          Ui.ErrorSnackBar(
                                                              message: "Enter Price"
                                                                  .toString()));
                                                      return;
                                                    }
                                                    if (model.duration == "") {
                                                      Get.showSnackbar(
                                                          Ui.ErrorSnackBar(
                                                              message:
                                                                  "Enter Duration"
                                                                      .toString()));
                                                      return;
                                                    }
                                                    if (controller.services
                                                            .indexWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    model.id) !=
                                                        -1) {
                                                      controller.services
                                                          .removeAt(controller
                                                              .services
                                                              .indexWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      model
                                                                          .id));
                                                      controller.services
                                                          .add(model);
                                                    } else {
                                                      controller.services
                                                          .add(model);
                                                    }
                                                  },
                                                  color: Get.theme.colorScheme
                                                      .secondary,
                                                  text: Text(
                                                    "ADD".tr,
                                                    style: Get
                                                        .textTheme.bodyLarge
                                                        .merge(TextStyle(
                                                            color: Get.theme
                                                                .primaryColor)),
                                                  ),
                                                ),
                                              ),*/
                                            ],
                                          ):SizedBox(),)

                                        ],
                                      ),
                                    );
                                  }):CircularProgressIndicator();
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        }),
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
                    onPressed: () async {
                      if (controller.services.length > 0) {
                        Get.closeAllSnackbars();
                        for(int i = 0;i<controller.services.length;i++){
                          var model = controller.services[i];
                          if (model.price == "") {

                            Get.showSnackbar(
                                Ui.ErrorSnackBar(
                                    message: "Enter Price Of Added Service"
                                        .toString()));

                            return;
                          }
                          if (model.duration == "") {
                            Get.showSnackbar(
                                Ui.ErrorSnackBar(
                                    message:
                                    "Enter Duration Of Added Service"
                                        .toString()));
                            return;
                          }
                        }
                        controller.addService();
                      } else {
                        Get.showSnackbar(Ui.ErrorSnackBar(
                            message: "Add some service".toString()));
                      }

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
