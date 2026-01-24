class UserModel {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? governorate; // تأكد من وجود هذا
  final String? city;        // تأكد من وجود هذا
  final String? image;       // مسار الصورة كما هو في قاعدة البيانات

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.governorate,
    this.city,
    this.image,
  });
// داخل UserModel.fromJson إذا كنت تستخدم نظام الجدولين:
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      // الوصول للبيانات داخل كائن profile
      city: json['profile'] != null ? json['profile']['city'] : json['city'],
      governorate: json['profile'] != null ? json['profile']['governorate'] : json['governorate'],
      image: json['profile'] != null ? json['profile']['image'] : json['image'],
    );
  }

  // ✅ دالة مهمة جداً لجلب الرابط الكامل للصورة
  String get fullImageUrl {
    if (image == null || image!.isEmpty) return "";

    // إذا كانت الصورة رابط خارجي (مثل جوجل) نرجعه كما هو
    if (image!.startsWith('http')) return image!;

    // ⚠️ استبدل هذا الـ IP بنفس الـ IP الموجود في dio_client.dart
    // يجب أن يشير إلى مجلد storage في لارفيل
    return "http://192.168.10.81:8000/storage/$image";
  }
}