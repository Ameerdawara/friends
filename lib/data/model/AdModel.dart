class AdModel {
  final int id;
  final String? title;
  final String? description;
  final String? image;
  final String? governorate;

  AdModel({
    required this.id,
    this.title,
    this.description,
    this.image,
    this.governorate,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      governorate: json['governorate'],
    );
  }

  // دالة للحصول على رابط الصورة الكامل
  String get fullImageUrl => image != null
      ? "http://192.168.10.81:8000/storage/$image"
      : "https://via.placeholder.com/400x200"; // صورة افتراضية في حال عدم وجود صورة
}