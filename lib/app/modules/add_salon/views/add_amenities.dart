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

class AddAmenities extends GetView<AddSalonController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;
  @override
  Widget build(BuildContext context) {
    controller.amenitiesFormKey = new GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: (){
        Get.back();
        return Future.value();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Links and Amenities".tr,
            style: Get.textTheme.headline6
                .merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 60),
            child:Container(
              color:Get.theme.scaffoldBackgroundColor ,
              child: HorizontalStepperWidget(
                controller: controller.scroll,
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
                    title: Text(
                      ("Availability".tr),
                    ),
                    index: Text("3", style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                  StepWidget(
                    color: Get.theme.accentColor,
                    title: Text(
                      ("Link".tr),
                    ),
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
              ),
            ),
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
            onPressed: () => { Get.back()},
          ),
        ),
        body: Form(
          key: controller.amenitiesFormKey,
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
                        "Links and Amenities Info".tr,
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
                if (controller.linkLoading.isTrue) {
                  return CircularLoadingWidget(height: 300);
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      !controller.fromEdit?TextFieldWidget(
                        labelText: "Total Seat*".tr,
                        hintText: "2".tr,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        initialValue: controller.salon.value.totalSeat,

                        onSaved: (input) {
                          controller.salon.value.totalSeat = input;
                          controller.addUser(input);
                        },
                        validator: (input) => input.length < 1
                            ? "Should be more than 3 characters".tr
                            : null,
                        iconData: Icons.event_seat,
                        isFirst: true,
                        isLast: false,
                      ):SizedBox(),
                      !controller.fromEdit?Obx(() {
                        return Column(
                          children: controller.seat.map((e) {
                            return TextFieldWidget(
                              labelText: "Seat ${e+1}*".tr,
                              hintText: "Name".tr,
                              initialValue: e<controller.user.length?controller.user.elementAt(e):"",
                              onSaved: (input) {
                                controller.user[e] = input;
                                print(controller.user[e]);
                              },
                              validator: (input) => input.length < 3
                                  ? "Should be more than 3 characters".tr
                                  : null,
                              iconData: Icons.event_seat,
                              isFirst: true,
                              isLast: false,
                            );
                          }).toList(),
                        );
                      }):SizedBox(),
                      TextFieldWidget(
                        labelText: "Facebook Link".tr,
                        hintText: "Facebook Link".tr,
                        initialValue: controller.salon.value.fbLink,
                        onSaved: (input) =>
                            controller.salon.value.fbLink = input,
                        /*validator: (input) => input.length < 3
                            ? "Should be more than 3 characters".tr
                            : null,*/
                        iconData: Icons.link,
                        isFirst: true,
                        isLast: false,
                      ),
                      TextFieldWidget(
                        labelText: "Instagram Link".tr,
                        hintText: "Instagram Link".tr,
                        initialValue: controller.salon.value.instaLink,
                        onSaved: (input) =>
                            controller.salon.value.instaLink = input,
                       /* validator: (input) => input.length < 3
                            ? "Should be more than 3 characters".tr
                            : null,*/
                        iconData: Icons.link,
                        isFirst: true,
                        isLast: false,
                      ),
                      TextFieldWidget(
                        labelText: "Website Link".tr,
                        hintText: "Website Link".tr,
                        initialValue: controller.salon.value.websiteLink,
                        onSaved: (input) =>
                            controller.salon.value.websiteLink = input,
                        /*validator: (input) => input.length < 3
                            ? "Should be more than 3 characters".tr
                            : null,*/
                        iconData: Icons.link,
                        isFirst: true,
                        isLast: false,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 10, left: 20, right: 20),
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Get.theme.focusColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5)),
                            ],
                            border: Border.all(
                                color: Get.theme.focusColor.withOpacity(0.05))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Amenities".tr,
                                    style: Get.textTheme.bodyText1,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    final selectedValues =
                                        await showDialog<Set<GenderModel>>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return MultiSelectDialog(
                                          title: "Select Amenities".tr,
                                          submitText: "Submit".tr,
                                          cancelText: "Cancel".tr,
                                          items: controller
                                              .getMultiSelectAmenitiesItems(),
                                          initialSelectedValues:
                                              controller.amenities
                                                  .where(
                                                    (tax) =>
                                                        controller.salon.value
                                                            .amenities
                                                            ?.where((element) =>
                                                                element.name ==
                                                                tax.name)
                                                            ?.isNotEmpty ??
                                                        false,
                                                  )
                                                  .toSet(),
                                        );
                                      },
                                    );
                                    controller.salon.update((val) {
                                      val.amenities = selectedValues?.toList();
                                    });
                                  },
                                  shape: StadiumBorder(),
                                  color: Get.theme.colorScheme.secondary
                                      .withOpacity(0.1),
                                  child: Text("Select".tr,
                                      style: Get.textTheme.subtitle1),
                                  elevation: 0,
                                  hoverElevation: 0,
                                  focusElevation: 0,
                                  highlightElevation: 0,
                                ),
                              ],
                            ),
                            Obx(() {
                              if (controller.salon.value?.amenities?.isEmpty ??
                                  true) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Text(
                                    "Select Amenities".tr,
                                    style: Get.textTheme.caption,
                                  ),
                                );
                              } else {
                                return buildTaxes(controller.salon.value);
                              }
                            })
                          ],
                        ),
                      ),
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
                      controller.createAmenitiesForm();

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

  Widget buildTaxes(Salon _salon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 5,
          runSpacing: 8,
          children: List.generate(_salon.amenities?.length ?? 0, (index) {
            final tax = _salon.amenities.elementAt(index);
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(tax.name,
                  style: Get.textTheme.bodyText1.merge(
                      TextStyle(color: Get.theme.colorScheme.secondary))),
              decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                  border: Border.all(
                    color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            );
          })),
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
