class Gallery{
  int id;
  List<GalleryImage> backdrops;

  Gallery({
    required this.id,
    required this.backdrops,
  });

  factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
    backdrops: List<GalleryImage>.from(
        json["backdrops"].map((x) => GalleryImage.fromJson(x))),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "backdrops": List<dynamic>.from(backdrops.map((x) => x.toJson())),
    "id": id,
  };
}

class GalleryImage{
  final double aspectRatio;
  final int height;
  final String filePath;
  final int width;

  GalleryImage({
    required this.aspectRatio,
    required this.height,
    required this.filePath,
    required this.width,
  });

  factory GalleryImage.fromJson(Map<String, dynamic> json) => GalleryImage(
    aspectRatio: json["aspect_ratio"]?.toDouble(),
    height: json["height"],
    filePath: json["file_path"] ?? '',
    width: json["width"],
  );

  Map<String, dynamic> toJson() => {
    "aspect_ratio": aspectRatio,
    "height": height,
    "file_path": filePath,
    "width": width,
  };

  String display(){
    return "https://image.tmdb.org/t/p/original$filePath";
  }
}