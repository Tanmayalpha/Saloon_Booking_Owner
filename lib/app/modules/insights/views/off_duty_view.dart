import 'package:beauty_salons_owner/app/modules/global_widgets/text_field_widget.dart';
import 'package:beauty_salons_owner/app/providers/laravel_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../common/ui.dart';
import '../../../models/user_model.dart';
import '../controllers/insight_controller.dart';

class OffDutyView extends GetView<InsightController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Off Duty".tr,
          style: Get.textTheme.headline6
              .merge(TextStyle(color: context.theme.primaryColor)),
        ),
        centerTitle: true,
        backgroundColor: Get.theme.colorScheme.secondary,
        automaticallyImplyLeading: false,
        elevation: 0,
       /* actions: [ Switch(
          value: controller.salon.value.closed,
          activeColor: Get.theme.primaryColor,
          onChanged: (bool val) {
            controller.updateDuty1(false);

          },),],*/
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
          onPressed: () => {
            Get.back()
            //Get.find<RootController>().changePageOutRoot(0)
          },
        ),
      ),
      /*floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add, size: 32, color: Get.theme.primaryColor),
        onPressed: (){
          controller.loading.value = true;
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
                    onSelectionChanged: controller.onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                   */
      /* initialSelectedRange: PickerDateRange(
                        DateTime.now(),
                        DateTime.now().add(const Duration(days: 3))),*/
      /*
                    onCancel: () {
                      Get.back();
                      controller.loading.value = false;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          'Selection Cancelled',
                        ),
                        duration: Duration(milliseconds: 2000),
                      ));
                    },
                    onSubmit: (Object value) {
                      Get.back();
                      controller.loading.value = false;
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
        },
        backgroundColor: Get.theme.colorScheme.secondary,
      ),*/
      body: RefreshIndicator(
        onRefresh: ()async{
          Get.find<LaravelApiClient>().forceRefresh();
          controller.getInsight();
          //controller.getOnOff();
          Get.find<LaravelApiClient>().unForceRefresh();
        },
        child: Obx(() {
          return !controller.loading.value
              ? SingleChildScrollView(
            child: Container(
              height: Get.height,
              padding: EdgeInsets.all(18.0),
              child:Column(
                children: [
                  Container( alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
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
                    child: TextField(
                      onTap: ()async{
                        DateTime val = await controller.selectDate(context,initialDate: controller.fromDate.text!=""?DateTime.parse(controller.fromDate.text):null,startDate: DateTime.now(),endDate: controller.toDate.text!=""?DateTime.parse(controller.toDate.text):null);
                        if(val!=null){
                          controller.fromDate.text = DateFormat("yyyy-MM-dd").format(val);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "From Date".tr,
                        hintText: "Date".tr,
                      ),
                      controller: controller.fromDate,
                      readOnly: true,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container( alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
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
                    child: TextField(
                      onTap: ()async{
                        print(controller.fromDate.text);
                        DateTime val = await controller.selectDate(context,startDate: controller.fromDate.text!=""?DateTime.parse(controller.fromDate.text):DateTime.now(),initialDate: controller.fromDate.text!=""?DateTime.parse(controller.fromDate.text):DateTime.now());
                        if(val!=null){
                          controller.toDate.text = DateFormat("yyyy-MM-dd").format(val);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "To Date".tr,
                        hintText: "Date".tr,
                      ),
                      readOnly: true,
                      controller: controller.toDate,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        elevation: 0,
                        onPressed: (){
                          controller.updateDuty1(false);

                        },
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: Get.theme.primaryColorDark,
                        child: Text("Delete".tr, style: Get.textTheme.bodyText2.copyWith(color: Get.theme.primaryColor)),
                      ),
                      SizedBox(width: 10,),
                      MaterialButton(
                        elevation: 0,
                        onPressed: (){
                          if(controller.fromDate.text==""||controller.toDate.text=="")  {
                            Get.showSnackbar(Ui.ErrorSnackBar(message: "Please Select Both Dates"));
                            return;
                          }
                          controller.getCountBooking();
                        },
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: Get.theme.primaryColorDark,
                        child: Text("Submit".tr, style: Get.textTheme.bodyText2.copyWith(color: Get.theme.primaryColor)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
              : Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
    );
  }
}
