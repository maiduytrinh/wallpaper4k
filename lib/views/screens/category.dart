import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:wallpaper_guru/controller/apiOper.dart';
import 'package:wallpaper_guru/model/photosModel.dart';
import 'package:wallpaper_guru/views/screens/FullScreen.dart';
import 'package:wallpaper_guru/views/widgets/CustomAppBar.dart';

// ignore: must_be_immutable
class CategoryScreen extends StatefulWidget {

  String catName;
  String catImgUrl;
  String type;
  int id;

  CategoryScreen({super.key, required this.catImgUrl, required this.catName, required this.type, required this.id});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  static String uriStorage = "https://www.wallstorage.net/wallstorage/";
  late List<PhotosModel> categoryResults = [];
  bool isLoading  = true;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  ScrollController _scrollController = ScrollController();

  GetCatRelWall() async {
    print("Get Trending Wallpapers page: $currentPage");
    List<PhotosModel> newWallpapers = await ApiOperations.getWallpapersCategory(1, widget.id, widget.type);

    setState(() {
      if (newWallpapers.isEmpty) {
        hasMoreData = false;
      } else {
        categoryResults.addAll(newWallpapers);
      }
      isLoading = false;
      isLoadingMore = false;
    });
  }

  @override
  void initState() {
    GetCatRelWall();
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);  // Xóa bộ lắng nghe khi dispose
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // In vị trí hiện tại của cuộn để kiểm tra
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !isLoadingMore && hasMoreData) {
      print("Reached the end, loading more...");
      setState(() {
        currentPage++;
        isLoadingMore = true;
      });
      GetCatRelWall();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: CustomAppBar(
          word1: "Wallpaper",
          word2: "4K",
        ),
      ),
      body: isLoading  ? const Center(child: CircularProgressIndicator(),)  : SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    widget.catImgUrl),
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black38,
                ),
                Positioned(
                  left: 120,
                  top: 40,
                  child: Column(
                    children: [
                      const Text("Category",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w300)),
                      Text(
                        widget.catName,
                        style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 700,
              child: GridView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 400,
                      crossAxisCount: 2,
                      crossAxisSpacing: 13,
                      mainAxisSpacing: 10),
                  itemCount: categoryResults.length + (isLoadingMore ? 1 : 0),
                  itemBuilder: ((context, index) {
                    if (index == categoryResults.length) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                    }
                    return GridTile(
                        child: InkWell(
                            onTap: () {
                              ApiOperations.logToServerTracking("click", categoryResults[index].id.toString(), 1);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FullScreen(
                                          imgUrl:buildUrlContent(categoryResults[index].url),
                                          imgId: categoryResults[index].id.toString(),
                                        )
                                  )
                              );
                            },
                          child: Hero(
                            tag: buildUrlContent(categoryResults[index].url),
                            child: Container(
                              height: 800,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.amberAccent,
                                  borderRadius: BorderRadius.circular(20)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                    height: 800,
                                    width: 50,
                                    fit: BoxFit.cover,
                                    buildUrlContent(categoryResults[index].url)),
                              ),
                            ),
                          ),
                        ),
                      );
                      })),
            )
          ],
        ),
      ),
    );
  }

  String buildUrlContent(String fileName) {
     return uriStorage + "minthumbnails/" + fileName;
  }
}
