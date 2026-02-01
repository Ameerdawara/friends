class EventModel {
  final int id;
  final String title;
  final String description;
  final String? beforeImage; // قد تكون فارغة
  final String? afterImage;  // قد تكون فارغة
  final String createdAt;
  final String? workerName; // اسم الفني (اختياري)

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    this.beforeImage,
    this.afterImage,
    required this.createdAt,
    this.workerName,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'] ?? "بدون عنوان",
      description: json['description'] ?? "",
      beforeImage: json['before_image'],
      afterImage: json['after_image'],
      // نأخذ التاريخ ونحوله لنص بسيط، أو نتركه كما هو
      createdAt: json['created_at'] ?? DateTime.now().toString(),
      // حسب الباك اند، البيانات تأتي مع علاقة worker
      workerName: json['worker'] != null ? json['worker']['name'] : null,
    );
  }

  // دوال مساعدة للحصول على الرابط الكامل للصورة
  // ملاحظة: تأكد من تغيير IP إذا اختلف
  String get fullBeforeImage => beforeImage != null
      ? "http://192.168.10.81:8000/storage/$beforeImage"
      : "";

  String get fullAfterImage => afterImage != null
      ? "http://192.168.10.81:8000/storage/$afterImage"
      : "";
}