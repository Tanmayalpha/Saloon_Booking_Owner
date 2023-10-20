import 'dart:convert';

import 'package:beauty_salons_owner/app/models/category_model.dart';
import 'package:beauty_salons_owner/app/models/media_model.dart';
import 'package:beauty_salons_owner/app/models/salon_level_model.dart';
import 'package:beauty_salons_owner/app/models/salon_model.dart';
import 'package:beauty_salons_owner/app/modules/global_widgets/images_field_widget.dart';
import 'package:beauty_salons_owner/app/modules/global_widgets/multi_select_dialog.dart';
import 'package:beauty_salons_owner/app/modules/global_widgets/select_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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

class AddBankView extends GetView<AddSalonController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    controller.bankFormKey = new GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: (){
        Get.back();
        return Future.value();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Bank Info".tr,
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
                    index: Text("2",
                        style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                  StepWidget(
                    title: Text(
                      ("Availability".tr),
                    ),
                    index: Text("3",
                        style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                  StepWidget(
                    title: Text(
                      ("Link".tr),
                    ),
                    index: Text("4",
                        style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                  StepWidget(
                    color: Get.theme.accentColor,
                    title: Text(
                      ("Bank".tr),
                    ),
                    index: Text("5",
                        style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                ],
              ),
            ),
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
            onPressed: () => {Get.back()},
          ),
        ),
        body: Form(
          key: controller.bankFormKey,
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
                        "Bank Info".tr,
                        style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor, fontSize: 24)),
                      ),
                      SizedBox(height: 5),

