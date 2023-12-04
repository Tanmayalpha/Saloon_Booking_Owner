import 'package:beauty_salons_owner/app/modules/global_widgets/select_dialog.dart';
import 'package:beauty_salons_owner/app/modules/global_widgets/text_field_widget.dart';
import 'package:beauty_salons_owner/app/modules/insights/controllers/contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../models/user_model.dart';
import '../controllers/insight_controller.dart';

class ContactUsView extends GetView<ContactController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "".tr,
          style: Get.textTheme.headline6
              .merge(TextStyle(color: context.theme.primaryColor)),
        ),
        centerTitle: true,
        backgroundColor: Get.theme.colorScheme.secondary,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
          onPressed: () => {
            Get.back()
            //Get.find<RootController>().changePageOutRoot(0)
          },
        ),
      ),
      body: Obx(() {
        return !controller.loading.value
            ? SingleChildScrollView(
                child: controller.contactData != null
                    ? Container(
                        padding: EdgeInsets.all(18.0),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: Get.theme.highlightColor),
                                  color: Get.theme.colorScheme.secondary),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Corporate Office",
                                        style: Get.textTheme.subtitle2
                                            .copyWith(color: Get.theme.primaryColor),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.handshake_rounded,
                                            color: Get.theme.primaryColor,
                                            size: 24.0,
                                          ),
                                          SizedBox(width: 10.0,),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(8.0)
                                              ),
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                "${controller.contactData['corporate_office']}".tr,
                                                style: Get.textTheme.subtitle1.copyWith(color: Get.theme.primaryColor),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            Container(
                              padding: EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: Get.theme.highlightColor),
                                  color: Get.theme.colorScheme.secondary),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Trimzzy For Business",
                                        style: Get.textTheme.subtitle2
                                            .copyWith(color: Get.theme.primaryColor),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.contact_mail,
                                            color: Get.theme.primaryColor,
                                            size: 24.0,
                                          ),
                                          SizedBox(width: 10.0,),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(8.0)
                                              ),

                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Email : ${controller.contactData['bussiness_details']['email']}".tr,
                                                    style: Get.textTheme.subtitle1.copyWith(color: Get.theme.primaryColor),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Text(
                                                    "Phone : ${controller.contactData['bussiness_details']['phone']}".tr,
                                                    style: Get.textTheme.subtitle1.copyWith(color: Get.theme.primaryColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            Container(
                              padding: EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: Get.theme.highlightColor),
                                  color: Get.theme.colorScheme.secondary),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Work With US",
                                        style: Get.textTheme.subtitle2
                                            .copyWith(color: Get.theme.primaryColor),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.headphones,
                                            color: Get.theme.primaryColor,
                                            size: 24.0,
                                          ),
                                          SizedBox(width: 10.0,),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(8.0)
                                              ),
                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Email : ${controller.contactData['work_with_ud']['email']}".tr,
                                                    style: Get.textTheme.subtitle1.copyWith(color: Get.theme.primaryColor),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Text(
                                                    "Phone : ${controller.contactData['work_with_ud']['phone']}".tr,
                                                    style: Get.textTheme.subtitle1.copyWith(color: Get.theme.primaryColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.0,),
                            Text(
                              "Send us a message".tr,
                              style:
                              Get.textTheme.headline6.copyWith(),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFieldWidget1(
                              controller: controller.nameCon,
                              labelText: "Name".tr,
                              hintText: "Name".tr,
                              // onChanged: (val){
                              //   controller.nameCon.text =val;
                              // },
                              // onSaved: (val){
                              //   controller.nameCon.text =val;
                              // },
                              isFirst: true,
                              isLast: false,
                            ),
                            Container(
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
                                          "Type Of Query".tr,
                                          style: Get.textTheme.bodyText1,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () async {
                                          final selectedValue = await showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SelectDialog(
                                                title: "Type Of Query".tr,
                                                submitText: "Submit".tr,
                                                cancelText: "Cancel".tr,
                                                items: controller.getServices(),
                                              );
                                            },
                                          );
                                          controller.selectedService.value = selectedValue;

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
                                    if (controller.selectedService.value=="" ?? true) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(vertical: 20),
                                        child: Text(
                                          "Select Query".tr,
                                          style: Get.textTheme.caption,
                                        ),
                                      );
                                    } else {
                                      return buildCategory(controller.selectedService.value);
                                    }
                                  })
                                ],
                              ),
                            ),
                            TextFieldWidget1(
                              controller: controller.emailCon,
                              labelText: "Email".tr,
                              hintText: "Email".tr,
                              validator: (input) => input!=""&&!input.contains('@') ? "Should be a valid email".tr : null,
                              /*onChanged: (val){
                                controller.emailCon.text =val;
                              },
                              onSaved: (val){
                                controller.emailCon.text =val;
                              },*/
                              isFirst: true,
                              isLast: false,
                            ),
                            TextFieldWidget1(
                              controller: controller.mobileCon,
                              labelText: "Mobile".tr,
                              hintText: "Mobile".tr,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              /*onChanged: (val){
                                controller.mobileCon.text =val;
                              },
                              onSaved: (val){
                                controller.mobileCon.text =val;
                              },*/
                              isFirst: true,
                              isLast: false,
                            ),
                            TextFieldWidget(
                              labelText: "Description".tr,
                              hintText: "Description".tr,
                              onChanged: (val){
                                controller.descCon.text =val;
                              },
                              onSaved: (val){
                                controller.descCon.text =val;
                              },
                              isFirst: true,
                              isLast: false,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MaterialButton(
                                  elevation: 0,
                                  onPressed: () {
                                    controller.updateQuery();
                                  },
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Get.theme.primaryColorDark,
                                  child: Text("Submit".tr,
                                      style: Get.textTheme.bodyText2
                                          .copyWith(color: Get.theme.primaryColor)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : SizedBox())
            : Center(
                child: CircularProgressIndicator(),
              );
      }),
    );
  }
  Widget buildCategory(String val) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(val ?? '', style: Get.textTheme.bodyText2),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}
