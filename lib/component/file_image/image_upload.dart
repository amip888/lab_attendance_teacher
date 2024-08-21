// ignore_for_file: must_be_immutable, depend_on_referenced_packages
import 'dart:developer';
import 'dart:io';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/iconly.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/menu_icon.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/services/api/batch_api.dart';
import 'package:lab_attendance_mobile_teacher/services/response_data/response_data.dart';
import 'package:lab_attendance_mobile_teacher/services/upload_file/files.dart';
import 'package:lab_attendance_mobile_teacher/services/upload_file/upload_file.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  final Files? file;
  final String? path;
  final String? url;
  Function(Files?) onUpload;
  Function(List<Files>?)? onMultipleUpload;
  final double? height;
  final double? width;
  final String? label;
  final String? description;
  final double? labelsize;
  final FontWeight? fontWeight;
  final double aspectRatio;
  final ImageSource? imageSource;
  final CropAspectRatioPreset? fixedCropRatio;
  final bool? isEdit;
  final bool? imageOnlyMode;
  final bool? isCircle;
  final bool? isMultipleFile;

  ImageUpload(
      {super.key,
      this.file,
      this.url,
      this.height,
      this.width,
      this.label,
      this.labelsize,
      required this.onUpload,
      this.onMultipleUpload,
      this.aspectRatio = 1 / 1,
      this.imageSource,
      this.fixedCropRatio,
      this.isEdit = false,
      this.description,
      this.isCircle = false,
      this.imageOnlyMode = false,
      this.isMultipleFile = false,
      this.path,
      this.fontWeight});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  bool _isLoading = false;
  Files? _fileUpload;

  @override
  void initState() {
    if (widget.file != null) {
      _fileUpload = widget.file;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('==$_fileUpload');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.imageOnlyMode!)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label!,
                style: TextStyle(
                  fontSize: widget.labelsize ?? 14,
                  fontWeight: widget.fontWeight ?? FontWeight.w500,
                ),
              ),
              if (widget.description != null) divide2,
              if (widget.description != null)
                Text(
                  widget.description ?? '',
                  style: TextStyle(fontSize: widget.labelsize ?? 12),
                ),
              divide8,
            ],
          ),
        InkWell(
          onTap: () {
            if (widget.imageSource == null) {
              editPicture();
            } else {
              uploadImage(widget.imageSource!);
            }
          },
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Pallete.disabled,
                borderRadius: BorderRadius.circular(
                    widget.isCircle == true ? 10000 : 16)),
            height: widget.height,
            width: widget.width,
            child: AspectRatio(
              aspectRatio: widget.aspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _fileUpload != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                              widget.isCircle == true ? 10000 : 16),
                          child: NetworkImagePlaceHolder(
                              imageUrl: _fileUpload!.filename))
                      : widget.isEdit == true
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  widget.isCircle == true ? 10000 : 16),
                              child:
                                  NetworkImagePlaceHolder(imageUrl: widget.url))
                          : const Icon(
                              Iconly.imageBold,
                              color: Pallete.textPlaceholder,
                              size: 75,
                            ),
                  _isLoading ? loading(color: Pallete.primary) : Container(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void uploadImage(ImageSource source) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile =
        await picker.pickImage(source: source, imageQuality: 50);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile!.path,
        compressQuality: 50,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Sesuaikan Foto',
            toolbarColor: Colors.white,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
              // CropAspectRatioPresetCustom(),
            ],
          ),
          IOSUiSettings(
            title: 'Sesuaikan Foto',
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
              // CropAspectRatioPresetCustom(), // IMPORTANT: iOS supports only one custom aspect ratio in preset list
            ],
          ),
        ]);
    setState(() {
      var filePath = File(croppedFile!.path);
      log('--$filePath');
      uploadToServer(filePath);
    });
  }

  void uploadToServer(File? file) async {
    setState(() {
      _isLoading = true;
    });
    BatchApi api = BatchApi();
    Map<String, dynamic> body = {};

    body['file'] = await MultipartFile.fromFile(file!.path,
        contentType: MediaType('image', 'jpeg'));
    log('body: $body');
    try {
      Response response = await api.postSaveFile(body: body);
      log('response: ${response.toString()}');
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        ResponseData responseData = ResponseData.fromJson(response.data);
        setState(() {
          if (widget.isMultipleFile == false) {
            _fileUpload = UploadFile.fromJson(responseData.data).files;
            widget.onUpload(_fileUpload);
          }
        });
      }
    } catch (error) {
      log(error.toString());
      showToastError(error.toString());
      setState(() {
        _isLoading = false;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void editPicture() {
    showModalBottomSheet(
        context: context,
        shape: modalShape(),
        builder: (BuildContext context) {
          return Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Unggah Gambar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  divide16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MenuIcon(
                        isSvg: true,
                        title: 'Camera',
                        svgIcon: 'ic_image_camera.svg',
                        onTap: () {
                          Navigator.pop(context);
                          uploadImage(ImageSource.camera);
                        },
                      ),
                      divideW56,
                      MenuIcon(
                        isSvg: true,
                        title: 'Galeri',
                        svgIcon: 'ic_image_galery.svg',
                        onTap: () {
                          Navigator.pop(context);
                          uploadImage(ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                ],
              ));
        });
  }
}
