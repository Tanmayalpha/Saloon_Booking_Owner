/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../common/ui.dart';

class TextFieldWidget extends StatelessWidget {

  TextFieldWidget({
    Key key,
    this.onSaved,
    this.onChanged,
     this.onTap,
    this.validator,
    this.keyboardType,
    this.initialValue,
    this.hintText,
    this.errorText,
    this.iconData,
    this.labelText,
    this.obscureText,
    this.suffixIcon,
    this.readOnly = false,
    this.focusNode,
    this.isFirst,
    this.isLast,
    this.maxLength,
    this.inputFormatters,
    this.style,
    this.textAlign,
    this.suffix,
  }) : super(key: key);
   GestureTapCallback onTap;

  final FormFieldSetter<String> onSaved;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;
  final FocusNode focusNode;
  final String initialValue;
  final String hintText;
  final String errorText;
  final TextAlign textAlign;
  final String labelText;
  final TextStyle style;
  final IconData iconData;
  final bool obscureText;
  final bool isFirst;
  final bool readOnly;
  final int maxLength;
  final bool isLast;
  final Widget suffixIcon;
  final Widget suffix;
  final List<TextInputFormatter> inputFormatters;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
      margin: EdgeInsets.only(left: 20, right: 20, top: topMargin, bottom: bottomMargin),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: buildBorderRadius,
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
          ],
          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            labelText ?? "",
            style: Get.textTheme.bodyText1,
            textAlign: textAlign ?? TextAlign.start,
          ),
          TextFormField(
            maxLines: keyboardType == TextInputType.multiline ? null : 1,
            key: key,
            inputFormatters: inputFormatters ?? [],
            onTap: onTap,
            maxLength: maxLength,
            readOnly: readOnly,
            focusNode: focusNode ?? null,
            keyboardType: keyboardType ?? TextInputType.text,
            onFieldSubmitted: onSaved,
            onSaved: onSaved,
            onChanged: onChanged,
            validator: validator,
            initialValue: initialValue ?? '',
            style: style ?? Get.textTheme.bodyText2,
            obscureText: obscureText ?? false,
            textAlign: textAlign ?? TextAlign.start,
            decoration: Ui.getInputDecoration(
              hintText: hintText ?? '',
              iconData: iconData,
              suffixIcon: suffixIcon,
              suffix: suffix,
              errorText: errorText,
            ),
          ),
        ],
      ),
    );
  }

  BorderRadius get buildBorderRadius {
    if (isFirst != null && isFirst) {
      return BorderRadius.vertical(top: Radius.circular(10));
    }
    if (isLast != null && isLast) {
      return BorderRadius.vertical(bottom: Radius.circular(10));
    }
    if (isFirst != null && !isFirst && isLast != null && !isLast) {
      return BorderRadius.all(Radius.circular(0));
    }
    return BorderRadius.all(Radius.circular(10));
  }

  double get topMargin {
    if ((isFirst != null && isFirst)) {
      return 20;
    } else if (isFirst == null) {
      return 20;
    } else {
      return 0;
    }
  }

  double get bottomMargin {
    if ((isLast != null && isLast)) {
      return 10;
    } else if (isLast == null) {
      return 10;
    } else {
      return 0;
    }
  }
}
class TextFieldWidget1 extends StatelessWidget {
  TextFieldWidget1({
    Key key,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.hints,
    this.keyboardType,
    this.initialValue,
    this.hintText,
    this.errorText,
    this.iconData,
    this.labelText,
    this.obscureText,
    this.suffixIcon,
    this.isFirst,
    this.isLast,
    this.style,
    this.readonly,
    this.textAlign,
    this.inputFormatters,
    this.suffix,
    this.controller,
    this.maximumLength,

  }) : super(key: key);
  final List<TextInputFormatter> inputFormatters;
  final FormFieldSetter<String> onSaved;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;
  final String initialValue;
  final String hintText;
  final String errorText;
  final TextAlign textAlign;
  final String labelText;
  final TextStyle style;
  final AutofillHints hints;
  final IconData iconData;
  final bool obscureText;
  final bool isFirst;
  final bool isLast;
  final bool readonly;
  final Widget suffixIcon;
  final Widget suffix;
  final int maximumLength;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
      margin: EdgeInsets.only(left: 20, right: 20, top: topMargin, bottom: bottomMargin),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: buildBorderRadius,
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
          ],
          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            labelText ?? "",
            style: Get.textTheme.bodyText1,
            textAlign: textAlign ?? TextAlign.start,
          ),
          TextFormField(
            controller: controller,
            maxLength: maximumLength,
            autofillHints: [
              AutofillHints.telephoneNumber,
            ],
            inputFormatters: inputFormatters ?? [],
            enableSuggestions: true,
            maxLines: keyboardType == TextInputType.multiline ? null : 1,
            key: key,
            readOnly: readonly ?? false,
            keyboardType: keyboardType ?? TextInputType.text,
            onSaved: onSaved,
            onChanged: onChanged,

            validator: validator,

            style: style ?? Get.textTheme.bodyText2,
            obscureText: obscureText ?? false,
            textAlign: textAlign ?? TextAlign.start,
            decoration: Ui.getInputDecoration(
              hintText: hintText ?? '',
              iconData: iconData,
              suffixIcon: suffixIcon,
              suffix: suffix,
              errorText: errorText,
            ),
          ),
        ],
      ),
    );
  }

  BorderRadius get buildBorderRadius {
    if (isFirst != null && isFirst) {
      return BorderRadius.vertical(top: Radius.circular(10));
    }
    if (isLast != null && isLast) {
      return BorderRadius.vertical(bottom: Radius.circular(10));
    }
    if (isFirst != null && !isFirst && isLast != null && !isLast) {
      return BorderRadius.all(Radius.circular(0));
    }
    return BorderRadius.all(Radius.circular(10));
  }

  double get topMargin {
    if ((isFirst != null && isFirst)) {
      return 20;
    } else if (isFirst == null) {
      return 20;
    } else {
      return 0;
    }
  }

  double get bottomMargin {
    if ((isLast != null && isLast)) {
      return 10;
    } else if (isLast == null) {
      return 10;
    } else {
      return 0;
    }
  }
}
class DeviceFieldWidget extends StatelessWidget {
  const DeviceFieldWidget({
    Key key,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.hints,
    this.keyboardType,
    this.initialValue,
    this.hintText,
    this.errorText,
    this.iconData,
    this.labelText,
    this.obscureText,
    this.suffixIcon,
    this.isFirst,
    this.isLast,
    this.style,
    this.textAlign,
    this.suffix,
    this.maximumLength,
    this.controller,
  }) : super(key: key);

