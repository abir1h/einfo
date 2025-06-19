class InstituteEntity {
  final int id;
  final String title;
  final String instituteType;
  final int isActive;
  final String createdAt;
  final String updatedAt;
   bool isSelected;

  InstituteEntity({
    required this.id,
    required this.title,
    required this.instituteType,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.isSelected
  });

  factory InstituteEntity.empty() => InstituteEntity(
      id: -1,
      title: "",
      instituteType: "",
      isActive: -1,
      createdAt: "",isSelected: false,
      updatedAt: "");

  factory InstituteEntity.fromJson(Map<String, dynamic> json) =>
      InstituteEntity(
        id: json["id"] ?? -1,
        title: json["title"] ?? "",
        instituteType: json["institute_type"] ?? "",
        isActive: json["is_active"] ?? -1,
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",isSelected: json['isSelected']??false
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "institute_type": instituteType,
        "is_active": isActive,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };static List<InstituteEntity> listFromJson(List<dynamic> json) {
    return json.isNotEmpty
        ? List.castFrom<dynamic, InstituteEntity>(
        json.map((x) => InstituteEntity.fromJson(x)).toList())
        : [];
  }
}
