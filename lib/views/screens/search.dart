import 'package:flutter/material.dart' hide SearchBar;
import 'package:wallpaper_guru/controller/apiOper.dart';
import 'package:wallpaper_guru/model/photosModel.dart';
import 'package:wallpaper_guru/views/screens/FullScreen.dart';
import 'package:wallpaper_guru/views/widgets/CustomAppBar.dart';
import 'package:wallpaper_guru/views/widgets/SearchBar.dart';

class SearchScreen extends StatefulWidget {
  String query;
  SearchScreen({super.key, required this.query});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<PhotosModel> searchResults = [];
  static String uriStorage = "https://www.wallstorage.net/wallstorage/";
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  ScrollController _scrollController = ScrollController();

  GetSearchResults() async {
    print("Get Trending Wallpapers page: $currentPage");
    List<PhotosModel> newWallpapers = await ApiOperations.searchWallpapers(currentPage, widget.query);

    setState(() {
      if (newWallpapers.isEmpty) {
        hasMoreData = false;
      } else {
        searchResults.addAll(newWallpapers);
      }
      isLoading = false;
      isLoadingMore = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetSearchResults();
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
      GetSearchResults();
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
      body: isLoading ? const Center(child: CircularProgressIndicator(),)  : SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SearchBar()),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 400,
                      crossAxisCount: 2,
                      crossAxisSpacing: 13,
                      mainAxisSpacing: 10),
                  itemCount: searchResults.length + (isLoadingMore ? 1 : 0),
                  itemBuilder: ((context, index) {
                    if (index == searchResults.length) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                    }
                    return GridTile(
                      child: InkWell(
                        onTap: () {
                          ApiOperations.logToServerTracking("click", searchResults[index].id.toString(), 1);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullScreen(
                                      imgUrl: buildUrlContent(searchResults[index].url),
                                      imgId: searchResults[index].id.toString(),
                                  )
                              )
                          );
                        },
                        child: Hero(
                          tag: buildUrlContent(searchResults[index].url),
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
                                  buildUrlContent(searchResults[index].url)),
                            ),
                          ),
                        ),
                      ),
                    );
                  })
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