                      // Text("Fill the following credentials to login your account", style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
                    ],
                  ),
                ),
              ),*/
              Obx(() {
                if (controller.bankLoading.isTrue) {
                  return CircularLoadingWidget(height: 300);
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                                    "Bank Name*".tr,
                                    style: Get.textTheme.bodyText1,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    final selectedValues =
                                        await showDialog<BankModel>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SelectDialog(
                                          title: "Select Bank Name".tr,
                                          submitText: "Submit".tr,
                                          cancelText: "Cancel".tr,
                                          items:
                                              controller.getSelectBankItems(),
                                          initialSelectedValue: controller
                                                  .salon.value.bank_name ??
                                              "",
                                        );
                                      },
                                    );
                                    controller.salon.update((val) {
                                      val.bank_name = selectedValues.name;
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
                              if (controller.salon.value?.bank_name == null ??
                                  true) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Text(
                                    "Select Bank Name".tr,
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
                        labelText: "Bank Name*".tr,
                        hintText: "Name of your Bank".tr,
                        initialValue:controller.salon.value.bank_name,
                        onSaved: (input) => controller.salon.value.bank_name = input,
                        validator: (input) => input.length < 3 ? "Should be more than 3 characters".tr : null,
                        iconData: Icons.person_outline,
                        isFirst: true,
                        isLast: false,
                      ),*/
                      TextFieldWidget(
                        labelText: "Account Holder Name*".tr,
                        hintText: "Name of Account Holder".tr,
                        initialValue: controller.salon.value.account_holder,
                        onSaved: (input) =>
                            controller.salon.value.account_holder = input,
                        validator: (input) => input.length < 3
                            ? "Should be more than 3 characters".tr
                            : null,
                        iconData: Icons.person_outline,
                        isFirst: true,
                        isLast: false,
                      ),
                      TextFieldWidget(
                        keyboardType: TextInputType.number,
                        obscureText: controller.hideAccount.value,
                        labelText: "Account Number*".tr,
                        /*suffixIcon: IconButton(
                          onPressed: () {
                            controller.hideAccount.value =
                            !controller.hideAccount.value;
                          },
                          color: Theme.of(context).focusColor,
                          icon: Icon(controller.hideAccount.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),*/
                        hintText: "Account Number".tr,
                        initialValue: controller.salon.value.account_no,
                        onChanged:(input) =>
                        controller.salon.value.account_no = input ,
                        onSaved: (input) =>
                            controller.salon.value.account_no = input,
                        validator: (input) => input.length < 11
                            ? "Should be a valid account".tr
                            : null,
                        iconData: Icons.alternate_email,
                        isFirst: false,
                        isLast: false,
                      ),
                      TextFieldWidget(
                        keyboardType: TextInputType.number,
                        obscureText: controller.hideAccount.value,
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.hideAccount.value =
                            !controller.hideAccount.value;
                          },
                          color: Theme.of(context).focusColor,
                          icon: Icon(controller.hideAccount.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                        labelText: "Confirm Account Number*".tr,
                        hintText: "Confirm Account Number".tr,
                        initialValue: controller.salon.value.confirm_account_no,
                        onChanged: (input) {
                          print(controller.salon.value.confirm_account_no);
                          print(controller.salon.value.account_no);
                          controller.salon.value.confirm_account_no = input;
                        },
                        onSaved: (input) {
                          print(controller.salon.value.confirm_account_no);
                          print(controller.salon.value.account_no);
                          controller.salon.value.confirm_account_no = input;
                        },

                        validator: (input) => controller.salon.value.confirm_account_no != controller.salon.value.account_no
                            ? "Should be a same account number".tr
                            : null,
                        iconData: Icons.alternate_email,
                        isFirst: false,
                        isLast: false,
                      ),
                      Obx(() {
                        return TextFieldWidget(
                          maxLength: 11,
                          labelText: "IFSC Code*".tr,
                          hintText: "••••••••••••".tr,
                          initialValue: controller.salon.value.ifsc_code,
                          onChanged: (String val)async{
                            if(val.length>10){
                              controller.findBranch.value = true;
                              var response = await http.get(Uri.parse("https://ifsc.razorpay.com/$val"));
                              print(response.body);
                              var data = jsonDecode(response.body);
                              if(data is Map&&data['BRANCH']!=null){
                                controller.salon.value.branch_name = data['BRANCH'];
                                controller.findBranch.value = false;
                              }else{
                                controller.salon.value.branch_name = "";
                                controller.findBranch.value = false;
                                Get.showSnackbar(Ui.ErrorSnackBar(message: "Ifsc code not found"));
                              }
                            }
                          },
                          onSaved: (input) =>
                          controller.salon.value.ifsc_code = input,
                          validator: (input) => input.length != 11
                              ? "Should be 11 characters".tr
                              : null,
                          obscureText: controller.hideIfsc.value,
                          iconData: Icons.lock_outline,
                          keyboardType: TextInputType.visiblePassword,
                          isLast: true,
                          isFirst: false,
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.hideIfsc.value =
                              !controller.hideIfsc.value;
                            },
                            color: Theme.of(context).focusColor,
                            icon: Icon(controller.hideIfsc.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                          ),
                        );
                      }),
                      Obx(() =>  !controller.findBranch.value?TextFieldWidget(
                        labelText: "Branch Name*".tr,
                        hintText: "Branch Name".tr,
                        initialValue: controller.salon.value.branch_name,
                        onSaved: (input) =>
                        controller.salon.value.branch_name = input,
                        validator: (input) => input.length < 3
                            ? "Should be more than 3 characters".tr
                            : null,
                        iconData: Icons.alternate_email,
                        isFirst: false,
                        isLast: false,
                      ):SizedBox(),),

                      Obx(() {
                        return TextFieldWidget(
                          labelText: "KYC(If any)".tr,
                          hintText: "••••••••••••".tr,
                          initialValue: controller.salon.value.is_kyc,
                          onSaved: (input) =>
                              controller.salon.value.is_kyc = input,
                          // validator: (input) => input.length < 3 ? "Should be more than 3 characters".tr : null,
                          obscureText: controller.hideKyc.value,
                          iconData: Icons.lock_outline,
                          keyboardType: TextInputType.visiblePassword,
                          isLast: true,
                          isFirst: false,
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.hideKyc.value =
                                  !controller.hideKyc.value;
                            },
                            color: Theme.of(context).focusColor,
                            icon: Icon(controller.hideKyc.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                          ),
                        );
                      }),
                      Obx(() {
                        return TextFieldWidget(
                          maxLength: 10,
                          labelText: "Pan Number*".tr,
                          hintText: "••••••••••••".tr,
                          initialValue: controller.salon.value.pan_no,
                          onSaved: (input) =>
                              controller.salon.value.pan_no = input,
                          validator: (input) => input.length != 10
                              ? "Should be 10 characters".tr
                              : null,
                          obscureText: controller.hidePan.value,
                          iconData: Icons.lock_outline,
                          keyboardType: TextInputType.visiblePassword,
                          isLast: true,
                          isFirst: false,
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.hidePan.value =
                                  !controller.hidePan.value;
                            },
                            color: Theme.of(context).focusColor,
                            icon: Icon(controller.hidePan.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                          ),
                        );
                      }),
                      Obx(() {
                        return TextFieldWidget(
                          labelText: "GST Number".tr,
                          maxLength: 16,
                          hintText: "••••••••••••".tr,
                          initialValue: controller.salon.value.gst_no,
                          onSaved: (input) =>
                              controller.salon.value.gst_no = input,
                          //validator: (input) => input.length !=16 ? "Should be 16 characters".tr : null,
                          obscureText: controller.hideGst.value,
                          iconData: Icons.lock_outline,
                          keyboardType: TextInputType.visiblePassword,
                          isLast: true,
                          isFirst: false,
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.hideGst.value =
                                  !controller.hideGst.value;
                            },
                            color: Theme.of(context).focusColor,
                            icon: Icon(controller.hideGst.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                          ),
                        );
                      }),
                      Obx(() {
                        return ImagesFieldWidget(
                          label: "Pan Image".tr,
                          field: 'image',
                          tag: controller.salonForm.hashCode.toString() + "2",
                          initialImages: controller.salon.value.panImage,
                          uploadCompleted: (uuid) {
                            controller.salon.update((val) {
                              val.panImage = val.panImage ?? [];
                              val.panImage.add(new Media(id: uuid));
                            });
                          },
                          reset: (uuids) {
                            controller.salon.update((val) {
                              val.panImage.clear();
                            });
                          },
                        );
                      }),
                      Obx(() {
                        return ImagesFieldWidget(
                          label: "Business Image".tr,
                          field: 'image',
                          tag: controller.salonForm.hashCode.toString() + "1",
                          initialImages: controller.salon.value.businessImage,
                          uploadCompleted: (uuid) {
                            controller.salon.update((val) {
                              val.businessImage = val.businessImage ?? [];
                              val.businessImage.add(new Media(id: uuid));
                            });
                          },
                          reset: (uuids) {
                            controller.salon.update((val) {
                              val.businessImage.clear();
                            });
                          },
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
                      controller.createBankForm();
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
        child: Text(_salon.bank_name ?? '', style: Get.textTheme.bodyText2),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}
