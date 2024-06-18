class CategoryModel {
  int id;
  String name;
  String url;
  String type;

  CategoryModel({required this.id, required this.name, required this.url, required this.type});

  static CategoryModel fromAPI2App(Map<String, dynamic> category) {
    return CategoryModel(
        id: category["id"], 
        name: category["name"],
        url: category["url"] == null ? "" : category["url"],
        type: category["types"] == "wallpaper" ? "normal" : category["types"]);
  }
}
