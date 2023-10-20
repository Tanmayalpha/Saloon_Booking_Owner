import 'package:beauty_salons_owner/app/models/media_model.dart';
import 'package:beauty_salons_owner/app/models/salon_level_model.dart';
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

class AddSalonView extends GetView<AddSalonController> {
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
                ? "Edit Business Details"
                : "Add Business Details".tr,
            style: Get.textTheme.headline6
                .merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 60),
            child: Container(
              color: Get.theme.scaffoldBackgroundColor,
              child: HorizontalStepperWidget(
                controller: controller.scroll,
                steps: [
                  StepWidget(
                    color: Get.theme.accentColor,
                    title: Text(
                      ("Business details".tr),
                    ),
                    index: Text("1",
                        style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                  StepWidget(
                    title: Text(
                      ("Address".tr),
                    ),
                    color: Get.theme.focusColor,
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
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
            onPressed: () => {
              Get.back()
              //Get.find<RootController>().changePageOutRoot(0)
            },
          ),
        ),
        body: Form(
          key: controller.salonForm,
          child: ListView(
            primary: true,
            children: [
              /*Container(
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
                        "Business Info".tr,
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
                        return ImagesFieldWidget(
                          label: "Images".tr,
                          field: 'image',
                          tag: controller.salonForm.hashCode.toString(),
                          initialImages: controller.salon.value.images,
                          uploadCompleted: (uuid) {
                            controller.salon.update((val) {
                              val.images = val.images ?? [];
                              val.images.add(new Media(id: uuid));
                            });
                          },
                          reset: (uuids) {
                            controller.salon.update((val) {
                              val.images.clear();
                            });
                          },
                        );
                      }),
                      TextFieldWidget(
                        labelText: "Brand Name*".tr,
                        hintText: "Name of your Brand".tr,
                        initialValue: controller.salon.value.name,
                        onSaved: (input) => controller.salon.value.name = input,
                        validator: (input) => input.length < 3
                            ? "Should be more than 3 characters".tr
                            : null,
                        iconData: Icons.person_outline,
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
                                    "Category Type*".tr,
                                    style: Get.textTheme.bodyText1,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    final selectedValues =
                                    await showDialog<CatModel>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SelectDialog(
                                          title: "Select Category Type".tr,
                                          submitText: "Submit".tr,
                                          cancelText: "Cancel".tr,
                                          items: controller
                                              .getMultiSelectCatItems(),
                                          initialSelectedValue:
                                          controller.cat.firstWhere(
                                                (element) =>
                                            element.id ==
                                                controller.salon.value
                                                    .salonCategory?.id,
                                            orElse: () => new CatModel(),
                                          ),
                                        );
                                      },
                                    );
                                    controller.salon.update((val) {
                                      val.salonCategory = selectedValues;
                                    });
                                    controller.genders.value = controller.tempGenders.toList();
                                    if(selectedValues!=null&&selectedValues.title=="Salons"){
                                      int index = controller.genders.indexWhere((element) => element.name=="Female");
                                      if(index!=-1){
                                        controller.genders.removeAt(index);
                                      }
                                    }else if(selectedValues!=null&&selectedValues.title=="Spas"){

                                    }else{
                                      int index = controller.genders.indexWhere((element) => element.name=="Male");
                                      if(index!=-1){
                                        controller.genders.removeAt(index);
                                      }
                                      int index1 = controller.genders.indexWhere((element) => element.name=="Unisex");
                                      if(index1!=-1){
                                        controller.genders.removeAt(index1);
                                      }
                                    }
                                    // controller.selectedGender.value = selectedValues?.toList();
                                    /*controller.selectedGender.update((val) {
                                      val = selectedValues?.toList();
                                    });*/
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
                              if (controller.salon.value?.salonCategory ==
                                  null ??
                                  true) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Text(
                                    "Select Category Type".tr,
                                    style: Get.textTheme.caption,
                                  ),
                                );
                              } else {
                                return buildCategory(controller.salon.value);
                              }
                            })
                          ],
                        ),
                      ),
                      /*TextFieldWidget(
                        labelText: "Owner Name".tr,
                        hintText: "Name of your Owner".tr,
                        initialValue: controller.currentUser?.value?.name,
                        onSaved: (input) => controller.salon.value.ownerName = input,
                        validator: (input) => input.length < 3 ? "Should be more than 3 characters".tr : null,
                        iconData: Icons.person_outline,
                        isFirst: true,
                        isLast: false,
                      ),
                      TextFieldWidget(
                        labelText: "Email Address".tr,
                        hintText: "johndoe@gmail.com".tr,
                        initialValue: controller.currentUser?.value?.email,
                        onSaved: (input) => controller.salon.value.email = input,
                        validator: (input) => !input.contains('@') ? "Should be a valid email".tr : null,
                        iconData: Icons.alternate_email,
                        isFirst: false,
                        isLast: false,
                      ),
                      PhoneFieldWidget(
                        labelText: "Phone Number".tr,
                        hintText: "223 665 7896".tr,
                        readOnly:true,
                        initialCountryCode: controller.currentUser?.value?.getPhoneNumber()?.countryISOCode,
                        initialValue: controller.currentUser?.value?.getPhoneNumber()?.number,
                        onSaved: (phone) {
                          return controller.salon.value.phoneNumber = phone.completeNumber;
                        },
                        isLast: false,
                        isFirst: false,
                      ),
                      Obx(() {
                        return TextFieldWidget(
                          labelText: "Password".tr,
                          hintText: "••••••••••••".tr,
                          initialValue: controller.currentUser?.value?.password,
                          onSaved: (input) => controller.currentUser.value.password = input,
                          validator: (input) => input.length < 3 ? "Should be more than 3 characters".tr : null,
                          obscureText: controller.hidePassword.value,
                          iconData: Icons.lock_outline,
                          keyboardType: TextInputType.visiblePassword,
                          isLast: true,
                          isFirst: false,
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.hidePassword.value = !controller.hidePassword.value;
                            },
                            color: Theme.of(context).focusColor,
                            icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                          ),
                        );
                      }),*/
                      /*TextFieldWidget(
                        onSaved: (input) => controller.salon.value.availabilityRange = double.tryParse(input) ?? 0,
                        validator: (input) => (double.tryParse(input) ?? 0) <= 0 ? "Should be more than 0".tr : null,
                        initialValue: controller.salon.value.availabilityRange?.toString() ?? null,
                        keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                        hintText: "5".tr,
                        labelText: "Availability Range*".tr,
                        suffix: Text(Get.find<SettingsService>().setting.value.distanceUnit.tr),
                      ),
                      Obx(() {
                        if (controller.salonLevels.isEmpty)
                          return SizedBox();
                        else
                          return Container(
                            padding: EdgeInsets.only(top: 8, bottom: 10, left: 20, right: 20),
                            margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                            decoration: BoxDecoration(
                                color: Get.theme.primaryColor,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                                ],
                                border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Salon Levels*".tr,
                                        style: Get.textTheme.bodyText1,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () async {
                                        final selectedValue = await showDialog<SalonLevel>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SelectDialog(
                                              title: "Select Salon Level".tr,
                                              submitText: "Submit".tr,
                                              cancelText: "Cancel".tr,
                                              items: controller.getSelectSalonLevelsItems(),
                                              initialSelectedValue: controller.salonLevels.firstWhere(
                                                    (element) => element.id == controller.salon.value.salonLevel?.id,
                                                orElse: () => new SalonLevel(),
                                              ),
                                            );
                                          },
                                        );
                                        controller.salon.update((val) {
                                          val.salonLevel = selectedValue;
                                        });
                                      },
                                      shape: StadiumBorder(),
                                      color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                                      child: Text("Select".tr, style: Get.textTheme.subtitle1),
                                      elevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                    ),
                                  ],
                                ),
                                Obx(() {
                                  if (controller.salon.value?.salonLevel == null) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      child: Text(
                                        "Select salons".tr,
                                        style: Get.textTheme.caption,
                                      ),
                                    );
                                  } else {
                                    return buildSalonLevel1(controller.salon.value);
                                  }
                                })
                              ],
                            ),
                          );
                      }),*/
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
                                    "Gender*".tr,
                                    style: Get.textTheme.bodyText1,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    final selectedValues =
                                        await showDialog<GenderModel>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SelectDialog(
                                          title: "Select Gender".tr,
                                          submitText: "Submit".tr,
                                          cancelText: "Cancel".tr,
                                          items: controller
                                              .getMultiSelectTaxesItems(),
                                          initialSelectedValue:
                                              controller.genders.firstWhere(
                                            (element) =>
                                                element.id ==
                                                controller
                                                    .salon.value.genders?.id,
                                            orElse: () => new GenderModel(),
                                          ),
                                        );
                                      },
                                    );
                                    controller.salon.update((val) {
                                      val.genders = selectedValues;
                                    });

                                    // controller.selectedGender.value = selectedValues?.toList();
                                    /*controller.selectedGender.update((val) {
                                      val = selectedValues?.toList();
                                    });*/
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
                              if (controller.salon.value?.genders == null ??
                                  true) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Text(
                                    "Select Gender".tr,
                                    style: Get.textTheme.caption,
                                  ),
                                );
                              } else {
                                return buildGender(controller.salon.value);
                              }
                            })
                          ],
                        ),
                      ),
                      Obx(() {
                        if (controller.partners.isEmpty)
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
                                        "Partner Size*".tr,
                                        style: Get.textTheme.bodyText1,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () async {
                                        final selectedValue =
                                            await showDialog<GenderModel>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SelectDialog(
                                              title: "Select Partner Size".tr,
                                              submitText: "Submit".tr,
                                              cancelText: "Cancel".tr,
                                              items: controller
                                                  .getSelectPartnerLevelsItems(),
                                              initialSelectedValue: controller
                                                  .partners
                                                  .firstWhere(
                                                (element) =>
                                                    element.id ==
                                                    controller.salon.value
                                                        .partners?.id,
                                                orElse: () => new GenderModel(),
                                              ),
                                            );
                                          },
                                        );
                                        controller.salon.update((val) {
                                          val.partners = selectedValue;
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
                                  if (controller.salon.value?.partners ==
                                      null) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Text(
                                        "Select Partner Size".tr,
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

                      TextFieldWidget(
                        labelText: "Description*".tr,
                        hintText: "Enter Description".tr,
                        initialValue: controller.salon.value.description,
                        onSaved: (input) =>
                            controller.salon.value.description = input,
                        validator: (input) => input.length < 3
                            ? "Should be more than 3 characters".tr
                            : null,
                       // iconData: Icons.alternate_email,
                        isFirst: false,
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
                    onPressed: () {
                      controller.createSalonForm();
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
        child:
            Text(_salon.partners?.name ?? '', style: Get.textTheme.bodyText2),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  Widget buildSalonLevel1(Salon _salon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child:
            Text(_salon.salonLevel?.name ?? '', style: Get.textTheme.bodyText2),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  Widget buildGender(Salon _salon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(_salon.genders?.name ?? '', style: Get.textTheme.bodyText2),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  Widget buildCategory(Salon _salon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(_salon.salonCategory?.title ?? '',
            style: Get.textTheme.bodyText2),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}
