import 'package:beauty_salons_owner/app/models/user_model.dart';
import 'package:beauty_salons_owner/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../providers/laravel_provider.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/bookings_list_widget.dart';
import '../widgets/statistics_carousel_widget.dart';

class HomeView extends GetView<HomeController> {
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
              Obx(() {
                return SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  expandedHeight: 240,
                  elevation: 0.5,
                  floating: false,
                  pinned: true,
                  iconTheme: IconThemeData(color: Get.theme.primaryColor),
                  title: Text(
                    Get.find<SettingsService>().setting.value.salonAppName,
                    style: Get.textTheme.headline6,
                  ),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  leading: new IconButton(
                    icon: new Icon(Icons.sort, color: Colors.black87),
                    onPressed: () => {Scaffold.of(context).openDrawer()},
                  ),
                  actions: [NotificationsButtonWidget()],
                  bottom: controller.filterStatuses.isEmpty
                      ? TabBarLoadingWidget()
                      : PreferredSize(
                        preferredSize: Size(double.infinity, 180),
                        child: Column(
                          children: [
                            StatisticsCarouselWidget(
                              statisticsList: controller.statistics,
                            ).paddingOnly(top: 10, bottom: 10),
                            TabBarWidget(
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
                              ),
                          ],
                        ),
                      ),
                  /*flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: StatisticsCarouselWidget(
                        statisticsList: controller.statistics,
                      ).paddingOnly(top: 70, bottom: 10)),*/
                );
              }),
              SliverToBoxAdapter(
                child: Wrap(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        /*Expanded(child: Obx(() {
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
                        }),),*/
                        Container(
                          width: 100,
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
                            onTap: (){
                              Get.toNamed(Routes.SEAT,arguments: controller.currentStatus.value);
                            },
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: "Seat View",
                              hintStyle: TextStyle(
                                color: Get.theme.colorScheme.primary
                              ),
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.all(5.0),
                            ),
                          ),
                        )
                      ],
                    ),
                    BookingsListWidget(),
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
