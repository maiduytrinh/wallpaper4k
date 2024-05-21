import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wallpaper_guru/model/categoryModel.dart';
import 'package:wallpaper_guru/model/photosModel.dart';

class ApiOperations {
  static List<PhotosModel> trendingWallpapers = [];
  static List<PhotosModel> searchWallpapersList = [];
  static List<CategoryModel> cateogryModelList = [];

  static const String _apiKey = "563492ad6f91700001000001647b18af76064a2290c59e8b19a9c3d7";
  static String uri = 'http://10.0.2.2:4444/wallpaper/api/';
  static String language= 'vi';
  static String country= 'VN';

  static Future<List<PhotosModel>> getWallpapersHomepage(int page) async {
    var headers = {'language': language, 'country': country};

    await http.get(Uri.parse(uri + "/data?pagenumber=" + page.toString()), headers: headers).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData['data']['wallpapers'];
      for (var element in photos) {
        trendingWallpapers.add(PhotosModel.fromAPI2App(element));
      }
    });

    return trendingWallpapers;
  }


  static Future<List<PhotosModel>> searchWallpapers(String query) async {
    await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$query&per_page=30&page=1"),
        headers: {"Authorization": _apiKey}).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData['photos'];
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
}
