class CategoryModel {
  int id;
  String name;
  String url;

  CategoryModel({required this.id, required this.name, required this.url});

  static CategoryModel fromAPI2App(Map<String, dynamic> category) {
    return CategoryModel(
        id: category["id"], 
        name: category["name"],
        url: category["url"] == null ? "" : category["url"]);
  }
}
