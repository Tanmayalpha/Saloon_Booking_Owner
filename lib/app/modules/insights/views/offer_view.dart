import 'package:beauty_salons_owner/app/modules/global_widgets/select_dialog.dart';
import 'package:beauty_salons_owner/app/modules/global_widgets/text_field_widget.dart';
import 'package:beauty_salons_owner/app/providers/laravel_provider.dart';
import 'package:beauty_salons_owner/common/ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/offer_model.dart';
import '../../../models/user_model.dart';
import '../controllers/insight_controller.dart';

class OfferView extends GetView<InsightController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Offers".tr,
          style: Get.textTheme.headline6
              .merge(TextStyle(color: context.theme.primaryColor)),
        ),
        centerTitle: true,
        backgroundColor: Get.theme.colorScheme.secondary,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
          onPressed: ()  {
            if(controller.showOffer.value){
              controller.getInsight();
              controller.showOffer.value = false;
            }else{
              Get.back();
            }

            //Get.find<RootController>().changePageOutRoot(0)
          },
        ),
        actions: [

        ],
      ),
      floatingActionButton: Obx(() {
        return FloatingActionButton(
          child: new Icon(controller.showOffer.value ? Icons.list : Icons.add,
              size: 32, color: Get.theme.primaryColor),
          onPressed: () {
            controller.offerId ='';
            controller.fromEdit = false;
            controller.showOffer.value = !controller.showOffer.value;
            controller.discountCon.text = "";
            controller.startAt.value = "";
            controller.endAt.value = "";
            controller.selectedDay.value = "";

          //  controller.discountCon.text = controller.discount.value ?? '';
          },
          backgroundColor: Get.theme.colorScheme.secondary,
        );
      }),
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<LaravelApiClient>().forceRefresh();
          controller.getOffer();
          Get.find<LaravelApiClient>().unForceRefresh();
        },
        child: Obx(() {
          return !controller.loading.value
              ? controller.showOffer.value
                  ? SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        padding: EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.fromEdit?"Edit Offer":"Add Offer".tr,
                              style: Get.textTheme.headline6
                                  .copyWith(color: Colors.black),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),

                            /*  TextFieldWidget(
                            labelText: "Title".tr,
                            hintText: "Title".tr,
                            onChanged: (val) {
                              controller.titleCon.text = val;
                            },
                            onSaved: (val) {
                              controller.titleCon.text = val;
                            },
                            isFirst: true,
                            isLast: false,
                          ),*/
                            !controller.selectedOffer.value
                                ? Container(
                                    padding: EdgeInsets.only(
                                        top: 8,
                                        bottom: 10,
                                        left: 20,
                                        right: 20),
                                    margin: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 20,
                                        bottom: 20),
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
                                                "Day".tr,
                                                style: Get.textTheme.bodyText1,
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                            controller.fromEdit?SizedBox():MaterialButton(
                                              onPressed: () async {
                                                final selectedValue =
                                                    await showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return SelectDialog(
                                                      title: "Day".tr,
                                                      submitText: "Submit".tr,
                                                      cancelText: "Cancel".tr,
                                                      items:
                                                          controller.getDay(),
                                                    );
                                                  },
                                                );
                                                controller.selectedDay.value =
                                                    selectedValue;
                                              },
                                              shape: StadiumBorder(),
                                              color: Get
                                                  .theme.colorScheme.secondary
                                                  .withOpacity(0.1),
                                              child: Text("Select".tr,
                                                  style:
                                                      Get.textTheme.subtitle1),
                                              elevation: 0,
                                              hoverElevation: 0,
                                              focusElevation: 0,
                                              highlightElevation: 0,
                                            ),
                                          ],
                                        ),
                                        Obx(() {
                                          if (controller.selectedDay.value ==
                                                  "" ??
                                              true) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20),
                                              child: Text(
                                                "Select Day".tr,
                                                style: Get.textTheme.caption,
                                              ),
                                            );
                                          } else {
                                            return buildCategory(
                                                controller.selectedDay.value);
                                          }
                                        })
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            /*TextFieldWidget(
                            labelText: "Message".tr,
                            hintText: "Enter Message".tr,
                            onChanged: (val) {
                              controller.msgCon.text = val;
                            },
                            onSaved: (val) {
                              controller.msgCon.text = val;
                            },
                            isFirst: true,
                            isLast: false,
                          ),*/
                            TextFieldWidget(
                              labelText: "Discount".tr,
                              hintText: "1-100".tr,
                              initialValue: !controller.selectedOffer.value&&!controller.fromEdit?"":controller.discount.value,
                              keyboardType: TextInputType.number,
                              errorText: '',
                              maxLength: 3,
                              onChanged: (val) {
                                controller.discountCon.text = val;
                              },
                              onSaved: (val) {
                                controller.discountCon.text = val;
                              },
                              suffixIcon: TextButton(
                                child: Text(
                                  "%",
                                ),
                              ),
                              isFirst: true,
                              isLast: false,
                            ),
                            !controller.selectedOffer.value&&controller.selectedDay.value!=""
                                ? Container(
                                    padding: EdgeInsets.only(
                                        top: 8,
                                        bottom: 10,
                                        left: 20,
                                        right: 20),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
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
                                                style: Get.textTheme.bodyText1,
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                            MaterialButton(
                                              onPressed: () async {
                                                final picked = await Ui
                                                    .showTimePickerDialog(
                                                        context,
                                                        controller
                                                            .startAt.value);
                                                controller.startAt.value =
                                                    picked;
                                              },
                                              shape: StadiumBorder(),
                                              color: Get
                                                  .theme.colorScheme.secondary
                                                  .withOpacity(0.1),
                                              child: Text("Time Picker".tr,
                                                  style:
                                                      Get.textTheme.subtitle1),
                                              elevation: 0,
                                              hoverElevation: 0,
                                              focusElevation: 0,
                                              highlightElevation: 0,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Text(
                                            controller.startAt.value!=""?Ui.DateFormatString(controller.startAt.value):"",
                                            style: Get.textTheme.bodyText2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            !controller.selectedOffer.value&&controller.selectedDay.value!=""
                                ? Container(
                                    padding: EdgeInsets.only(
                                        top: 8,
                                        bottom: 10,
                                        left: 20,
                                        right: 20),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
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
                                                "End At".tr,
                                                style: Get.textTheme.bodyText1,
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                            MaterialButton(
                                              onPressed: () async {
                                                final picked = await Ui
                                                    .showTimePickerDialog(
                                                        context,
                                                        controller.endAt.value);
                                                controller.endAt.value = picked;
                                              },
                                              shape: StadiumBorder(),
                                              color: Get
                                                  .theme.colorScheme.secondary
                                                  .withOpacity(0.1),
                                              child: Text("Time Picker".tr,
                                                  style:
                                                      Get.textTheme.subtitle1),
                                              elevation: 0,
                                              hoverElevation: 0,
                                              focusElevation: 0,
                                              highlightElevation: 0,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Text(
                                            controller.endAt.value!=""?Ui.DateFormatString(controller.endAt.value):"",
                                            style: Get.textTheme.bodyText2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(() => MaterialButton(
                                  elevation: 0,
                                  onPressed: () {
                                    if((!controller.selectedOffer.value&&controller.discountCon.text!=""&&controller.endAt.value!=""&&controller.startAt.value!="")||(controller.selectedOffer.value&&controller.discountCon.text!="")){
                                      print(controller.discountCon.text);
                                      print(controller.discount.value);
                                      if(!controller.fromEdit&&!controller.selectedOffer.value&&double.parse(controller.discountCon.text)<=double.parse(controller.discount.value)){
                                        Get.showSnackbar(Ui.ErrorSnackBar(message: "Idle offer must be grater than flat offer"));
                                        return;
                                      }
                                      controller.addOffer();
                                    }else{
                                      Get.showSnackbar(Ui.ErrorSnackBar(message: "Please Fill All Details"));
                                    }

                                  },
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: (!controller.selectedOffer.value&&controller.discountCon.text!=""&&controller.endAt.value!=""&&controller.startAt.value!="")||(controller.selectedOffer.value&&controller.discountCon.text!="")?Get.theme.primaryColorDark:Get.theme.primaryColorDark,
                                  child: Text("Submit".tr,
                                      style: Get.textTheme.bodyText2.copyWith(
                                          color: Get.theme.primaryColor)),
                                ))

                              ],
                            ),
                          ],
                        ),
                      ))
                  : Container(
                      padding: EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    controller.selectedOffer.value = true;
                                    //controller.getOffer();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(horizontal:10.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                            color: Get.theme.highlightColor),
                                        color: !controller.selectedOffer.value
                                            ? Get.theme.primaryColor
                                            : Get.theme.colorScheme.secondary),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Flat Offers".tr,
                                          style: Get.textTheme.headline6.copyWith(
                                              color: !controller.selectedOffer.value
                                                  ? Get.theme.colorScheme.secondary
                                                  : Get.theme.primaryColor),
                                        ),
                                        const SizedBox(width: 5,),
                                        //controller.selectedOffer.value?
                                        Obx(() {
                                          return Switch(
                                            value: controller.onOffOffer.value,
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            activeColor: Colors.black,
                                            onChanged: (bool val) {
                                              controller.onOffOffer.value = val;
                                              controller.getOnOff();
                                            },
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () async {
                                    controller.selectedOffer.value = false;
                                    //  controller.getOffer();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                            color: Get.theme.highlightColor),
                                        color: controller.selectedOffer.value
                                            ? Get.theme.primaryColor
                                            : Get.theme.colorScheme.secondary),
                                    child: Text(
                                      "Utilize Idle Time".tr,
                                      style: Get.textTheme.headline6.copyWith(
                                          color: controller.selectedOffer.value
                                              ? Get.theme.colorScheme.secondary
                                              : Get.theme.primaryColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          !controller.selectedOffer.value
                              ? Expanded(
                                  child: ListView.builder(
                                      itemCount: controller.offerList.length,
                                      shrinkWrap: true,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        OfferModel model =
                                            controller.offerList[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: ListTile(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              side: BorderSide(
                                                  color: Colors.grey
                                                      .withOpacity(0.2)),
                                            ),
                                            dense: true,
                                            horizontalTitleGap: 5,
                                            leading: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                /*Icon(
                                            Icons.local_offer_outlined,
                                            color: Get.theme.primaryColorDark,
                                          ),*/
                                                Text(
                                                  "${model.discount}%\nOFF".tr,
                                                  style: Get.textTheme.headline3
                                                      .copyWith(
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            title: Text(
                                              "${model.day}".tr,
                                              style: Get.textTheme.headline3,
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      controller.showOffer.value =
                                                      !controller
                                                          .showOffer.value;
                                                      controller.discount.value =  model.discount
                                                          .toString();
                                                      controller.discountCon.text =
                                                          model.discount
                                                              .toString();
                                                      controller.fromEdit =true;
                                                      controller.selectedDay.value = model.day;
                                                      controller.startAt.value = model.fromTime;
                                                      controller.endAt.value = model.toTime;
                                                    },
                                                    icon: Icon(
                                                      Icons.edit,
                                                    )),
                                                IconButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              ctx) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                "Delete"
                                                                    .tr,
                                                              ),
                                                              content: Text(
                                                                "Do you want to proceed?"
                                                                    .tr,
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Get.back();
                                                                  },
                                                                  child: Text(
                                                                    "No".tr,
                                                                    style: Get
                                                                        .textTheme
                                                                        .bodyText2,
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Get.back();
                                                                    controller
                                                                        .deleteOffer(
                                                                            model.id);
                                                                  },
                                                                  child: Text(
                                                                    "Yes".tr,
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    icon: Icon(
                                                      Icons.delete,
                                                    )),
                                              ],
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  "Start At ${Ui.DateFormatString(model.fromTime)}, End At ${Ui.DateFormatString(model.toTime)}"
                                                      .tr,
                                                  style: Get.textTheme.bodyText1
                                                      .copyWith(
                                                          color: Get.theme
                                                              .iconTheme.color),
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              : controller.discount.value.toString() != "0"
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          side: BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.2)),
                                        ),
                                        dense: true,
                                        horizontalTitleGap: 5,
                                        leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            /*Icon(
                                            Icons.local_offer_outlined,
                                            color: Get.theme.primaryColorDark,
                                          ),*/
                                            Text(
                                              "${controller.discount.value}%\nOFF"
                                                  .tr,
                                              style: Get.textTheme.headline3
                                                  .copyWith(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        title: Text(
                                          "Flat Discount".tr,
                                          style: Get.textTheme.headline3,
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  controller.showOffer.value =
                                                      !controller
                                                          .showOffer.value;
                                                  controller.discountCon.text =
                                                      controller.discount.value
                                                          .toString();
                                                },
                                                icon: Icon(
                                                  Icons.edit,
                                                )),
                                            IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                      ctx) {
                                                        return AlertDialog(
                                                          title: Text(
                                                            "Delete"
                                                                .tr,
                                                          ),
                                                          content: Text(
                                                            "Do you want to proceed?"
                                                                .tr,
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed:
                                                                  () {
                                                                Get.back();
                                                              },
                                                              child: Text(
                                                                "No".tr,
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed:
                                                                  () {
                                                                Get.back();
                                                                controller.discountCon.text = "0";
                                                                controller
                                                                    .addOffer();
                                                              },
                                                              child: Text(
                                                                "Yes".tr,

                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                )),
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                        ],
                      ),
                    )
              : Center(
                  child: CircularProgressIndicator(),
                );
        }),
      ),
    );
  }

  Widget buildCategory(String val) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(val ?? '', style: Get.textTheme.bodyText2),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}
