import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/ui.dart';
import '../../models/media_model.dart';
import '../../repositories/upload_repository.dart';

class ImageFieldController extends GetxController {
  Rx<File> image = Rx<File>(null);
  String uuid;
  final uploading = false.obs;
  UploadRepository _uploadRepository;

  ImageFieldController() {
    _uploadRepository = new UploadRepository();
  }

  @override
  void onInit() {
    super.onInit();
  }

  void reset() {
    image.value = null;
    uploading.value = false;
  }
  Future pickImage(ImageSource source, String field, ValueChanged<String> uploadCompleted) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.mediaLibrary,
      Permission.photos,
    //  Permission.accessMediaLocation,
    //  Permission.manageExternalStorage
    ].request();
// You can request multiple permissions at once.
    if(statuses[Permission.mediaLibrary]==PermissionStatus.granted){
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if(result==null){
        return;
      }
      /*var image1 = await ImagePickerGC.pickImage(
        context: Get.context,
        source: ImgSource.Gallery,

        imageQuality: 80,
        cameraIcon: Icon(
          Icons.add,
          color: Colors.red,
        ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
      );*/
      File imageFile = File(result.files.single.path);
      CroppedFile croppedFile = await ImageCropper().cropImage(
          sourcePath: imageFile.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 30,
          maxHeight: 200, maxWidth: 200,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings:[
          AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.lightBlueAccent,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false),
          IOSUiSettings(
          minimumAspectRatio: 1.0,
      )]);
      imageFile=File(croppedFile.path);
      bool check = await imageFile.exists();
      print(imageFile);
      if (imageFile != null&&check) {
        try {
          uploading.value = true;
          uuid = await _uploadRepository.image(imageFile, field);
          image.value = imageFile;
          uploadCompleted(uuid);
          uploading.value = false;
        } catch (e) {
          uploading.value = false;
          Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
        }
      } else {
        uploading.value = false;
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Please select an image file".tr));
      }
    }else{
      if (await Permission.camera.isDenied||await Permission.storage.isDenied) {

        // The user opted to never again see the permission request dialog for this
        // app. The only way to change the permission's status now is to let the
        // user manually enable it in the system settings.
        openAppSettings();
      }else{

      }
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Oops you just denied the permission".tr));
    }
  }

  /*Future pickImage(ImageSource source, String field, ValueChanged<String> uploadCompleted) async {
    */
  /*ImagePicker imagePicker = ImagePicker();
    XFile pickedFile = await imagePicker.pickImage(source: source, imageQuality: 80);
    File imageFile = File(pickedFile.path);
    print(imageFile);
    if (imageFile != null) {
      try {
        uploading.value = true;
        await deleteUploaded();
        uuid = await _uploadRepository.image(imageFile, field);
        image.value = imageFile;
        uploadCompleted(uuid);
        uploading.value = false;
      } catch (e) {
        uploading.value = false;
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    } else {
      uploading.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Please select an image file".tr));
    }*/
  /*
  }*/

  Future<void> deleteUploaded() async {
    if (uuid != null) {
      final done = await _uploadRepository.delete(uuid);
      if (done) {
        uuid = null;
        image = Rx<File>(null);
      }
    }
  }
}

class ImageFieldWidget extends StatelessWidget {
  ImageFieldWidget({
    Key key,
    @required this.label,
    @required this.tag,
    @required this.field,
    this.placeholder,
    this.buttonText,
    @required this.uploadCompleted,
    this.initialImage,
    @required this.reset,
  }) : super(key: key);

  final String label;
  final String placeholder;
  final String buttonText;
  final String tag;
  final String field;
  final Media initialImage;
  final ValueChanged<String> uploadCompleted;
  final ValueChanged<String> reset;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ImageFieldController(), tag: tag);
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 10, left: 20, right: 20),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
          ],
          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 60,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    label,
                    style: Get.textTheme.bodyText1,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  await controller.deleteUploaded();
                  reset(controller.uuid);
                },
                shape: StadiumBorder(),
                color: Get.theme.focusColor.withOpacity(0.1),
                child: Text(buttonText ?? "Reset".tr, style: Get.textTheme.bodyText1),
                elevation: 0,
                hoverElevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
              ),
            ],
          ),
          Obx(() {
            return buildImage(initialImage, controller.image.value);
          })
        ],
      ),
    );
  }

  Widget buildLoader() {
    return Container(
        width: 100,
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image.asset(
            'assets/img/loading.gif',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 100,
          ),
        ));
  }

  Widget buildImage(Media initialImage, File image) {
    final controller = Get.put(ImageFieldController(), tag: tag);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5,
        runSpacing: 8,
        children: [
          if (initialImage != null && image == null)
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                imageUrl: initialImage.thumb ?? '',
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 100,
                ),
                errorWidget: (context, url, error) => Icon(Icons.person,size: 36,),
              ),
            ),
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Image.file(
                image,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
          Obx(() {
            if (controller.uploading.isTrue)
              return buildLoader();
            else
              return GestureDetector(
                onTap: () async {
                  await controller.pickImage(ImageSource.gallery, field, uploadCompleted);
                },
                child: Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Get.theme.focusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.add_photo_alternate_outlined, size: 42, color: Get.theme.focusColor.withOpacity(0.4)),
                ),
              );
          }),
        ],
      ),
    );
  }
}
