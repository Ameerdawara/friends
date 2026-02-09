class OrderModel {
  final int id;
  final String? description;
  final String serviceType;
  final String? profession;
  final String? address;
  final String status; // الحقل الجديد
  final DateTime createdAt;

  OrderModel({
    required this.id,
    this.description,
    required this.serviceType,
    this.profession,
    this.address,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      description: json['description'],
      serviceType: json['service_type'],
      profession: json['profession'],
      address: json['address'],
      status: json['status'] ?? 'pending', // القيمة الافتراضية
      createdAt: DateTime.parse(json['created_at']),
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