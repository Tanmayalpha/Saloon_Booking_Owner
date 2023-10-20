import 'package:beauty_salons_owner/app/routes/app_routes.dart';
import 'package:beauty_salons_owner/common/ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controllers/insight_controller.dart';

class InsightView extends GetView<InsightController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Business Insights".tr,
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
            ? Container(
                padding: EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        double.parse(controller.cashBal.value) > 0
                            ? Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: Container(
                                              color: Colors.white,
                                              padding: EdgeInsets.all(15),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                 /* ListTile(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      controller.upiPayment(
                                                          controller
                                                              .onlineBal.value,
                                                          context);
                                                    },
                                                    title: Text(
                                                      "Upi".tr,
                                                      style: Get
                                                          .textTheme.headline6,
                                                    ),
                                                    trailing: Icon(
                                                        Icons.arrow_forward),
                                                  ),*/
                                                  ListTile(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      controller.razorPayment(
                                                          controller
                                                              .onlineBal.value,
                                                          context);
                                                    },
                                                    title: Text(
                                                      "Razorpay".tr,
                                                      style: Get
                                                          .textTheme.headline6,
                                                    ),
                                                    trailing: Icon(
                                                        Icons.arrow_forward),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                            color: Get.theme.highlightColor),
                                        color: Get.theme.primaryColor),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Pay To Trimzzy".tr,
                                          style: Get.textTheme.headline6,
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          "₹${controller.cashBal}".tr,
                                          style: Get.textTheme.headline2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        double.parse(controller.cashBal.value) > 0 ||
                                double.parse(controller.onlineBal.value) > 0
                            ? SizedBox(
                                width: 10.0,
                              )
                            : Expanded(
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                          color: Get.theme.highlightColor),
                                      color: Get.theme.primaryColor),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Settled".tr,
                                        style: Get.textTheme.headline6,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        double.parse(controller.onlineBal.value) > 0
                            ? Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () async {
                                    //
                                    //await Get.offAndToNamed(Routes.CHECKOUT, arguments: controller.onlineBal.value);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                            color: Get.theme.highlightColor),
                                        color: Get.theme.primaryColor),
                                    child: Column(
                                      children: [
                                        Text(
                                          "From Trimzzy".tr,
                                          style: Get.textTheme.headline6,
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          "₹${controller.onlineBal}".tr,
                                          style: Get.textTheme.headline2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Completed Bookings".tr,
                          style: Get.textTheme.headline6
                              .copyWith(color: Colors.black),
                        ),
                        /*controller.selectedFilterDate.value != ""
                            ? TextButton(
                                onPressed: () async {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: true,
                                    // false = user must tap button, true = tap outside dialog
                                    builder: (BuildContext dialogContext) {
                                      return Dialog(
                                        child: SizedBox(
                                          height: 400,
                                          child: SfDateRangePicker(
                                            showActionButtons: true,
                                            enablePastDates: false,
                                            onSelectionChanged:
                                                controller.onSelectionChanged1,
                                            selectionMode:
                                                DateRangePickerSelectionMode
                                                    .range,
                                            initialSelectedRange:
                                                PickerDateRange(
                                                    DateTime.now(),
                                                    DateTime.now().add(
                                                        const Duration(
                                                            days: 3))),
                                            onCancel: () {
                                              Get.back();
                                              controller.loading.value = false;
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                  'Selection Cancelled',
                                                ),
                                                duration: Duration(
                                                    milliseconds: 2000),
                                              ));
                                            },
                                            onSubmit: (Object value) {
                                              controller.getInsight();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                  'Selection Confirmed',
                                                ),
                                                duration: Duration(
                                                    milliseconds: 2000),
                                              ));
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  */
                        /*final picked = await Ui.showDatePickerDialog(
                                      context, controller.startAt.value);
                                  controller.selectedFilterDate.value = picked;
                                  controller.getInsight();*/
                        /*
                                },
                                child: Text(
                                  controller.selectedFilterDate.value.tr,
                                  style: Get.textTheme.headline6
                                      .copyWith(color: Colors.black),
                                ))
                            :*/

                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Get.theme.highlightColor),
                          color: Get.theme.primaryColorDark),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                      controller.bookData['today'] != null
                      ? Expanded(
                                flex: 1,
                                child:  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.bookData['today']['text'],
                                    style: Get.textTheme.titleLarge.copyWith(
                                        color: Get.theme.primaryColor),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "₹${controller.bookData['today']['amount']}"
                                        .tr,
                                    style: Get.textTheme.headline2.copyWith(
                                        color: Get.theme.primaryColor),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "${controller.bookData['today']['total_orders']} Order"
                                        .tr,
                                    style: Get.textTheme.bodyLarge.copyWith(
                                        color: Get.theme.primaryColor),
                                  ),
                                ],
                              )
                                  ): SizedBox(),
                              controller.bookData['total_earnings'] != null&&  controller.bookData['total_earnings']['total_salon'] != null
                                  ? Expanded(
                                  flex: 1,
                                  child:  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.bookData['total_earnings']['total_salon']['text'],
                                        style: Get.textTheme.titleLarge.copyWith(
                                            color: Get.theme.primaryColor),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "₹${controller.bookData['total_earnings']['total_salon']['amount']}"
                                            .tr,
                                        style: Get.textTheme.headline2.copyWith(
                                            color: Get.theme.primaryColor),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "${controller.bookData['total_earnings']['total_salon']['total_orders']} Order"
                                            .tr,
                                        style: Get.textTheme.bodyLarge.copyWith(
                                            color: Get.theme.primaryColor),
                                      ),
                                    ],
                                  )
                              ): SizedBox(),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Divider(),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              controller.bookData['week'] != null?Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.bookData['week']['text'],
                                      style: Get.textTheme.titleLarge.copyWith(
                                          color: Get.theme.primaryColor),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "₹${controller.bookData['week']['amount']}"
                                          .tr,
                                      style: Get.textTheme.headline2.copyWith(
                                          color: Get.theme.primaryColor),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "${controller.bookData['week']['total_orders']} Order"
                                          .tr,
                                      style: Get.textTheme.bodyLarge.copyWith(
                                          color: Get.theme.primaryColor),
                                    ),
                                  ],
                                ),
                              ):SizedBox(),
                              SizedBox(
                                width: 10.0,
                              ),
                              controller.bookData['month'] != null?Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.bookData['month']['text'],
                                      style: Get.textTheme.titleLarge.copyWith(
                                          color: Get.theme.primaryColor),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "₹${controller.bookData['month']['amount']}"
                                          .tr,
                                      style: Get.textTheme.headline2.copyWith(
                                          color: Get.theme.primaryColor),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "${controller.bookData['month']['total_orders']} Order"
                                          .tr,
                                      style: Get.textTheme.bodyLarge.copyWith(
                                          color: Get.theme.primaryColor),
                                    ),
                                  ],
                                ),
                              ):SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Earnings".tr,
                          style: Get.textTheme.headline6
                              .copyWith(color: Colors.black),
                        ),
                     /*   IconButton(
                            onPressed: () async {
                              showDialog<void>(
                                context: context,
                                barrierDismissible: true,
                                // false = user must tap button, true = tap outside dialog
                                builder: (BuildContext dialogContext) {
                                  return Dialog(
                                    child: SizedBox(
                                      height: 400,
                                      child: SfDateRangePicker(
                                        showActionButtons: true,
                                        enablePastDates: true,
                                        onSelectionChanged:
                                        controller.onSelectionChanged1,
                                        selectionMode:
                                        DateRangePickerSelectionMode.range,
                                        initialSelectedRange: PickerDateRange(
                                            DateTime.now().subtract(
                                                const Duration(days: 3)),
                                            DateTime.now()),
                                        onCancel: () {
                                          Get.back();
                                          controller.loading.value = false;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                              'Selection Cancelled',
                                            ),
                                            duration:
                                            Duration(milliseconds: 2000),
                                          ));
                                        },
                                        onSubmit: (Object value) {
                                          Get.back();
                                          controller.getInsight();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                              'Selection Confirmed',
                                            ),
                                            duration:
                                            Duration(milliseconds: 2000),
                                          ));
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.calendar_month)),*/
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(child:Container(
                            alignment: Alignment.center,
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
                            child: TextFormField(
                              readOnly: true,
                              controller: controller.dateCon,

                              onTap: ()async{
                                DateTime val = await controller.selectDate(context,initialDate: controller.dateCon.text!=""?DateTime.parse(controller.dateCon.text):null,endDate: controller.toCon.text!=""?DateTime.parse(controller.toCon.text):null);
                                if(val!=null){
                                  controller.dateCon.text = DateFormat("yyyy-MM-dd").format(val);
                                  controller.getInsight();
                                }

                              },
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                labelText: "From Date",
                                hintStyle: TextStyle(
                                    color: Get.theme.colorScheme.primary
                                ),
                                enabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.all(5.0),
                              ),
                            ),
                          ), ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(child:Container(
                            alignment: Alignment.center,
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
                            child: TextFormField(
                              readOnly: true,
                              controller: controller.toCon,
                              onTap: ()async{
                                DateTime val = await controller.selectDate(context,initialDate: controller.toCon.text!=""?DateTime.parse(controller.toCon.text):null,endDate: DateTime.now());
                                if(val!=null){
                                  controller.toCon.text = DateFormat("yyyy-MM-dd").format(val);
                                  controller.getInsight();
                                }
                              },
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                labelText: "To Date",
                                hintStyle: TextStyle(
                                    color: Get.theme.colorScheme.primary
                                ),
                                enabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.all(5.0),
                              ),
                            ),
                          ), ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
        /*controller.bookData['total_earnings'] != null&&  controller.bookData['total_earnings']['total_salon'] != null
        ?Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Get.theme.highlightColor),
                          color: Get.theme.primaryColorDark),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              controller.bookData['total_earnings']['total_salon']['text'],
                              style: Get.textTheme.titleLarge.copyWith(
                                  color: Get.theme.primaryColor),
                            ),
                          ),
                          Text(
                            "₹${controller.bookData['total_earnings']['total_salon']['amount']} (${controller.bookData['total_earnings']['total_salon']['total_orders']} Order)"
                                .tr,
                            style: Get.textTheme.titleLarge.copyWith(
                                color: Get.theme.primaryColor),
                          ),
                        ],
                      ),
                    ): SizedBox(),*/
                    controller.bookData['total_earnings'] != null&&  controller.bookData['total_earnings']['seats'] != null
                        ?Column(
                      children: controller.bookData['total_earnings']['seats'].map<Widget>((e){
                        return Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Get.theme.highlightColor),
                              color: Get.theme.primaryColorDark),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  e['text'],
                                  style: Get.textTheme.titleLarge.copyWith(
                                      color: Get.theme.primaryColor),
                                ),
                              ),
                              Text(
                                "₹${e['amount']} (${e['total_orders']} Order)"
                                    .tr,
                                style: Get.textTheme.titleLarge.copyWith(
                                    color: Get.theme.primaryColor),
                              ),
                            ],
                          ),
                        );
        }).toList()):SizedBox(),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      }),
    );
  }
}
