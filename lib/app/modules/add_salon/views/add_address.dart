import 'package:beauty_salons_owner/app/models/address_model.dart';
import 'package:beauty_salons_owner/app/models/media_model.dart';
import 'package:beauty_salons_owner/app/models/salon_model.dart';

import 'package:beauty_salons_owner/app/modules/global_widgets/images_field_widget.dart';
import 'package:beauty_salons_owner/app/modules/global_widgets/multi_select_dialog.dart';
import 'package:beauty_salons_owner/app/modules/global_widgets/select_dialog.dart';
import 'package:beauty_salons_owner/app/services/auth_service.dart';
import 'package:beauty_salons_owner/common/location_details.dart';
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

class AddAddressView extends GetView<AddSalonController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;
  @override
  Widget build(BuildContext context) {
    controller.registerFormKey = new GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            controller.salon.value.id != null
                ? "Edit Address"
                : "Add Address".tr,
            style: Get.textTheme.headline6
                .merge(TextStyle(color: context.theme.primaryColor)),
          ),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 60),
            child: Container(
              color: Get.theme.scaffoldBackgroundColor,
              child: HorizontalStepperWidget(
                controller: controller.scroll,
                steps: [
                  StepWidget(
                    title: Text(
                      ("Business details".tr),
                    ),
                    index: Text("1",
                        style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                  StepWidget(
                    color: Get.theme.accentColor,
                    title: Text(
                      ("Address".tr),
                    ),
                    index: Text("2",
                        style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                  StepWidget(
                    title: Text(
                      ("Availability".tr),
                    ),
                    color: Get.theme.focusColor,
                    index: Text("3",
                        style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                  StepWidget(
                    title: Text(
                      ("Link".tr),
                    ),
                    color: Get.theme.focusColor,
                    index: Text("4",
                        style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                  StepWidget(
                    title: Text(
                      ("Bank".tr),
                    ),
                    color: Get.theme.focusColor,
                    index: Text("5",
                        style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                ],
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
            onPressed: () => {Get.back()},
          ),
        ),
        body: Form(
          child: ListView(
            primary: true,
            children: [
              /*  Container(
                height: 80,
                width: Get.width,
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(color: Get.theme.focusColor.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 5)),
                  ],
                ),
                margin: EdgeInsets.only(bottom: 50),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Address Info".tr,
                        style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor, fontSize: 24)),
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
                        if (controller.state.isEmpty)
                          return SizedBox();
                        else
                          return Container(
                            padding: EdgeInsets.only(
                                top: 8, bottom: 10, left: 20, right: 20),
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 20, bottom: 20),
                            decoration: BoxDecoration(
                                color: Get.theme.primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Get.theme.focusColor.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: Offset(0, 5)),
                                ],
                                border: Border.all(
                                    color: Get.theme.focusColor
                                        .withOpacity(0.05))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "State*".tr,
                                        style: Get.textTheme.bodyText1,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () async {
                                        final selectedValue =
                                            await showDialog<StateModel>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SelectDialog(
                                              title: "Select State".tr,
                                              submitText: "Submit".tr,
                                              cancelText: "Cancel".tr,
                                              items: controller.getStateItems(),
                                              initialSelectedValue:
                                                  controller.state.firstWhere(
                                                (element) =>
                                                    element.id ==
                                                    controller.salon.value
                                                        .address.state?.id,
                                                orElse: () => new StateModel(),
                                              ),
                                            );
                                          },
                                        );
                                        controller.salon.update((val) {
                                          val.address.state = selectedValue;
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
                                  if (controller.salon.value?.address.state ==
                                      null) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Text(
                                        "Select State".tr,
                                        style: Get.textTheme.caption,
                                      ),
                                    );
                                  } else {
                                    return buildSalonLevel(
                                        controller.salon.value);
                                  }
                                })
                              ],
                            ),
                          );
                      }),
                      Obx(() {
                        if (controller.salon.value == null &&
                            controller.salon.value.address.state == null)
                          return SizedBox();
                        else
                          return Container(
                            padding: EdgeInsets.only(
                                top: 8, bottom: 10, left: 20, right: 20),
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 20, bottom: 20),
                            decoration: BoxDecoration(
                                color: Get.theme.primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Get.theme.focusColor.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: Offset(0, 5)),
                                ],
                                border: Border.all(
                                    color: Get.theme.focusColor
                                        .withOpacity(0.05))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "City*".tr,
                                        style: Get.textTheme.bodyText1,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () async {
                                        if (controller.salon.value.address.state
                                                    .city !=
                                                null &&
                                            controller.salon.value.address.state
                                                    .city.length >
                                                0) {
                                          final selectedValue =
                                              await showDialog<City>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SelectDialog(
                                                title: "Select City".tr,
                                                submitText: "Submit".tr,
                                                cancelText: "Cancel".tr,
                                                items: controller.salon.value
                                                    .address.state.city
                                                    .map((element) {
                                                  return SelectDialogItem(
                                                      element, element.city);
                                                }).toList(),
                                                initialSelectedValue:
                                                    controller.state.firstWhere(
                                                  (element) =>
                                                      element.id ==
                                                      controller.salon.value
                                                          .address.city?.id,
                                                  orElse: () =>
                                                      new StateModel(),
                                                ),
                                              );
                                            },
                                          );
                                          controller.salon.update((val) {
                                            val.address.city = selectedValue;
                                          });
                                        }
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
                                  if (controller.salon.value?.address.city ==
                                      null) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Text(
                                        "Select City".tr,
                                        style: Get.textTheme.caption,
                                      ),
                                    );
                                  } else {
                                    return buildCity(controller.salon.value);
                                  }
                                })
                              ],
                            ),
                          );
                      }),
                      Obx(() => !controller.addressLoading.value?TextFieldWidget(
                        labelText: "Full Address*".tr,
                        hintText: "Address".tr,
                        initialValue: controller.salon.value.address != null
                            ? controller.salon.value.address.address
                            : "",
                        onSaved: (input) =>
                        controller.salon.value.address.address = input,
                        validator: (input) => input.length < 3
                            ? "Should be more than 3 characters".tr
                            : null,
                        iconData: Icons.person_outline,
                        suffixIcon:  IconButton(
                          icon: Icon(Icons.gps_fixed),
                          onPressed: () async {
                            var result = await Get.toNamed(Routes.SALON_ADDRESS_PICKER,arguments: {'address': new Address(),"name":controller.salon.value.salonCategory.title});
                            controller.addressLoading.value = true;
                            print("okay1$result");
                            if(result!=null){
                              Address adr =result as Address;
                              print("okay${adr.address}");
                              controller.salon.value.address.address = adr.address?? "";
                              controller.salon.value.address.latitude = adr.latitude?? 0;
                              controller.salon.value.address.longitude = adr.longitude?? 0;
                              controller.salon.value.address.zipCode = adr.zipCode ?? "452000";
                            }
                            await Future.delayed(Duration(milliseconds: 150));
                            controller.addressLoading.value = false;
                          },
                        ),
                        isFirst: true,
                        isLast: false,
                      ):SizedBox(),),
                      TextFieldWidget(
                        labelText: "Zip Code*".tr,
                        hintText: "Zip Code".tr,
                        keyboardType: TextInputType.number,
                        initialValue: controller.salon.value.address != null
                            ? controller.salon.value.address.zipCode
                            : "",
                        onChanged:(input) =>
                        controller.salon.value.address.zipCode = input,
                        onSaved: (input) =>
                            controller.salon.value.address.zipCode = input,
                        validator: (input) => input.length < 3
                            ? "Should be more than 3 characters".tr
                            : null,
                        iconData: Icons.person_outline,
                        isFirst: true,
                        isLast: false,
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
                    onPressed: () async {
                      if (controller.salon.value.address != null) {
                        controller
                            .createAddress(controller.salon.value.address);
                        /*GetLocation location = new GetLocation((value) {});
                        try {
                          var value = await location.getLatLng(
                              controller.salon.value.address.address);
                          controller.salon.update((val) {
                            Address address = new Address(
                              description: value.first.locality,
                              address: value.first.addressLine,
                              zipCode: controller.salon.value.address.zipCode ?? "",
                              latitude: value.first.coordinates.latitude,
                              longitude: value.first.coordinates.longitude,
                              city: controller.salon.value.address.city,

                              state: controller.salon.value.address.state,
                              userId: Get.find<AuthService>().user.value.id,
                            );
                            val.address = address;
                          });
                          debugPrint("done");
                          controller
                              .createAddress(controller.salon.value.address);
                        } catch (e) {
                          debugPrint("done" + e.toString());
                          controller
                              .createAddress(controller.salon.value.address);
                        }*/
                      }else{
                        Get.showSnackbar(Ui.ErrorSnackBar(message: "Something went wrong"));
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
