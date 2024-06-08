import 'dart:convert';

BannerImages bannerImagesFromMap(String str) => BannerImages.fromMap(json.decode(str));

String bannerImagesToMap(BannerImages data) => json.encode(data.toMap());

class BannerImages {
    BannerImages({
        required this.images,
    });

    List<Images> images;

    factory BannerImages.fromMap(Map<String, dynamic> json) => BannerImages(
        images: List<Images>.from(json["images"].map((x) => Images.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "images": List<dynamic>.from(images.map((x) => x.toMap())),
    };
}

class Images {
    Images({
        required this.id,
        required this.link,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    String id;
    String link;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    factory Images.fromMap(Map<String, dynamic> json) => Images(
        id: json["_id"],
        link: json["link"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "link": link,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}
