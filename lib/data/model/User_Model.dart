class UserModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image; // مسار الصورة النسبي من السيرفر
  String? governorate;
  String? city;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.image,
    this.governorate,
    this.city,
  });

  // لتحويل البيانات القادمة من JSON (API)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'], // قد يأتي null
      governorate: json['governorate'],
      city: json['city'],
    );
  }

  // رابط الصورة الكامل
  String get fullImageUrl {
    if (image == null || image!.isEmpty) return "";
    // استبدل هذا بالرابط الحقيقي للسيرفر الخاص بك
    return "http://192.168.10.167:8000/storage/$image";
  }
}