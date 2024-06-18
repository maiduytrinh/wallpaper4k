import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:wallpaper_guru/controller/apiOper.dart';

// var file = await DefaultCacheManager().getSingleFile(url);
class FullScreen extends StatelessWidget {
  final String imgUrl;
  final String imgId;
  FullScreen({super.key, required this.imgUrl, required this.imgId});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<String?> setWallpaperFromFile(
    String wallpaperUrl, BuildContext context) async {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(wallpaperUrl);
      if (imageId == null) {
        return null;
      }
      // Below is a method of obtaining saved image information.
      // var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      // var size = await ImageDownloader.findByteSize(imageId);
      // var mimeType = await ImageDownloader.findMimeType(imageId);
      
      print("IMAGE DOWNLOADED");
      return path;
    } on PlatformException catch (error) {
      print(error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error Occured - $error")));
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: ElevatedButton(
          onPressed: () async {
            String? path = await setWallpaperFromFile(imgUrl, context);
            // Hiển thị AlertDialog
            if (path == null) {
              ScaffoldMessenger.of(context)
                 .showSnackBar(SnackBar(content: Text("Error DOWNLOAD IMAGE")));
            } else {
              // log tracking download image
              ApiOperations.logToServerTracking("down", imgId, 1);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Set Wallpaper"),
                    content: Text("Choose where to set the wallpaper:"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          // Đặt hình nền cho màn hình chính
                          await WallpaperManager.setWallpaperFromFile(
                            path!, // Đường dẫn đến hình ảnh đã tải xuống
                            WallpaperManager.HOME_SCREEN,
                          );
                          Navigator.of(context).pop(); // Đóng AlertDialog
                        },
                        child: Text("Set home screen"),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Đặt hình nền cho màn hình khóa
                          await WallpaperManager.setWallpaperFromFile(
                            path!,
                            WallpaperManager.LOCK_SCREEN,
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text("Set lock screen"),
                      ),
                      TextButton(
                        onPressed: () async {
                
                          // Đặt hình nền cho màn hình khóa và màn hình chính
                          await WallpaperManager.setWallpaperFromFile(
                            path!, // Đường dẫn đến hình ảnh đã tải xuống
                            WallpaperManager.HOME_SCREEN,
                          );
                          await WallpaperManager.setWallpaperFromFile(
                            path!,
                            WallpaperManager.LOCK_SCREEN,
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text("Set lock & home screen"),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: const Text("Set Wallpaper")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(imgUrl), fit: BoxFit.cover)),
      ),
    );
  }
}
