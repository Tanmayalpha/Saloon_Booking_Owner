import 'package:beauty_salons_owner/app/models/user_model.dart';
import 'package:beauty_salons_owner/app/modules/home/widgets/bookings_list_widget.dart';
import 'package:beauty_salons_owner/app/modules/seat_view/views/seat_bookings_list_widget.dart';
import 'package:beauty_salons_owner/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/helper.dart';
import '../../../providers/laravel_provider.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../controllers/seat_controller.dart';


class SeatView extends GetView<SeatController> {
  @override
  Widget build(BuildContext context) {
    controller.initScrollController();
    return Scaffold(
     /* floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add, size: 32, color: Get.theme.primaryColor),
        onPressed: () => {Get.toNamed(Routes.SALON_ADD_FORM)},
        backgroundColor: Get.theme.colorScheme.secondary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,*/
      appBar: AppBar(
        title: Text(
          "Seat View".tr,
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
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            controller.refreshHome(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: controller.scrollController,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Wrap(
                  children: [
                /*Obx(() {
                  return  controller.filterStatuses.isEmpty
                        ? TabBarLoadingWidget():TabBarWidget(
                      tag: 'home',
                      initialSelectedId: controller.filterStatuses.elementAt(0).id,
                      tabs: List.generate(controller.filterStatuses.length, (index) {
                        var _status = controller.filterStatuses.elementAt(index);
                        return ChipWidget(
                          tag: 'home',
                          text: _status.status,
                          id: _status.id,
                          onSelected: (id) {
                            controller.changeTab(id);
                          },
                        );
                      }),
                    );}),*/
                    Obx(() {
                      if (controller.seats.isEmpty)
                        return SizedBox();
                      else
                        return Container(
                          height: 60,
                          child: ListView.builder(
                              itemCount: controller.seats.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                User model = controller.seats[index];
                                return InkWell(
                                  onTap: () {
                                    for(int i = 0;i< controller.seats.length;i++){
                                      if(index==i){
                                        controller.seats[i].selected = true;
                                      }else{
                                        controller.seats[i].selected = false;
                                      }
                                    }
                                    controller.seatId.value = model.userId;
                                    controller.seats.refresh();
                                    controller.bookings.clear();
                                    controller.loadBookingsOfStatus(statusId: controller.currentStatus.value);
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
                                        "Seat ${model.seat_no}",
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
                                DateTime val = await controller.selectDate(context,endDate: controller.toCon.text!=""?DateTime.parse(controller.toCon.text):null);
                                if(val!=null){
                                  controller.dateCon.text = DateFormat("yyyy-MM-dd").format(val);
                                  controller.loadBookingsOfStatus(fromDate: true);
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
                                DateTime val = await controller.selectDate(context,startDate: controller.dateCon.text!=""?DateTime.parse(controller.dateCon.text):null);
                                if(val!=null){
                                  controller.toCon.text = DateFormat("yyyy-MM-dd").format(val);
                                  controller.loadBookingsOfStatus(fromDate: true);
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
                    SeatBookingsListWidget(),
                  ],
                ),
              ),
            ],
          )),
      /*bottomNavigationBar:  Obx(
            () => Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).iconTheme.color,
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(5.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: DropdownButton(
                      hint: Text("Seats"),
                      value: controller.seatId.value,
                      dropdownColor: Theme.of(context).iconTheme.color,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      underline: SizedBox(),
                      items: controller.seats.map((element) {
                        return DropdownMenuItem<String>(
                          value: element.userId.toString(),
                          child: Text(
                            "Seat ${element.seat_no}",
                            style: TextStyle(
                              color:
                              Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.seatId.value = value;
                        controller.bookings.clear();
                        controller.loadBookingsOfStatus(statusId: controller.currentStatus.value);
                      }),
                ),
              ),
              VerticalDivider(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: TextFormField(
                    readOnly: true,
                    controller: controller.dateCon,
                    onTap: (){
                      controller.selectDate(context);
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Date",
                      suffixIcon: Icon(Icons.calendar_month,color: Get.theme.primaryColor,),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),*/
    );
  }
}
