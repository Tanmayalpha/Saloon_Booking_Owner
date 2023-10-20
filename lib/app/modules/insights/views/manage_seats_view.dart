import 'package:beauty_salons_owner/app/modules/global_widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/user_model.dart';
import '../controllers/insight_controller.dart';

class ManageSeatsView extends GetView<InsightController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Manage Seats".tr,
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
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add, size: 32, color: Get.theme.primaryColor),
        onPressed: (){
          if(controller.salon.value.employees.isNotEmpty&&(controller.salon.value.employees.last.name==""||!controller.salon.value.employees.last.readOnly)){
            Get.showSnackbar(Ui.ErrorSnackBar(message: "Please First Add Previous Seats"));
            return;
          }
          controller.salon.update((val) {
            val.employees.add(User(
              userId: "0",
              name: "",
              focusNode: FocusNode(),
              readOnly: false,
            ));
          });
          controller.salon.value.employees.last.focusNode.requestFocus();
        },
        backgroundColor: Get.theme.colorScheme.secondary,
      ),
      body: Obx(() {
        return !controller.loading.value
            ? SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(18.0),
                  child: controller.salon.value.employees!=null?Column(
                    children: controller.salon.value.employees.map((e) {
                      int index = controller.salon.value.employees
                          .indexWhere((element) => element.userId == e.userId);
                      return index!=0?Container(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                            ],
                            border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            e.userId!="0"?Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Off Duty".tr,
                                  style: Get.textTheme.bodyText2
                                      .copyWith(color: Colors.black),
                                ),
                                Obx(() {
                                  return controller.selectedOffer.value?Switch(
                                    value: controller.salon.value.employees[index].isOff,
                                    activeColor: Get.theme.colorScheme.primary,
                                    onChanged: (bool val) {
                                      controller.salon.value.employees[index].isOff = val;
                                      controller.updateSeats(index, "update");
                                    },
                                  ):SizedBox();
                                })
                              ],
                            ):SizedBox(),
                            TextFieldWidget(
                              labelText: "Seat ${index}".tr,
                              hintText: "Name".tr,
                              readOnly: e.readOnly,

                              focusNode: e.focusNode,
                              suffixIcon:e.userId!="0" ?Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        e.focusNode.requestFocus();
                                        controller.salon.update((val) {
                                          val.employees[index].readOnly = false;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        controller.getDeleteBooking(controller.salon.value.employees[index].userId,index);

                                      },
                                      icon: Icon(
                                        Icons.delete,
                                      )),
                                ],
                              ):IconButton(
                                  onPressed: () {
                                    controller.updateSeats(index, "add");
                                  },
                                  icon: Icon(
                                    Icons.add,
                                  )),
                              initialValue: e.name,
                              onChanged: (val1){
                                e.name = val1;

                                /*controller.salon.update((val) {
                                  val.employees[index].name = val1;
                                  val.employees[index].readOnly = true;
                                });*/
                              },
                              onSaved: (input) {
                                print(input);
                                if(input!=""){
                                  if(e.userId=="0" ){
                                   // controller.updateSeats(index, "add");
                                  }else{
                                    controller.salon.update((val) {
                                      val.employees[index].name = input;
                                      val.employees[index].readOnly = true;
                                    });
                                    controller.updateSeats(index, "update");
                                  }
                                }


                                //print(controller.user[e]);
                              },
                              validator: (input) => input.length < 3
                                  ? "Should be more than 3 characters".tr
                                  : null,
                              iconData: Icons.event_seat,
                              isFirst: false,
                              isLast: true,
                            ),
                          ],
                        ),
                      ):SizedBox();
                    }).toList(),
                  ):SizedBox(),
                ),
              )

            : Center(
                child: CircularProgressIndicator(),
              );
      }),
    );
  }
}
