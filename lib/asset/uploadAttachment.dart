import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/storage.dart';

String _uid = "";
String _hash = "";

List<String> allowExtension = [
  //允许上传的文件类型
  'flv',
  'mp3',
  'mp4',
  'zip',
  'rar',
  'tar',
  'gz',
  'xz',
  'bz2',
  '7z',
  'apk',
  'ipa',
  'crx',
  'pdf',
  'caj',
  'ppt',
  'pptx',
  'doc',
  'docx',
  'xls',
  'xlsx',
  'txt',
  'png',
  'jpg',
  'jpe',
  'jpeg',
  'gif'
];

void _post_parm(int tid, BuildContext context) async {
  Response response = await XHttp().pureHttpWithCookie(
    url: base_url + "forum.php?mod=viewthread&tid=${tid}",
  );
  String html = response.data.toString();
  if (html.contains("post_params")) {
    String post_param = html
        .split("post_params:")[1]
        .split("file_size_limit")[0]
        .trim()
        .substring(
            0,
            html
                    .split("post_params:")[1]
                    .split("file_size_limit")[0]
                    .trim()
                    .length -
                1);
    _uid = jsonDecode(post_param)["uid"];
    _hash = jsonDecode(post_param)["hash"];
  } else {
    _uid = "";
    _hash = "";
    hideToast();
    showToast(
      context: context,
      type: XSToast.none,
      txt: "你不可在此发送附件",
      duration: 500,
    );
  }
}

///从文件系统中取出图片文件
///此Api仅供MacOS选取图像调用
Future<List<XFile>> pickeImgFile(BuildContext context) async {
  showToast(context: context, type: XSToast.loading);
  List<XFile> files = [];
  FilePickerResult result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: FileType.image,
  );
  for (var file in result.files) {
    files.add(XFile(file.path));
  }
  hideToast();
  return files;
}

///从文件系统中取出【单个】图片文件
///此Api仅供MacOS选取图像调用
Future<XFile> pickeSingleImgFile(BuildContext context) async {
  showToast(context: context, type: XSToast.loading);
  FilePickerResult result = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );
  hideToast();
  return XFile(result.files.first.path);
}

//上传视频
getVideoUploadAid({
  int tid,
  int fid,
  BuildContext context,
  Function onUploadProgress,
}) async {
  showToast(context: context, type: XSToast.loading, txt: "请稍后…");
  await _post_parm(tid, context); //获取上传参数
  if (_uid != "" && _hash != "") {
    final ImagePicker _picker = ImagePicker();
    final XFile video_file =
        await _picker.pickVideo(source: ImageSource.gallery);
    hideToast();
    if ((await video_file.readAsBytes()).lengthInBytes < 40 * 1024 * 1024) {
      if (video_file != null) {
        String fileName = video_file.name;
        String fileType = fileName.split(".")[fileName.split(".").length - 1];
        var formData = FormData.fromMap({
          'uid': _uid.toString(),
          'hash': _hash.toString(),
          'filetype': fileType == "MOV" || fileType == "mov" ? "mp4" : fileType,
          'Filename': fileName,
          'Filedata': await MultipartFile.fromFile(video_file.path,
              filename: fileName +
                  (fileType == "MOV" || fileType == "mov" ? ".mp4" : "")),
        });
        var response = await Dio().post(
          base_url +
              'misc.php?mod=swfupload&action=swfupload&operation=upload&html5=attach&fid=${fid}',
          options: Options(headers: {
            'Cookie': (await getStorage(key: "cookie", initData: "")).toString()
          }),
          onSendProgress: (count, total) {
            onUploadProgress(count / total);
          },
          data: formData,
        );
        return "${response.data}";
      } else {
        return "";
      }
    } else {
      showToast(context: context, type: XSToast.none, txt: "所选文件不能超过40MB");
      return "";
    }
  } else {
    return "";
  }
}

//上传附件
getUploadAid({
  int tid,
  int fid,
  BuildContext context,
  Function onUploadProgress,
}) async {
  showToast(context: context, type: XSToast.loading, txt: "请稍后…");
  await _post_parm(tid, context); //获取上传参数
  if (_uid != "" && _hash != "") {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowExtension,
    );
    hideToast();
    if (result.files.single.size < 40 * 1024 * 1024) {
      if (result != null) {
        String fileName = result.files.single.name;
        String fileType = fileName.split(".")[fileName.split(".").length - 1];
        var formData = FormData.fromMap({
          'uid': _uid.toString(),
          'hash': _hash.toString(),
          'filetype': fileType,
          'Filename': fileName,
          'Filedata': await MultipartFile.fromFile(result.files.single.path,
              filename: fileName),
        });
        var response = await Dio().post(
          base_url +
              'misc.php?mod=swfupload&action=swfupload&operation=upload&html5=attach&fid=${fid}',
          options: Options(headers: {
            'Cookie': (await getStorage(key: "cookie", initData: "")).toString()
          }),
          onSendProgress: (count, total) {
            onUploadProgress(count / total);
          },
          data: formData,
        );
        return "${response.data}";
      } else {
        return "";
      }
    } else {
      showToast(context: context, type: XSToast.none, txt: "所选文件不能超过40MB");
      return "";
    }
  } else {
    return "";
  }
}
