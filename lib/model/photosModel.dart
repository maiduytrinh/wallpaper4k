class PhotosModel {
  String imgSrc;
  String PhotoName;
  int id;

  PhotosModel({required this.id , required this.PhotoName, required this.imgSrc});

  static PhotosModel fromAPI2App(Map<String, dynamic> photoMap) {
    return PhotosModel(
      id: photoMap["id"],
      PhotoName: photoMap["photographer"],
      imgSrc: (photoMap["src"])["portrait"]);
  }
}
