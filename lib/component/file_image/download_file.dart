// ignore_for_file: must_be_immutable, depend_on_referenced_packages
import 'dart:developer';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/iconly.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/menu_icon.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/services/api/api_service.dart';
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
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadFile extends StatefulWidget {
  final Files? file;
  final String? path;
  final String? url;
  Function(Files?)? onUpload;
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
  final String? roleDownload;

  DownloadFile(
      {super.key,
      this.file,
      this.url,
      this.height,
      this.width,
      this.label,
      this.labelsize,
      this.onUpload,
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
      this.fontWeight,
      this.roleDownload});

  @override
  State<DownloadFile> createState() => _DownloadFileState();
}

class _DownloadFileState extends State<DownloadFile> {
  bool _isLoading = false;
  Files? _fileUpload;
  String? filePath;

  @override
  void initState() {
    if (widget.file != null) {
      _fileUpload = widget.file;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          downloadFile();
        },
        icon: const Icon(
          Icons.download_rounded,
          color: Pallete.border,
        ));
    //   return InkWell(
    //       onTap: () {
    //         downloadFile();
    //       },
    //       child: const Icon(
    //         Icons.download_rounded,
    //         color: Pallete.border,
    //       ));
  }

  void downloadFile() {
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
                    'Download File',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  divide16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MenuIcon(
                        isPng: true,
                        title: 'Excel',
                        pngIcon: 'ic_excel.png',
                        onTap: () {
                          Navigator.pop(context);
                          downloadFromServer(fileType: 'excel');
                        },
                      ),
                      // divideW56,
                      MenuIcon(
                        isPng: true,
                        title: 'PDF',
                        pngIcon: 'ic_pdf.png',
                        onTap: () {
                          Navigator.pop(context);
                          downloadFromServer(fileType: 'pdf');
                        },
                      ),
                    ],
                  ),
                ],
              ));
        });
  }

  // Fungsi untuk mendownload file
  Future<void> downloadFromServer({required String fileType}) async {
    String fileName = '';
    Map<String, dynamic> params = {};
    params['role_user'] = widget.roleDownload;
    // String url = '';

    // Tentukan URL dan nama file berdasarkan tipe file
    if (fileType == 'excel') {
      // url = 'http://your-server-ip:3000/download/excel';
      fileName = 'laporan absensi ${widget.roleDownload}.xlsx';
    } else if (fileType == 'pdf') {
      // url = 'http://your-server-ip:3000/download/pdf';
      fileName = 'laporan absensi ${widget.roleDownload}.pdf';
    }

    // Minta izin akses penyimpanan
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final dir = await getExternalStorageDirectory();
      // var dir = await getApplicationDocumentsDirectory();
      String savePath = '${dir!.path}/$fileName';
      BatchApi api = BatchApi();
      int progress = 0;
      try {
        log('path: $savePath');
        Response response = await api.downloadFile(
          fileType: fileType,
          params: params,
          path: savePath,
          progressDownload: (received, total) {
            if (total != -1) {
              setState(() {
                progress = (received / total * 100).toInt();
              });

              // Tampilkan Snackbar dengan progress bar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Expanded(
                        child: Text('Downloading $fileName: $progress%'),
                      ),
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          value: progress / 100,
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  duration: const Duration(milliseconds: 500),
                ),
              );
            }
          },
        );

        setState(() {
          filePath = savePath;
        });

        // Menampilkan pesan sukses saat unduhan selesai
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Pallete.primary2,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Download Selesai: $fileName",
                    style: const TextStyle(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                divideW8,
                GestureDetector(
                    onTap: () {
                      openFile();
                    },
                    child: const Text(
                      'Buka',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Pallete.border),
                    )),
              ],
            ),
            duration: const Duration(seconds: 10),
          ),
        );

        print("File downloaded to $savePath");

        log('response: ${response.toString()}');
        log(response.statusCode.toString());

        // if (response.statusCode == 200) {
        //   ResponseData responseData = ResponseData.fromJson(response.data);
        //   setState(() {
        //     if (widget.isMultipleFile == false) {
        //       _fileUpload = UploadFile.fromJson(responseData.data).files;
        //       // widget.onUpload(_fileUpload);
        //     }
        //   });
        //   log('Download selesai. File disimpan di $savePath');
        // }
      } catch (error) {
        log(error.toString());
        if (ApiService.connectionInternet == 'Disconnect') {
          showToastError('Tidak Ada Koneksi Internet');
        } else {
          showToastError(error.toString());
        }
        setState(() {
          _isLoading = false;
        });
      }

      // try {
      //   await dio.download(url, savePath, onReceiveProgress: (rec, total) {
      //     print('Rec: $rec , Total: $total');
      //   });
      //   print('Download selesai. File disimpan di $savePath');
      // } catch (e) {
      //   print(e.toString());
      // }
    } else {
      print('Izin akses penyimpanan ditolak');
    }
  }

  // Membuka file dengan aplikasi yang sesuai (untuk PDF dan Excel)
  Future<void> openFile() async {
    if (filePath != null) {
      OpenFilex.open(filePath!);
    } else {
      print("No file to open");
    }
  }

  // void downloadFromServer(File? file) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   BatchApi api = BatchApi();
  //   Map<String, dynamic> body = {};

  //   body['file'] = await MultipartFile.fromFile(file!.path,
  //       contentType: MediaType('image', 'jpeg'));
  //   log('body: $body');
  //   try {
  //     Response response = await api.postSaveFile(body: body);
  //     log('response: ${response.toString()}');
  //     log(response.statusCode.toString());
  //     if (response.statusCode == 200) {
  //       ResponseData responseData = ResponseData.fromJson(response.data);
  //       setState(() {
  //         if (widget.isMultipleFile == false) {
  //           _fileUpload = UploadFile.fromJson(responseData.data).files;
  //           widget.onUpload(_fileUpload);
  //         }
  //       });
  //     }
  //   } catch (error) {
  //     log(error.toString());
  //     showToastError(error.toString());
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }
}
