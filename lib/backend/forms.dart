import 'dart:convert';

Forms formsFromMap(String str) => Forms.fromMap(json.decode(str));

String formsToMap(Forms data) => json.encode(data.toMap());

class Forms {
    Forms({
        required this.forms,
    });

    List<Form> forms;

    factory Forms.fromMap(Map<String, dynamic> json) => Forms(
        forms: List<Form>.from(json["forms"].map((x) => Form.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "forms": List<dynamic>.from(forms.map((x) => x.toMap())),
    };
}

class Form {
    Form({
        required this.id,
        required this.title,
        required this.description,
        required this.type,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    String id;
    String title;
    String description;
    String type;
    String status;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    factory Form.fromMap(Map<String, dynamic> json) => Form(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        type: json["type"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "title": title,
        "description": description,
        "type": type,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}
