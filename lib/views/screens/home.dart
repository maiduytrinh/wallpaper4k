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
  late List<PhotosModel> trendingWallList;
  late List<CategoryModel> CatModList;
  static var uriStorage = "https://www.wallstorage.net/wallstorage/";
  bool isLoading = true;

  GetCatDetails() async {
    CatModList = await ApiOperations.getCategoriesList();
    print("GETTTING CAT MOD LIST");
    setState(() {
      CatModList = CatModList;
    });
  }

  GetTrendingWallpapers() async {
    trendingWallList = await ApiOperations.getWallpapersHomepage(2);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    GetCatDetails();
    GetTrendingWallpapers();
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
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 400,
                        crossAxisCount: 2,
                        crossAxisSpacing: 13,
                        mainAxisSpacing: 10),
                    itemCount: trendingWallList.length,
                    itemBuilder: ((context, index) => GridTile(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FullScreen(
                                          imgUrl:
                                              buildUrlContent(trendingWallList[index].url))));
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
                        ))),
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
