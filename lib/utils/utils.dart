import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:movie/const/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:movie/main.dart';

class Utils {
  static showFailureToast(message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.grey[700],
      textColor: Colors.white,
    );
  }

  static showSuccessToast(message) async {
    await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.grey[700],
      textColor: Colors.white,
    );
  }

  static showSnackBar(String message, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'X',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future<dynamic>? downloadFilesToShareChannel(
    dynamic post, {
    ShareType shareType = ShareType.Story,
    SocialMedia? socialMedia,
    MediaType? mediaType,
  }) async {
    List<String> mediaUrls = [];

    /// If MediaType is Image
    if (mediaType == MediaType.Image) {
      // /// For snapchat we are not copying to clipboard
      // if (socialMedia != SocialMedia.Snapchat) {
      //   copyMessageClipboard(message: post.message);
      // }

      for (int i = 0; i < (post.images?.length ?? 0); i++) {
        if ((post.images?.length ?? 0) > 0) {
          /// Save Images in Gallery
          try {
            await GallerySaver.saveImage(post.images![i]);
          } catch (exe) {
            if (kDebugMode) {
              print(exe);
            }
          }
        }
        var response = await http.get(Uri.parse(post.images![i]));
        var documentDirectory = await getTemporaryDirectory();
        if (await Permission.storage.request().isGranted) {
          if (kDebugMode) {
            print("MANAGE_EXTERNAL_STORAGE Granted");
          }
        } else {
          if (kDebugMode) {
            print("MANAGE_EXTERNAL_STORAGE Not Granted");
          }
        }
        var firstPath = documentDirectory.path + "/images";

        String fileName = post.images![i].split('/').last;
        var filePathAndName = documentDirectory.path + '/' + fileName;

        /// Check if the file exist or not otherwise download the file
        if (await File(filePathAndName).exists()) {
          if (socialMedia == SocialMedia.Snapchat ||
              socialMedia == SocialMedia.WhatsApp ||
              socialMedia == SocialMedia.Tiktok) {
            mediaUrls.add(filePathAndName);
          } else {
            mediaUrls.add(fileName);
          }
        } else {
          try {
            await Directory(firstPath).create(recursive: true);
            File file2 = await File(filePathAndName).create();
            file2.writeAsBytesSync(response.bodyBytes.buffer.asUint8List());

            /// Social Media is Snapchat and Tiktok we will sent the filePathAndName
            /// otherwise fileName
            if (socialMedia == SocialMedia.Snapchat ||
                socialMedia == SocialMedia.WhatsApp ||
                socialMedia == SocialMedia.Tiktok) {
              mediaUrls.add(filePathAndName);
            } else {
              mediaUrls.add(fileName);
            }
          } catch (exe) {}
        }
      }
    }
  }

  static void copyMessageClipboard({String? message}) async {
    if (message != null) {
      Clipboard.setData(ClipboardData(text: message));
    }
    await Utils.showSuccessToast(
        "Your message is added to clipboard, Long press to paste it");
  }

  static MediaType? checkMediaType(post) {
    MediaType? _mediaType;
    if (post.images?.isEmpty ?? true) {
      /// For video related post
      if (post.video?.url?.isNotEmpty ?? false) {
        _mediaType = MediaType.Video;
        return _mediaType;
      }
    } else {
      /// For GIF related post
      if (post.images!.length == 1 && post.images![0].endsWith('gif')) {
        _mediaType = MediaType.Gif;
        return _mediaType;
      } else {
        _mediaType = MediaType.Image;
        return _mediaType;
      }
    }
    return _mediaType;
  }

  static Future<String?> downloadVideoGIFFile(
      String mediaUrl, MediaType? mediaType, SocialMedia? socialMedia) async {
    try {
      if (mediaType == MediaType.Video) {
        await GallerySaver.saveVideo(mediaUrl).then((value) => print(value));
        return mediaUrl.split('/').last;
      } else if (mediaType == MediaType.Gif) {
        if (socialMedia == SocialMedia.Instagram) {
          mediaUrl = await Utils.convertGIFToVideoFile(mediaUrl) ?? "";
          return mediaUrl.split('/').last;
        }
        await GallerySaver.saveVideo(mediaUrl).then((bool? success) {});
        return mediaUrl.split('/').last;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return '';
    }
    return null;
  }

  static Future<String?>? downloadVideoFile(String videoUrl) async {
    try {
      if (await Permission.storage.request().isGranted) {
        if (kDebugMode) {
          print("MANAGE_EXTERNAL_STORAGE Granted");
        }
      } else {
        if (kDebugMode) {
          print("MANAGE_EXTERNAL_STORAGE Not Granted");
        }
      }
      var documentDirectory = await getTemporaryDirectory();
      String fileName = videoUrl.split('/').last;
      var filePathAndName = documentDirectory.path + '/' + fileName;

      await Dio().download(videoUrl, filePathAndName,
          onReceiveProgress: (received, total) {
        // if (total != -1) {
        print((received / total * 100).toStringAsFixed(0) + "%");
        // }
      });

      return filePathAndName;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  static Future<String?>? convertVideoFromHorizontalToVertical(
      String videoLocalUrl) async {
    try {
      var tempDirectory = await getTemporaryDirectory();
      String newName = DateTime.now().microsecondsSinceEpoch.toString();
      var newPathAndName = tempDirectory.path + '/' + newName + ".mp4";
      File file = File(newPathAndName);

      await FFmpegKit.execute(
              "-i $videoLocalUrl -lavfi [0:v]scale=1920*2:1080*2,boxblur=luma_radius=min(h\,w)/20:luma_power=1:chroma_radius=min(cw\,ch)/20:chroma_power=1[bg];[0:v]scale=-1:1080[ov];[bg][ov]overlay=(W-w)/2:(H-h)/2,crop=w=1920:h=1080 ${file.path}")
          .then((session) async {
        final returnCode = await session.getReturnCode();
        print(await session.getAllLogsAsString());
        final output = await session.getOutput();
        print("Outputs" + output!);

        // The list of logs generated for this execution
        final logs = await session.getLogs();
        print("Logs" + logs.first.toString());

        // The list of statistics generated for this execution (only available on FFmpegSession)
        final statistics = await (session).getStatistics();
        print("Statistics" + statistics.toString());
        if (ReturnCode.isSuccess(returnCode)) {
          // SUCCESS

        } else if (ReturnCode.isCancel(returnCode)) {
          // CANCEL

        } else {}
      });

      return newPathAndName;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  static Future<void> showToastMessageDialog(String message) async {
    await showDialog(
      context: MovieApp.globalContext,
      builder: (context) {
        return AlertDialog(
          content: Text(message,
              style: Theme.of(MovieApp.globalContext)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.w600)),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () async => Navigator.pop(context),
            )
          ],
        );
      },
    );
    return;
  }

  /// Converting Gif2Video
  static Future<String?>? convertGIFToVideoFile(String videoUrl) async {
    try {
//path of the gif file.
      // final String outputFile = videoUrl.replaceRange(videoUrl.length - 3,
      //     videoUrl.length, "mp4"); //path to export the mp4 file.

      /// Download GIF
      var tempDirectory = await getTemporaryDirectory();
      String newName = DateTime.now().microsecondsSinceEpoch.toString();
      var filePathAndName = tempDirectory.path + '/' + newName + ".mp4";

      await Dio().download(videoUrl, filePathAndName,
          onReceiveProgress: (received, total) {});

      //  Convert GIF to video
      var newPathAndName = tempDirectory.path +
          '/' +
          DateTime.now().microsecondsSinceEpoch.toString() +
          ".mp4";
      await FFmpegKit.execute("-f gif -i $filePathAndName $newPathAndName")
          .whenComplete(() => print("Gif converted to video"));

      return newPathAndName;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  static Future<String?>? downloadImageFile(String imageUrl,
      {String? path}) async {
    try {
      if (await Permission.storage.request().isGranted) {
        if (kDebugMode) {
          print("MANAGE_EXTERNAL_STORAGE Granted");
        }
      } else {
        if (kDebugMode) {
          print("MANAGE_EXTERNAL_STORAGE Not Granted");
        }
      }
      var documentDirectory = await getTemporaryDirectory();
      String fileName = imageUrl.split('/').last;
      String? filePathAndName;
      if (path != null) {
        filePathAndName = path;
      } else {
        filePathAndName = documentDirectory.path + '/' + fileName;
      }

      await Dio().download(imageUrl, filePathAndName,
          onReceiveProgress: (received, total) {
        // if (total != -1) {
        //   print((received / total * 100).toStringAsFixed(0) + "%");
        // }
      });

      return filePathAndName;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  static Future<File?> downloadPDFFile(String url) async {
    try {
      Response response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      print(response.headers);
      if (await Permission.storage.request().isGranted) {
        if (kDebugMode) {
          print("MANAGE_EXTERNAL_STORAGE Granted");
        }
      } else {
        if (kDebugMode) {
          print("MANAGE_EXTERNAL_STORAGE Not Granted");
        }
      }
      String? storagePath;
      if (Platform.isIOS) {
        storagePath = (await getApplicationDocumentsDirectory()).path;
      } else {
        storagePath = (await getExternalStorageDirectory())!.path;
      }
      print(storagePath + "/" + url.split("/").last);
      File file = File(storagePath + "/" + url.split("/").last);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<String?>? downloadPdfFile(String pdfUrl) async {
    try {
      if (await Permission.storage.request().isGranted) {
        if (kDebugMode) {
          print("MANAGE_EXTERNAL_STORAGE Granted");
        }
      } else {
        if (kDebugMode) {
          print("MANAGE_EXTERNAL_STORAGE Not Granted");
        }
      }
      String directoryPath;
      if (Platform.isIOS) {
        directoryPath = (await getApplicationDocumentsDirectory()).path;
      } else {
        directoryPath = (await getExternalStorageDirectory())!.path;
      }
      String fileName = pdfUrl.split('/').last;
      String? filePathAndName;
      filePathAndName = directoryPath + "/" + fileName;
      print(filePathAndName);

      // Uint8List data = Uint8List.fromList(pdfUrl.data);
      // await FileSaver.instance
      //     .saveFile(pdfUrl, Uint8List, pdfUrl.split(".").last);
      await Dio().download(pdfUrl, filePathAndName,
          onReceiveProgress: (received, total) {
        // if (total != -1) {
        //   print((received / total * 100).toStringAsFixed(0) + "%");
        // }
      }).whenComplete(() => print("Files downloaded"));

      return filePathAndName;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  static String? getAssetImage(String? name) {
    String? assetImage;
    if (name == "facebook") {
      assetImage = facebookImage;
    } else if (name == "instagram") {
      assetImage = instagramImage;
    } else if (name == "snapchat") {
      assetImage = snapchatImage;
    } else if (name == "tikTok") {
      assetImage = tiktokImage;
    } else if (name == "alexaDevice") {
      assetImage = alexaImage;
    } else if (name == "linkedin") {
      assetImage = linkedImage;
    } else if (name == "googleMB") {
      assetImage = googleMyBusiness;
    } else if (name == "twitter") {
      assetImage = twitterImage;
    } else if (name == "medium") {
      assetImage = mediumImage;
    } else if (name == "wordpress") {
      assetImage = wordpressImage;
    } else if (name == "library") {
      assetImage = libraryImage;
    }

    return assetImage;
  }

  static List<String?> extractHashtags(String text) {
    Iterable<Match> matches = RegExp(r"\B(\#[a-zA-Z]+\b)").allMatches(text);
    return matches.map((m) => m[0]).toList();
  }

  // static Future<String?> mergeIntoVideo(List<String> imagePath) async {
  //   dynamic limit = 10;

  //   String savedFilePath = "";

  //   if (Platform.isAndroid) {
  //     savedFilePath = (await getTemporaryDirectory()).path;
  //   } else {
  //     savedFilePath = (await getLibraryDirectory()).path;
  //   }
  //   //  Convert GIF to video
  //   savedFilePath = '${savedFilePath}/out.mp4';

  //   final MediaInformationSession mediaInformation =
  //       await FFprobeKit.getMediaInformation(imagePath.first.toString());
  //   final MediaInformation? mp = mediaInformation.getMediaInformation();

  //   var documentDirectory = await getTemporaryDirectory();

  //   String filePathAndName = (documentDirectory.path ?? "") + '/' + "*.jpg";

  //   try {
  //     await FFmpegKit.execute(
  //             "-i ${filePathAndName} -c:v libx264 -pix_fmt yuv420p ${savedFilePath}")
  //         .then((result) {
  //       return File(savedFilePath).path;
  //     }, onError: (error) {
  //       print("Error" + error);
  //     }).whenComplete(() => print("Gif converted to video"));

  //     return File(savedFilePath).path;

  //     /// To combine audio with video
  //   } catch (exe) {
  //     return null;
  //   }
  // }

  static SocialMedia? getSocialMedia(String? name) {
    SocialMedia? socialMediaName;
    if (name == "facebook") {
      socialMediaName = SocialMedia.Facebook;
    } else if (name == "instagram") {
      socialMediaName = SocialMedia.Instagram;
    } else if (name == "snapchat") {
      socialMediaName = SocialMedia.Snapchat;
    } else if (name == "tikTok") {
      socialMediaName = SocialMedia.Tiktok;
    } else if (name == "alexaDevice") {
      socialMediaName = SocialMedia.AlexaDevice;
    } else if (name == "linkedin") {
      socialMediaName = SocialMedia.LinkedIn;
    } else if (name == "googleMB") {
      socialMediaName = SocialMedia.GoogleMB;
    } else if (name == "twitter") {
      socialMediaName = SocialMedia.Twitter;
    }
    return socialMediaName;
  }

  static bool validateLink(String message) {
    RegExp exp =
        RegExp(r'(?:(?:https?|ftp|www):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(message);
    if (matches.isNotEmpty) {
      return true;
    }
    return false;
  }

  // static MediaType? getMediaType(String imagePath) {
  //   if (imagePath.isNotEmpty && imagePath.length > 4) {
  //     String extension =
  //         imagePath.substring(imagePath.length - 4, imagePath.length);
  //     if (extension.contains("jpeg") ||
  //         extension.contains("jpg") ||
  //         extension.contains("png")) {
  //       return MediaType.Image;
  //     } else if (extension.contains("gif")) {
  //       return MediaType.Gif;
  //     } else if (extension.contains("webp") || extension.contains("mp4")) {
  //       return MediaType.Video;
  //     } else {
  //       return null;
  //     }
  //   }
  // }

  // static SocialMedia? getSocialMedia(String imagePath) {
  //   if (imagePath.isNotEmpty && imagePath.length > 4) {
  //     String extension =
  //         imagePath.substring(imagePath.length - 4, imagePath.length);
  //     if (extension.contains("jpeg") ||
  //         extension.contains("jpg") ||
  //         extension.contains("png")) {
  //       return MediaType.Image;
  //     } else if (extension.contains("gif")) {
  //       return MediaType.Gif;
  //     } else if (extension.contains("webp") || extension.contains("mp4")) {
  //       return MediaType.Video;
  //     } else {
  //       return null;
  //     }
  //   }
  // }

  // static bool? postValidationError(
  //     Map<String, dynamic> params, List<Accounts>? accounts) {
  //  Map<String, dynamic> _params = {
  //   "message": message ?? "",
  //   "images": pickedImages,
  //   "video": videoURL ?? {},
  //   "callToAction": callToAction,
  //   "draft": saveDraft,
  //   "postedDate": _postedDate,
  //   "accountIds": _accountInitial.map((ele) => ele.sId).toList(),
  //   "categories": _categoryInitial,
  //   "accountMetaData": _accountsMetadata,
  // };

  // if (post != null) {
  //   _params['sId'] = post.sId;
  // }

  // if (_postGroupValue == "schedule" && _postedDate != null) {
  //   _params["postedDate"] = _postedDate;
  // }

  // if (addComplianceRule) {
  //   _params['complianceEngineRules'] = {"ignoreComplianceCheck": true};
  // }

  // if(params["accountIds"])

  //   return false;
  // }
}

/// a custom controller based on [TextEditingController] used to activly style input text based on regex patterns and word matching
/// with some custom features.
/// {@tool snippet}
///
/// ```dart
/// class _ExampleState extends State<Example> {
///
///   late RichTextController _controller;
///
/// _controller = RichTextController(
///       deleteOnBack: true,
///       patternMatchMap: {
///         //Returns every Hashtag with red color
///         RegExp(r"\B#[a-zA-Z0-9]+\b"):
///             const TextStyle(color: Colors.red, fontSize: 22.0),
///         //Returns every Mention with blue color and bold style.
///         RegExp(r"\B@[a-zA-Z0-9]+\b"): const TextStyle(
///           fontWeight: FontWeight.w800,
///           color: Colors.blue,
///         ),
///
///  TextFormField(
///  controller: _controller,
///  ...
/// )
///
/// ```
/// {@end-tool}
class RichTextController extends TextEditingController {
  final Map<RegExp, TextStyle>? patternMatchMap;
  final Map<String, TextStyle>? stringMatchMap;
  final Function(List<String> match) onMatch;
  final bool? deleteOnBack;
  String _lastValue = "";

  bool isBack(String current, String last) {
    return current.length < last.length;
  }

  RichTextController({
    String? text,
    this.patternMatchMap,
    this.stringMatchMap,
    required this.onMatch,
    this.deleteOnBack = false,
  })  : assert((patternMatchMap != null && stringMatchMap == null) ||
            (patternMatchMap == null && stringMatchMap != null)),
        super(text: text);

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    List<TextSpan> children = [];
    List<String> matches = [];

    // Validating with REGEX
    RegExp? allRegex;
    allRegex = patternMatchMap != null
        ? RegExp(patternMatchMap?.keys.map((e) => e.pattern).join('|') ?? "")
        : null;
    // Validating with Strings
    RegExp? stringRegex;
    stringRegex = stringMatchMap != null
        ? RegExp(r'\b' + stringMatchMap!.keys.join('|').toString() + r'+\b')
        : null;
    if (allRegex != null) {
      text.splitMapJoin(
        allRegex,
        onNonMatch: (String span) {
          children.add(TextSpan(text: span, style: style));
          return span.toString();
        },
        onMatch: (Match m) {
          if (!matches.contains(m[0])) matches.add(m[0]!);
          final RegExp? k = patternMatchMap?.entries.firstWhere((element) {
            return element.key.allMatches(m[0]!).isNotEmpty;
          }).key;
          final String? ks = stringMatchMap?.entries.firstWhere((element) {
            return element.key.allMatches(m[0]!).isNotEmpty;
          }).key;
          if (deleteOnBack!) {
            if ((isBack(text, _lastValue) && m.end == selection.baseOffset)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                children.removeWhere((element) => element.text! == text);
                text = text.replaceRange(m.start, m.end, "");
                selection = selection.copyWith(
                  baseOffset: m.end - (m.end - m.start),
                  extentOffset: m.end - (m.end - m.start),
                );
              });
            } else {
              children.add(
                TextSpan(
                  text: m[0],
                  style: stringMatchMap == null
                      ? patternMatchMap![k]
                      : stringMatchMap![ks],
                ),
              );
            }
          } else {
            children.add(
              TextSpan(
                text: m[0],
                style: stringMatchMap == null
                    ? patternMatchMap![k]
                    : stringMatchMap![ks],
              ),
            );
          }

          return (onMatch(matches) ?? '');
        },
      );
    }

    if (stringRegex != null) {
      text.splitMapJoin(
        stringRegex,
        onNonMatch: (String span) {
          children.add(TextSpan(text: span, style: style));
          return span.toString();
        },
        onMatch: (Match m) {
          if (!matches.contains(m[0])) matches.add(m[0]!);
          final RegExp? k = patternMatchMap?.entries.firstWhere((element) {
            return element.key.allMatches(m[0]!).isNotEmpty;
          }).key;
          final String? ks = stringMatchMap?.entries.firstWhere((element) {
            return element.key.allMatches(m[0]!).isNotEmpty;
          }).key;
          if (deleteOnBack!) {
            if ((isBack(text, _lastValue) && m.end == selection.baseOffset)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                children.removeWhere((element) => element.text! == text);
                text = text.replaceRange(m.start, m.end, "");
                selection = selection.copyWith(
                  baseOffset: m.end - (m.end - m.start),
                  extentOffset: m.end - (m.end - m.start),
                );
              });
            } else {
              children.add(
                TextSpan(
                  text: m[0],
                  style: stringMatchMap == null
                      ? patternMatchMap![k]
                      : stringMatchMap![ks],
                ),
              );
            }
          } else {
            children.add(
              TextSpan(
                text: m[0],
                style: stringMatchMap == null
                    ? patternMatchMap![k]
                    : stringMatchMap![ks],
              ),
            );
          }

          return (onMatch(matches) ?? '');
        },
      );
    }

    _lastValue = text;
    return TextSpan(style: style, children: children);
  }
}
