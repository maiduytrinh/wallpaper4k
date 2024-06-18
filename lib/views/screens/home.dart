import 'package:flutter/material.dart' hide SearchBar;
import 'package:wallpaper_guru/controller/apiOper.dart';
import 'package:wallpaper_guru/model/categoryModel.dart';
import 'package:wallpaper_guru/model/photosModel.dart';
import 'package:wallpaper_guru/views/screens/FullScreen.dart';
import 'package:wallpaper_guru/views/widgets/CustomAppBar.dart';
import 'package:wallpaper_guru/views/widgets/SearchBar.dart';
import 'package:wallpaper_guru/views/widgets/catBlock.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<PhotosModel> trendingWallList = [];
  late List<CategoryModel> CatModList = [];
  static String uriStorage = "https://www.wallstorage.net/wallstorage/";
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ApiOperations.getDeviceId();
    GetCatDetails();
    GetTrendingWallpapers();
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
      GetTrendingWallpapers();
    }
  }

  GetCatDetails() async {
    CatModList = await ApiOperations.getCategoriesList();
    setState(() {
      CatModList = CatModList;
    });
  }

  GetTrendingWallpapers() async {
    print("Get Trending Wallpapers page: $currentPage");
    List<PhotosModel> newWallpapers = await ApiOperations.getWallpapersHomepage(currentPage);

    setState(() {
      if (newWallpapers.isEmpty) {
        hasMoreData = false;
      } else {
        trendingWallList.addAll(newWallpapers);
      }
      isLoading = false;
      isLoadingMore = false;
    });
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
      body:  isLoading ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SearchBar()),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: CatModList.length,
                    itemBuilder: ((context, index) => CatBlock(
                          categoryImgSrc: CatModList[index].url,
                          categoryName: CatModList[index].name,
                          type: CatModList[index].type,
                          id: CatModList[index].id,
                        ))),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 700,
              child: RefreshIndicator(
                onRefresh: () async {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()));
                },
                child: GridView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 400,
                        crossAxisCount: 2,
                        crossAxisSpacing: 13,
                        mainAxisSpacing: 10),
                    itemCount: trendingWallList.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: ((context, index) {
                      
                      if (index == trendingWallList.length) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridTile(
                          child: InkWell(
                            onTap: () {
                              ApiOperations.logToServerTracking("click", trendingWallList[index].id.toString(), 1);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreen(
                                    imgUrl: buildUrlContent(trendingWallList[index].url),
                                    imgId: trendingWallList[index].id.toString(),
                                  ),
                                )
                              );
                            },
                            child: Hero(
                              tag: buildUrlContent(trendingWallList[index].url),
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
                                      buildUrlContent(trendingWallList[index].url)),
                                ),
                              ),
                            ),
                          ),
                      );}
                    )
                  ),
              ),
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