  final FormFieldSetter<String> onSaved;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;
  final String initialValue;
  final String hintText;
  final String errorText;
  final TextAlign textAlign;
  final String labelText;
  final TextStyle style;
  final AutofillHints hints;
  final IconData iconData;
  final bool obscureText;
  final bool isFirst;
  final bool isLast;
  final Widget suffixIcon;
  final Widget suffix;
  final int maximumLength;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
      margin: EdgeInsets.only(left: 20, right: 20, top: topMargin, bottom: bottomMargin),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: buildBorderRadius,
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
          ],
          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            labelText ?? "",
            style: Get.textTheme.bodyText1,
            textAlign: textAlign ?? TextAlign.start,
          ),
          PhoneFieldHint(
            controller: controller,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            /*  child: TextField(
              controller: controller,
              maxLength: maximumLength,
              autofillHints: [
                AutofillHints.telephoneNumber,
              ],
              enableSuggestions: true,
              maxLines: keyboardType == TextInputType.multiline ? null : 1,
              key: key,
              keyboardType: keyboardType ?? TextInputType.text,
              onChanged: onChanged,
              style: style ?? Get.textTheme.bodyText2,
              obscureText: obscureText ?? false,
              textAlign: textAlign ?? TextAlign.start,
              decoration: Ui.getInputDecoration(
                hintText: hintText ?? '',
                iconData: iconData,
                suffixIcon: suffixIcon,
                suffix: suffix,
                errorText: errorText,
              ),
            ),*/
            decoration:  Ui.getInputDecoration(
              hintText: hintText ?? '',
              iconData: iconData,
              suffixIcon: suffixIcon,
              suffix: suffix,
              errorText: errorText,
            ),
          ),
          /* TextFormField(
            maxLength: maximumLength,
            autofillHints: [
              AutofillHints.telephoneNumber,
            ],
            enableSuggestions: true,
            maxLines: keyboardType == TextInputType.multiline ? null : 1,
            key: key,
            keyboardType: keyboardType ?? TextInputType.text,
            onSaved: onSaved,
            onChanged: onChanged,
            controller: controller,
            validator: validator,
            initialValue: initialValue ?? '',
            style: style ?? Get.textTheme.bodyText2,
            obscureText: obscureText ?? false,
            textAlign: textAlign ?? TextAlign.start,
            decoration: Ui.getInputDecoration(
              hintText: hintText ?? '',
              iconData: iconData,
              suffixIcon: suffixIcon,
              suffix: suffix,
              errorText: errorText,
            ),
          ),*/
        ],
      ),
    );
  }

  BorderRadius get buildBorderRadius {
    if (isFirst != null && isFirst) {
      return BorderRadius.vertical(top: Radius.circular(10));
    }
    if (isLast != null && isLast) {
      return BorderRadius.vertical(bottom: Radius.circular(10));
    }
    if (isFirst != null && !isFirst && isLast != null && !isLast) {
      return BorderRadius.all(Radius.circular(0));
    }
    return BorderRadius.all(Radius.circular(10));
  }

  double get topMargin {
    if ((isFirst != null && isFirst)) {
      return 20;
    } else if (isFirst == null) {
      return 20;
    } else {
      return 0;
    }
  }

  double get bottomMargin {
    if ((isLast != null && isLast)) {
      return 10;
    } else if (isLast == null) {
      return 10;
    } else {
      return 0;
    }
  }
}