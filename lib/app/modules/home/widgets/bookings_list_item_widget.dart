/*
 * File name: bookings_list_item_widget.dart
 * Last modified: 2022.02.27 at 23:37:17
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:beauty_salons_owner/app/modules/bookings/widgets/booking_row_widget.dart';
import 'package:beauty_salons_owner/app/modules/home/controllers/home_controller.dart';
import 'package:beauty_salons_owner/app/services/global_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/booking_address_chip_widget.dart';
import 'booking_options_popup_menu_widget.dart';

class BookingsListItemWidget extends StatelessWidget {
   BookingsListItemWidget({
    Key key,
    @required Booking booking,
    @required this.onPressed,
     @required this.onComplete,
     @required this.onCancel,
     @required this.onShow,
  })  : _booking = booking,
        super(key: key);

  final Booking _booking;
  VoidCallback onPressed;
  VoidCallback onComplete,onCancel,onShow;
  @override
  Widget build(BuildContext context) {
    Color _color = _booking.cancel ? Get.theme.focusColor : Get.theme.colorScheme.secondary;
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.BOOKING, arguments: _booking);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: Ui.getBoxDecoration(),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: BookingRowWidget(
                      descriptionFlex: 2,
                      valueFlex: 1,
                      description: "Booking ID".tr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: Get.theme.focusColor.withOpacity(0.1),
                            ),
                            child: Text(
                              _booking.id,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              softWrap: true,
                              style: TextStyle(color: Get.theme.hintColor),
                            ),
                          ),
                        ],
                      ),
                      hasDivider: true),
                ),
                Expanded(
                    flex: 2,
                    child: SizedBox()),
                //SizedBox(width: 20,),
                Container(
                  padding: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: _booking.status.status.toLowerCase().contains("confirmed")?Colors.yellow:
                    _booking.status.status.toLowerCase().contains("completed")?Colors.green:_booking.status.status.toLowerCase().contains("accepted")?Colors.orange:Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      _booking.status.order == Get.find<GlobalService>().global.value.noShow?_booking.status.status:_booking.cancel?_booking.cancel_by!=null&&_booking.cancel_by!=""?"${_booking.status.status} by ${_booking.cancel_by}":"${_booking.status.status} by user":_booking.status.status,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      softWrap: true,
                      style: TextStyle(color:_booking.status.status.toLowerCase().contains("confirmed")?Colors.black: Get.theme.scaffoldBackgroundColor,fontSize: 10.0),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      child: Container(
                        height: 80,
                        width: 80,
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                              imageUrl: _booking.salon.firstImageThumb,
                              placeholder: (context, url) => Image.asset(
                                'assets/img/loading.gif',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 80,
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error_outline),
                            ),
                            _booking.otpVerified==1?Image.asset(
                              'assets/icon/check.png',
                              fit: BoxFit.cover,
                              width:  80,
                              height: 80,
                            ):SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    if (_booking.status.order==Get.find<GlobalService>().global.value.done&&_booking.payment != null)
                      Container(
                        width: 80,
                        child: Text(_booking.payment.paymentStatus?.status ?? '',
                            style: Get.textTheme.caption.merge(
                              TextStyle(fontSize: 10),
                            ),
                            maxLines: 1,
                            softWrap: false,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade),
                        decoration: BoxDecoration(
                          color: Get.theme.focusColor.withOpacity(0.2),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                      ),
                    Container(
                      width: 80,
                      child: Column(
                        children: [
                          Text(DateFormat('HH:mm', Get.locale.toString()).format(_booking.bookingAt),
                              maxLines: 1,
                              style: Get.textTheme.bodyText2.merge(
                                TextStyle(color: Get.theme.primaryColor, height: 1.4),
                              ),
                              softWrap: false,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade),
                          Text(DateFormat('dd', Get.locale.toString()).format(_booking.bookingAt),
                              maxLines: 1,
                              style: Get.textTheme.headline3.merge(
                                TextStyle(color: Get.theme.primaryColor, height: 1),
                              ),
                              softWrap: false,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade),
                          Text(DateFormat('MMM', Get.locale.toString()).format(_booking.bookingAt),
                              maxLines: 1,
                              style: Get.textTheme.bodyText2.merge(
                                TextStyle(color: Get.theme.primaryColor, height: 1),
                              ),
                              softWrap: false,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: _color,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                    ),
                  ],
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Opacity(
                    opacity: _booking.cancel||_booking.status.order == Get.find<GlobalService>().global.value.noShow ? 0.3 : 1,
                    child: Wrap(
                      runSpacing: 10,
                      alignment: WrapAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _booking.salon?.name ?? '',
                                style: Get.textTheme.bodyText2,
                                maxLines: 3,
                              ),
                            ),
                            BookingOptionsPopupMenuWidget(booking: _booking),
                          ],
                        ),
                        Divider(height: 8, thickness: 1),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outlined,
                              size: 18,
                              color: Get.theme.focusColor,
                            ),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                _booking.user?.name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: Get.textTheme.bodyText1,
                              ),
                            ),
                          ],
                        ),
                        if (_booking.employee != null)
                          Row(
                            children: [
                              Icon(
                                Icons.badge_outlined,
                                size: 18,
                                color: Get.theme.focusColor,
                              ),
                              SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  "${_booking.employee.name}(Seat ${_booking.employee.seat_no})",
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: Get.textTheme.bodyText1,
                                ),
                              ),
                            ],
                          ),
                        Divider(height: 8, thickness: 1),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.design_services,
                              size: 18,
                              color: Get.theme.focusColor,
                            ),
                            SizedBox(width: 5),
                            Wrap(
                              children: _booking.eServices.map((e) {
                                return Text(
                                  "${e.name},",
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: Get.textTheme.bodyText1,
                                );
                              }).toList(),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 8, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Total".tr,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: Get.textTheme.bodyText1,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Ui.getPrice(
                      _booking.getTotal(),
                      style: Get.textTheme.headline6.merge(TextStyle(color: _color)),
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 8, thickness: 1),
            _booking.status.order != Get.find<GlobalService>().global.value.received&&_booking.status.order != Get.find<GlobalService>().global.value.noShow&&!_booking.status.status.toLowerCase().contains("completed")&&!_booking.status.status.toLowerCase().contains("cancelled")?
            _booking.otpVerified==0?Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            if(_booking.showOtp)Expanded(
                  flex: 2,
                  child:TextField(
                    controller: _booking.controller,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    style: Get.textTheme.bodyText1,
                    decoration: InputDecoration(
                      hintText: "Enter OTP"
                    ),
                  ),
                ),
                if(_booking.showOtp)
                  SizedBox(width: 10,),

                Get.find<HomeController>().currentStatus.value!="2"?MaterialButton(
                  elevation: 0,
                  onPressed: onPressed,
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.hintColor.withOpacity(0.1),
                  child: Text(_booking.showOtp?"Submit":"Enter OTP".tr, style: Get.textTheme.bodyText2),
                ):SizedBox(),
                SizedBox(width: 5,),
                !_booking.showOtp&&Get.find<HomeController>().currentStatus.value!="2"?MaterialButton(
                  elevation: 0,
                  onPressed: onShow,
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.hintColor.withOpacity(0.1),
                  child: Text(_booking.showData?"No Show".tr:"Show".tr, style: Get.textTheme.bodyText2),
                ):SizedBox(),
                SizedBox(width: 5,),
                if (_booking.showData&&!_booking.cancel && _booking.status.order < Get.find<GlobalService>().global.value.onTheWay)
                  !_booking.showOtp?MaterialButton(
                    elevation: 0,
                    onPressed: onCancel,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: Get.theme.hintColor.withOpacity(0.1),
                    child: Text("Cancel".tr, style: Get.textTheme.bodyText2),
                  ):SizedBox(),
              ],
            ):_booking.payment!=null&&_booking.payment.paymentStatus!=null?

            Column(
              children: [
               // _booking.showData?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Payment Method".tr,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: Get.textTheme.bodyText1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Get.theme.focusColor.withOpacity(0.1),
                      ),
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text(_booking.payment.paymentMethod.name=="Cash"?"Cash":"Online", style: Get.textTheme.bodyText2),
                    ),
                  ],
                ),
                  //  :SizedBox(),
                Divider(height: 8, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_booking.showData&&_booking.status.order == Get.find<GlobalService>().global.value.accepted)
                      MaterialButton(
                      elevation: 0,
                      onPressed: onComplete,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: Get.theme.hintColor.withOpacity(0.1),
                      child: Text("Completed".tr, style: Get.textTheme.bodyText2),
                    ),
                   /* if (_booking.showData&&_booking.status.order == Get.find<GlobalService>().global.value.accepted)
                      SizedBox(width: 5,),
                    if (_booking.showData&&_booking.status.id == Get.find<GlobalService>().global.value.accepted)
                    MaterialButton(
                      elevation: 0,
                      onPressed: onShow,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: Get.theme.hintColor.withOpacity(0.1),
                      child: Text("No Show".tr, style: Get.textTheme.bodyText2),
                    ),
                    SizedBox(width: 5,),
                    if (_booking.showData&&!_booking.cancel && _booking.status.order < Get.find<GlobalService>().global.value.onTheWay)
                        MaterialButton(
                          elevation: 0,
                          onPressed: onCancel,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: Get.theme.hintColor.withOpacity(0.1),
                          child: Text("Cancel".tr, style: Get.textTheme.bodyText2),
                        ),*/
                  ],
                ),
              ],
            ):SizedBox():SizedBox(),
          ],
        ),
      ),
    );
  }
}
