// To parse this JSON data, do
//
//     final faceModel = faceModelFromMap(jsonString);

import 'dart:convert';

FaceModel faceModelFromMap(String str) => FaceModel.fromMap(json.decode(str));

String faceModelToMap(FaceModel data) => json.encode(data.toMap());

class FaceModel {
    FaceModel({
        required this.faceDetection,
        required this.taskCall,
        required this.subCalls,
        required this.status,
        required this.performed,
        required this.media,
        required this.unitsConsumed,
        required this.totalComputeTime,
    });

    FaceDetection faceDetection;
    String taskCall;
    List<String> subCalls;
    String status;
    List<String> performed;
    Media media;
    int unitsConsumed;
    double totalComputeTime;

    factory FaceModel.fromMap(Map<String, dynamic> json) => FaceModel(
        faceDetection: FaceDetection.fromMap(json["face_detection"]),
        taskCall: json["task_call"],
        subCalls: List<String>.from(json["sub_calls"].map((x) => x)),
        status: json["status"],
        performed: List<String>.from(json["performed"].map((x) => x)),
        media: Media.fromMap(json["media"]),
        unitsConsumed: json["units_consumed"],
        totalComputeTime: json["total_compute_time"]?.toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "face_detection": faceDetection.toMap(),
        "task_call": taskCall,
        "sub_calls": List<dynamic>.from(subCalls.map((x) => x)),
        "status": status,
        "performed": List<dynamic>.from(performed.map((x) => x)),
        "media": media.toMap(),
        "units_consumed": unitsConsumed,
        "total_compute_time": totalComputeTime,
    };
}

class FaceDetection {
    FaceDetection({
        required this.computeTime,
        required this.confidenceScore,
        required this.nbFace,
        required this.results,
        required this.thumbnail,
    });

    double computeTime;
    double confidenceScore;
    int nbFace;
    List<Result> results;
    Thumbnail thumbnail;

    factory FaceDetection.fromMap(Map<String, dynamic> json) => FaceDetection(
        computeTime: json["compute_time"]?.toDouble(),
        confidenceScore: json["confidence_score"]?.toDouble(),
        nbFace: json["nb_face"],
        results: List<Result>.from(json["results"].map((x) => Result.fromMap(x))),
        thumbnail: Thumbnail.fromMap(json["thumbnail"]),
    );

    Map<String, dynamic> toMap() => {
        "compute_time": computeTime,
        "confidence_score": confidenceScore,
        "nb_face": nbFace,
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
        "thumbnail": thumbnail.toMap(),
    };
}

class Result {
    Result({
        required this.face,
        required this.gender,
    });

    Face face;
    Gender gender;

    factory Result.fromMap(Map<String, dynamic> json) => Result(
        face: Face.fromMap(json["face"]),
        gender: Gender.fromMap(json["gender"]),
    );

    Map<String, dynamic> toMap() => {
        "face": face.toMap(),
        "gender": gender.toMap(),
    };
}

class Face {
    Face({
        required this.confidenceScore,
        required this.faceRectangle,
    });

    double confidenceScore;
    Thumbnail faceRectangle;

    factory Face.fromMap(Map<String, dynamic> json) => Face(
        confidenceScore: json["confidence_score"]?.toDouble(),
        faceRectangle: Thumbnail.fromMap(json["face_rectangle"]),
    );

    Map<String, dynamic> toMap() => {
        "confidence_score": confidenceScore,
        "face_rectangle": faceRectangle.toMap(),
    };
}

class Thumbnail {
    Thumbnail({
        required this.bottom,
        required this.left,
        required this.right,
        required this.top,
    });

    int bottom;
    int left;
    int right;
    int top;

    factory Thumbnail.fromMap(Map<String, dynamic> json) => Thumbnail(
        bottom: json["bottom"],
        left: json["left"],
        right: json["right"],
        top: json["top"],
    );

    Map<String, dynamic> toMap() => {
        "bottom": bottom,
        "left": left,
        "right": right,
        "top": top,
    };
}

class Gender {
    Gender({
        required this.confidenceScore,
        required this.decision,
    });

    double confidenceScore;
    String decision;

    factory Gender.fromMap(Map<String, dynamic> json) => Gender(
        confidenceScore: json["confidence_score"]?.toDouble(),
        decision: json["decision"],
    );

    Map<String, dynamic> toMap() => {
        "confidence_score": confidenceScore,
        "decision": decision,
    };
}

class Media {
    Media({
        required this.urlImage,
        required this.fileImage,
        required this.mediaId,
    });

    String urlImage;
    String fileImage;
    String mediaId;

    factory Media.fromMap(Map<String, dynamic> json) => Media(
        urlImage: json["url_image"],
        fileImage: json["file_image"],
        mediaId: json["media_id"],
    );

    Map<String, dynamic> toMap() => {
        "url_image": urlImage,
        "file_image": fileImage,
        "media_id": mediaId,
    };
}
