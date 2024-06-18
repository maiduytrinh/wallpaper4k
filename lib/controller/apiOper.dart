import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wallpaper_guru/model/categoryModel.dart';
import 'package:wallpaper_guru/model/photosModel.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ApiOperations {
  static List<PhotosModel> trendingWallpapers = [];
  static List<PhotosModel> searchWallpapersList = [];
  static List<CategoryModel> cateogryModelList = [];

  static const String _apiKey = "563492ad6f91700001000001647b18af76064a2290c59e8b19a9c3d7";
  static String uri = 'http://10.0.2.2:4444/wallpaper/api/';
  static String uri_tracking = 'http://10.0.2.2:8888/wallpaper/api/';
  static String language= 'vi';
  static String country= 'VN';
  static String? deviceId = '';

  static Future<List<PhotosModel>> getWallpapersHomepage(int page) async {
    var headers = {'language': language, 'country': country};

    await http.get(Uri.parse(uri + "/data?pagenumber=" + page.toString()), headers: headers).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData['data']['wallpapers'];
      trendingWallpapers.clear();
      for (var element in photos) {
        trendingWallpapers.add(PhotosModel.fromAPI2App(element));
      }
    });

    return trendingWallpapers;
  }

   static Future<List<PhotosModel>> getWallpapersCategory(int page, int cateId, String type) async {
    var headers = {'language': language, 'country': country};

    await http.get(Uri.parse(uri + "/data/category?pagenumber="+page.toString()+"&category="+cateId.toString()+"&type="+type), headers: headers).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData['data']['wallpapers'];
      searchWallpapersList.clear();
      for (var element in photos) {
        searchWallpapersList.add(PhotosModel.fromAPI2App(element));
      }
    });

    return searchWallpapersList;
  }


  static Future<List<PhotosModel>> searchWallpapers(int page, String query) async {
    var headers = {'language': language, 'country': country};
    await http.get(
        Uri.parse(uri + "/search/hashtag?pagenumber=" + page.toString() + "&hashtags=" + query),
        headers: headers).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData['data']['wallpapers'];
      searchWallpapersList.clear();
      for (var element in photos) {
        searchWallpapersList.add(PhotosModel.fromAPI2App(element));
      }
    });

    return searchWallpapersList;
  }

  static Future<List<CategoryModel>> getCategoriesList() async{
    var headers = {'language': language, 'country': country};

    await http.get(Uri.parse(uri + "/category"), headers: headers).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List categories = jsonData['data'];
      for (var element in categories) {
        cateogryModelList.add(CategoryModel.fromAPI2App(element));
      }
    });

    return cateogryModelList;
  }

  static Future<void> logToServerTracking(String eventType, String contentId, int contentType) async{
    Map<String, dynamic> body = {
      "deviceId": deviceId,
      "eventType": eventType,
      "contentId": contentId,
      "contentType": 1,
      "country": country
    }; 
    print(body);
    await http.post(Uri.parse(uri_tracking + "tracking"), body: jsonEncode(body)).then((value) {
    });
  }

  static Future<void> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    var androidDeviceInfo = await deviceInfo.androidInfo;
    deviceId = androidDeviceInfo.androidId;
  }
}
