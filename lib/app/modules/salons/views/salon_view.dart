/*
 * File name: salon_view.dart
 * Last modified: 2022.10.16 at 12:23:15
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../common/map.dart';
import '../../../../common/ui.dart';
import '../../../models/media_model.dart';
import '../../../models/salon_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/salon_controller.dart';
import '../widgets/availability_hour_item_widget.dart';
import '../widgets/featured_carousel_widget.dart';
import '../widgets/salon_til_widget.dart';
import '../widgets/salon_title_bar_widget.dart';

class SalonView extends GetView<SalonController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var _salon = controller.salon.value;
      if (!_salon.hasData) {
        return Scaffold(
          body: CircularLoadingWidget(height: Get.height),
        );
      } else {
        return Scaffold(
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              controller.showButton.value
                  ? Tooltip(
                key: controller.service,
                textAlign: TextAlign.left,
                message: "Services",
                verticalOffset: -15,
                margin: EdgeInsets.only(right: 70),
                triggerMode: TooltipTriggerMode.manual,
                child: FloatingActionButton(
                  heroTag: "btnS",
                  child: new Icon(Icons.design_services,
                      size: 28, color: Get.theme.primaryColor),
                  onPressed: () => {
                  Get.toNamed(Routes.E_SERVICES,
                  arguments: _salon)
                  },
                  backgroundColor: Get.theme.colorScheme.secondary,
                ),
              )
                  : SizedBox(),
              SizedBox(
                height: 8,
              ),
              controller.showButton.value
                  ? Tooltip(
                      key: controller.bank,
                      textAlign: TextAlign.left,
                      message: "Bank",
                      verticalOffset: -15,
                      margin: EdgeInsets.only(right: 70),
                      triggerMode: TooltipTriggerMode.manual,
                      child: FloatingActionButton(
                        heroTag: "btn1",
                        child: new Icon(Icons.food_bank,
                            size: 28, color: Get.theme.primaryColor),
                        onPressed: () => {
                          Get.toNamed(Routes.SALON_BANK_FORM,
                              arguments: {'salon': _salon, 'index': 280,'from':true})
                        },
                        backgroundColor: Get.theme.colorScheme.secondary,
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 8,
              ),
              controller.showButton.value
                  ? Tooltip(
                      key: controller.link,
                      textAlign: TextAlign.left,
                      message: "Links",
                      verticalOffset: -15,
                      margin: EdgeInsets.only(right: 70),
                      triggerMode: TooltipTriggerMode.manual,
                      child: FloatingActionButton(
                        heroTag: "btn2",
                        tooltip: "Links",
                        child: new Icon(Icons.link,
                            size: 28, color: Get.theme.primaryColor),
                        onPressed: () => {
                          Get.toNamed(Routes.SALON_LINK_FORM,
                              arguments: {'salon': _salon, 'index': 230,'from':true})
                        },
                        backgroundColor: Get.theme.colorScheme.secondary,
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 8,
              ),
              controller.showButton.value
                  ? Tooltip(
                      key: controller.working,
                      textAlign: TextAlign.left,
                      message: "Working Hours",
                      verticalOffset: -15,
                      margin: EdgeInsets.only(right: 70),
                      triggerMode: TooltipTriggerMode.manual,
                      child: FloatingActionButton(
                        heroTag: "btn3",
                        child: new Icon(Icons.timer,
                            size: 28, color: Get.theme.primaryColor),
                        onPressed: () => {
                          Get.toNamed(Routes.SALON_WORKING_FORM,
                              arguments: {'salon': _salon, 'index': 180,'from':true})
                        },
                        backgroundColor: Get.theme.colorScheme.secondary,
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 8,
              ),
              controller.showButton.value
                  ? Tooltip(
                      key: controller.edit,
                      textAlign: TextAlign.left,
                      message: "Edit ${controller.salon.value.salonCategory.title}",

                      verticalOffset: -15,
                      margin: EdgeInsets.only(right: 70),
                      triggerMode: TooltipTriggerMode.manual,
                      child: FloatingActionButton(
                        heroTag: "btn4",
                        child: new Icon(Icons.edit_outlined,
                            size: 28, color: Get.theme.primaryColor),
                        onPressed: () => {
                          Get.toNamed(Routes.SALON_ADD_FORM,
                              arguments: {'salon': _salon})
                        },
                        backgroundColor: Get.theme.colorScheme.secondary,
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 8,
              ),
              FloatingActionButton(
                heroTag: "btn5",
                child: new Icon(
                    controller.showButton.value
                        ? Icons.close
                        : Icons.edit_outlined,
                    size: 28,
                    color: Get.theme.primaryColor),
                onPressed: () async {
                  controller.showButton.value = !controller.showButton.value;
                  if (controller.showButton.value) {
                    await Future.delayed(Duration(milliseconds: 500));
                    dynamic tooltipS = controller.service.currentState;
                    tooltipS.ensureTooltipVisible();
                    dynamic tooltip = controller.bank.currentState;
                    tooltip.ensureTooltipVisible();
                    dynamic tooltip1 = controller.link.currentState;
                    tooltip1.ensureTooltipVisible();
                    dynamic tooltip2 = controller.working.currentState;
                    tooltip2.ensureTooltipVisible();
                    dynamic tooltip3 = controller.edit.currentState;
                    tooltip3.ensureTooltipVisible();
                  }
                },
                backgroundColor: Get.theme.colorScheme.secondary,
              ),
            ],
          ),
          body: RefreshIndicator(
              onRefresh: () async {
                Get.find<LaravelApiClient>().forceRefresh();
                controller.refreshSalon(showMessage: true);
                Get.find<LaravelApiClient>().unForceRefresh();
              },
              child: CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 310,
                    elevation: 0,
                    floating: true,
                    iconTheme:
                        IconThemeData(color: Theme.of(context).primaryColor),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: new IconButton(
                      icon: new Icon(Icons.arrow_back_ios,
                          color: Get.theme.hintColor),
                      onPressed: () => {Get.back()},
                    ),
                    bottom: buildSalonTitleBarWidget(_salon),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Obx(() {
                        return Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            buildCarouselSlider(_salon),
                            buildCarouselBullets(_salon),
                          ],
                        );
                      }),
                    ).marginOnly(bottom: 50),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10),
                        SalonTilWidget(
                          title: Text("Description".tr,
                              style: Get.textTheme.subtitle2),
                          content: Ui.applyHtml(_salon.description ?? '',
                              style: Get.textTheme.bodyText1),
                        ),
                        buildAddress(context),
                        buildAvailabilityHours(_salon),
                        buildAwards(),
                        buildExperiences(),
                        /*SalonTilWidget(
                          horizontalPadding: 0,
                          title: Text("Featured Services".tr,
                                  style: Get.textTheme.subtitle2)
                              .paddingSymmetric(horizontal: 20),
                          content: FeaturedCarouselWidget(),
                          actions: [
                            InkWell(
                              onTap: () {
                                Get.toNamed(Routes.E_SERVICES,
                                    arguments: _salon);
                              },
                              child: Text("View All".tr,
                                  style: Get.textTheme.subtitle1),
                            ).paddingSymmetric(horizontal: 20),
                          ],
                        ),*/
                        buildGalleries(),
                      ],
                    ),
                  ),
                ],
              )),
        );
      }
    });
  }

  Widget buildGalleries() {
    return Obx(() {
      if (controller.galleries.isEmpty) {
        return SizedBox();
      }
      return SalonTilWidget(
        horizontalPadding: 0,
        title: Text("Galleries".tr, style: Get.textTheme.subtitle2)
            .paddingSymmetric(horizontal: 20),
        content: Container(
          height: 120,
          child: ListView.builder(
              primary: false,
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: controller.galleries.length,
              itemBuilder: (_, index) {

                var _media = controller.galleries.elementAt(index);
                return InkWell(
                  onTap: () {
                    Get.toNamed(Routes.GALLERY, arguments: {
                      'media': controller.galleries,
                      'current': _media,
                      'heroTag': 'e_provide_galleries'
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsetsDirectional.only(
                        end: 20,
                        start: index == 0 ? 20 : 0,
                        top: 10,
                        bottom: 10),
                    child: Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: CachedNetworkImage(
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: _media.thumb,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 100,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error_outline),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 12, top: 8),
                          child: Text(
                            _media.name ?? '',
                            maxLines: 2,
                            style: Get.textTheme.bodyText2.merge(
                                TextStyle(color: Get.theme.primaryColor)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
        actions: [
          // TODO show all galleries
        ],
      );
    });
  }

  SalonTilWidget buildAvailabilityHours(Salon _salon) {
    return SalonTilWidget(
      title: Text("Availability".tr, style: Get.textTheme.subtitle2),
      content: _salon.availabilityHours.isEmpty
          ? CircularLoadingWidget(height: 150)
          : ListView.separated(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              itemCount: _salon.groupedAvailabilityHours().entries.length,
              separatorBuilder: (context, index) {
                return Divider(height: 16, thickness: 0.8);
              },
              itemBuilder: (context, index) {
                var _availabilityHour =
                    _salon.groupedAvailabilityHours().entries.elementAt(index);
                var _data =
                    _salon.getAvailabilityHoursData(_availabilityHour.key);
                return AvailabilityHourItemWidget(
                    availabilityHour: _availabilityHour, data: _data);
              },
            ),
      actions: [
        if (!_salon.closed)
          Container(
            child: Text("Open".tr,
                maxLines: 1,
                style: Get.textTheme.bodyText2.merge(
                  TextStyle(color: Colors.green, height: 1.4, fontSize: 10),
                ),
                softWrap: false,
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
        if (_salon.closed)
          Container(
            child: Text("Closed".tr,
                maxLines: 1,
                style: Get.textTheme.bodyText2.merge(
                  TextStyle(color: Colors.grey, height: 1.4, fontSize: 10),
                ),
                softWrap: false,
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
      ],
    );
  }

  Widget buildAwards() {
    return Obx(() {
      if (controller.awards.isEmpty) {
        return SizedBox(height: 0);
      }
      return SalonTilWidget(
        title: Text("Awards".tr, style: Get.textTheme.subtitle2),
        content: ListView.separated(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          itemCount: controller.awards.length,
          separatorBuilder: (context, index) {
            return Divider(height: 16, thickness: 0.8);
          },
          itemBuilder: (context, index) {
            var _award = controller.awards.elementAt(index);
            return Column(
              children: [
                Text(_award.title ?? '').paddingSymmetric(vertical: 5),
                Ui.applyHtml(
                  _award.description ?? '',
                  style: Get.textTheme.caption,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            );
          },
        ),
      );
    });
  }

  Widget buildExperiences() {
    return Obx(() {
      if (controller.experiences.isEmpty) {
        return SizedBox(height: 0);
      }
      return SalonTilWidget(
        title: Text("Experiences".tr, style: Get.textTheme.subtitle2),
        content: ListView.separated(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          itemCount: controller.experiences.length,
          separatorBuilder: (context, index) {
            return Divider(height: 16, thickness: 0.8);
          },
          itemBuilder: (context, index) {
            var _experience = controller.experiences.elementAt(index);
            return Column(
              children: [
                Text(_experience.title ?? '').paddingSymmetric(vertical: 5),
                Text(
                  _experience.description ?? '',
                  style: Get.textTheme.caption,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            );
          },
        ),
      );
    });
  }

  Container buildAddress(context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: Ui.getBoxDecoration(),
      child: (controller.salon.value.address == null)
          ? Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.15),
              highlightColor: Colors.grey[200].withOpacity(0.1),
              child: Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: MapsUtil.getStaticMaps(
                      [controller.salon.value.address.getLatLng()]),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(controller.salon.value.address.description,
                          style: Get.textTheme.subtitle2),
                      SizedBox(height: 5),
                      Text(controller.salon.value.address.address,
                          style: Get.textTheme.caption),
                    ],
                  ).marginOnly(bottom: 10),
                ),
              ],
            ),
    );
  }

  CarouselSlider buildCarouselSlider(Salon _salon) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7),
        height: 360,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          controller.currentSlide.value = index;
        },
      ),
      items: _salon.images.map((Media media) {
        return Builder(
          builder: (BuildContext context) {
            return CachedNetworkImage(
              width: double.infinity,
              height: 360,
              fit: BoxFit.cover,
              imageUrl: media.url,
              placeholder: (context, url) => Image.asset(
                'assets/img/loading.gif',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error_outline),
            );
          },
        );
      }).toList(),
    );
  }

  Container buildCarouselBullets(Salon _salon) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _salon.images.map((Media media) {
          return Container(
            width: 20.0,
            height: 5.0,
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: controller.currentSlide.value ==
                        _salon.images.indexOf(media)
                    ? Get.theme.hintColor
                    : Get.theme.primaryColor.withOpacity(0.4)),
          );
        }).toList(),
      ),
    );
  }

  SalonTitleBarWidget buildSalonTitleBarWidget(Salon _salon) {
    return SalonTitleBarWidget(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _salon.name ?? '',
                  style: Get.textTheme.headline5.merge(TextStyle(height: 1.1)),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
             /* Container(
                child: Text(_salon.salonLevel?.name?.tr ?? ' . . . ',
                    maxLines: 1,
                    style: Get.textTheme.bodyText2.merge(
                      TextStyle(
                          color: Get.theme.colorScheme.secondary,
                          height: 1.4,
                          fontSize: 10),
                    ),
                    softWrap: false,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),*/
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: List.from(Ui.getStarsList(_salon.rate ?? 0))
                    ..addAll([
                      SizedBox(width: 5),
                      Text(
                        "Reviews (%s)".trArgs([_salon.totalReviews.toString()]),
                        style: Get.textTheme.caption,
                      ),
                    ]),
                ),
              ),
             /* Text(
                "Ok", // TODO "Bookings (%s)".trArgs([_salon.bookingsInProgress.toString()]),
                style: Get.textTheme.caption,
              ),*/
            ],
          ),
        ],
      ),
    );
  }
}
