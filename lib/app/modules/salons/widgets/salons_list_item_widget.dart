/*
 * File name: salons_list_item_widget.dart
 * Last modified: 2022.10.16 at 12:23:13
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:beauty_salons_owner/app/modules/root/controllers/root_controller.dart';
import 'package:beauty_salons_owner/app/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/salon_model.dart';
import '../../../routes/app_routes.dart';
import '../themes/salons_list_item_theme.dart';
import 'salon_main_thumb_widget.dart';

class SalonsListItemWidget extends StatelessWidget {
  const SalonsListItemWidget({
    Key key,
    @required Salon salon,
  })  : _salon = salon,
        super(key: key);

  final Salon _salon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.SALON, arguments: {'salon': _salon});
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          decoration: containerBoxDecoration(),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                color: Get.theme.colorScheme.primary,
                alignment: Alignment.center,
                child: Text(
                  "Partner ID - ${_salon.code}",
                  style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
                ),
              ),
              SalonMainThumbWidget(salon: _salon),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      _salon.name ?? '',
                      maxLines: 2,
                      style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.hintColor)),
                    ),
                    Text(
                      _salon.description ?? '',
                      maxLines: 3,
                      style: Get.textTheme.bodyText1,
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 5,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      direction: Axis.horizontal,
                      children: [
                        Wrap(
                          children: Ui.getStarsList(_salon.rate),
                        ),

                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pay To Trimzzy : ₹"+_salon.cash_balance ?? '',
                          maxLines: 2,
                          style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.hintColor)),
                        ),
                        Text(
                          "From Trimzzy : ₹"+_salon.online_balance ?? '',
                          maxLines: 2,
                          style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.hintColor)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              _salon.subscription?Container(

                //  height: 40,
                color: Get.theme.colorScheme.primary,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      flex:2,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Subscribed",
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex:3,
                      child: Container(
                        color: Get.theme.colorScheme.primary,
                        padding: EdgeInsets.all(10.0),
                        //   height: 40,
                        width: double.infinity,
                        child: Text(
                          "Valid Till - ${_salon.subscriptionEndDate}",
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ):Container(
                //  height: 40,
                //color: Get.theme.colorScheme.primary,
                color: Theme.of(context).hintColor.withOpacity(0.1),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      flex:4,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Subscribe to go online",
                          style: Theme.of(context).textTheme.headline4
                            .copyWith(
                        color:
                        Colors.black,fontSize: 14.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4,bottom: 4,right:8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 25,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(1),
                                  backgroundColor: MaterialStateProperty.all(Colors.green),
                                  //padding:MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 10,vertical: 1)),
                                ),
                                onPressed: () {
                                  Get.find<RootController>().razorPayment(context);
                                },
                                child: Text(
                                  "Subscribe",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                      color:
                                      Colors.white,fontSize: 10.0),
                                )),
                          ),
                          const SizedBox(height: 5,),
                          Text(
                            "₹${Get.find<SettingsService>().setting.value.subscriptionAmount}/${Get.find<SettingsService>().setting.value.subscriptionType}",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(
                                color:
                                Colors.black,fontSize: 10.0),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              /*Container(
                color: Colors.white,
                alignment: Alignment.centerRight,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    !_salon.subscription?InkWell(
                      onTap: (){
                        Get.find<RootController>().razorPayment(context);
                      },
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(10.0),
                        width: 100,
                        //   height: 40,
                        child: Text(
                          "₹${Get.find<SettingsService>().setting.value.subscriptionAmount}/${Get.find<SettingsService>().setting.value.subscriptionType}",
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Colors.black
                          ),
                        ),
                      ),
                    ):SizedBox(),
                  ],
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
