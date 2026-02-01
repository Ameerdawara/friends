class OrderModel {
  final int id;
  final String description;
  final String serviceType; // 'image_request' or 'direct_request'
  final String? profession;
  final String? phone;
  final String? address;
  final String createdAt;
  // بما أن الجدول لا يحتوي على حقل حالة (status)، سنعتبرها افتراضياً
  final String status;

  OrderModel({
    required this.id,
    required this.description,
    required this.serviceType,
    this.profession,
    this.phone,
    this.address,
    required this.createdAt,
    this.status = "قيد المعالجة", // قيمة افتراضية حتى تضيف حقل status في الداتابيز
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      description: json['description'] ?? "",
      serviceType: json['service_type'] ?? "direct_request",
      profession: json['profession'],
      phone: json['phone'],
      address: json['address'],
      createdAt: json['created_at'] ?? DateTime.now().toString(),
    );
  }

  // دوال مساعدة للعرض
  bool get isDirect => serviceType == 'direct_request';

  String get displayTitle {
    if (isDirect) {
      return profession ?? "خدمة حرفية";
    } else {
      return "طلب خاص (صورة)";
    }
  }
}