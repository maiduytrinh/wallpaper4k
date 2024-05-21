class PhotosModel {
  int id;
  String name;
  String hashtag;
  String countries;
  String categories;
  String url;
  String contentType;
  int createdDate;

  PhotosModel({required this.id , required this.name, required this.hashtag, required this.countries, required this.categories, required this.url, required this.contentType, required this.createdDate});

  static PhotosModel fromAPI2App(Map<String, dynamic> photoMap) {
    return PhotosModel(
      id: photoMap["id"],
      name: photoMap["name"],
      hashtag: photoMap["hashtag"],
      countries: photoMap["countries"],
      categories: photoMap["categories"],
      url: photoMap["url"],
      contentType: photoMap["contentType"],
      createdDate: photoMap["createdDate"],
    );
  }
}