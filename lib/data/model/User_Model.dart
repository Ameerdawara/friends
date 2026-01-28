class UserModel {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? governorate;
  final String? city;
  final String? image; // مسار الصورة القادم من الباك اند

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.governorate,
    this.city,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // لارافيل عند استخدام load('profile') يرسل البيانات داخل كائن اسمه profile
    String? rawImage = json['image']?.toString() ??
        json['profile']?['image']?.toString();
    final profileData = json['profile'] as Map<String, dynamic>?;
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'] ?? profileData?['phone'],
      // الأولوية للبيانات الموجودة في البروفايل، إذا لم توجد نأخذها من اليوزر
      governorate: profileData?['governorate'] ?? json['governorate'],
      city: profileData?['city'] ?? json['city'],
      image: rawImage
    );
  }

  // ✅ دالة مساعدة للحصول على الرابط الكامل للصورة
  // استبدل الـ IP بالعنوان الخاص بسيرفرك
  String get fullImageUrl {
    if (image == null || image!.isEmpty) return "";

    // إذا كان الرابط يبدأ بـ http (بسبب تعديل Laravel أعلاه) نرجعه كما هو
    if (image!.startsWith('http')) {
      return image!.replaceAll('localhost', '192.168.10.129'); // للأندرويد إيموليتور
    }

    // إذا كان المسار مجرد نص (مثل profiles/abc.jpg) نقوم بتركيبه مع رابط السيرفر
    const String       baseUrl= "http://192.168.10.129:8000/api";

    return "$baseUrl$image";
  }
}