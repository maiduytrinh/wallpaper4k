import 'package:flutter/material.dart';
import 'package:wallpaper_guru/views/screens/category.dart';

class CatBlock extends StatelessWidget {
  String categoryName;
  String categoryImgSrc;
  String type;
  int id;

  CatBlock(
      {super.key, required this.categoryImgSrc, required this.categoryName, required this.type, required this.id});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryScreen(
                    catImgUrl: categoryImgSrc, catName: categoryName, type: type, id: id)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 7),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                  height: 50, width: 100, fit: BoxFit.cover, categoryImgSrc),
            ),
            Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12)),
            ),
            Positioned(
                left: 30,
                top: 15,
                child: Text(
                  categoryName,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ))
          ],
        ),
      ),
    );
  }
}
