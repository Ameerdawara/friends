import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing/Controllers/ProfileController.dart';
// تأكد من استيراد المودل
import '../data/model/User_Model.dart';

class EditProfileController extends GetxController {
  // لا نحتاج AuthController هنا لجلب البيانات لأننا سنجلبها من الـ API مباشرة
  // final AuthController _authController = Get.find<AuthController>();

  final ProfileController _profilController = Get.find<ProfileController>();

  late TextEditingController nameController;
  late TextEditingController phoneController;

  // حالة تحميل خاصة بهذه الصفحة لجعل المستخدم ينتظر جلب البيانات
  var isLoadingData = true.obs;

  var selectedGovernorate = ''.obs;
  var selectedCity = ''.obs;
  RxList<String> currentCitiesList = <String>[].obs;

  var newImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  final Map<String, List<String>> iraqData = {
    "بغداد": ["بغداد", "الكاظمية", "الأعظمية", "مدينة الصدر", "أبو غريب"],
    "البصرة": ["البصرة", "الزبير", "القرنة", "الفاو", "شط العرب"],
    "نينوى": ["الموصل", "تلعفر", "الحمدانية", "بعاج", "سنجار"],
    "كركوك": ["كركوك", "داقوق", "الحويجة", "تازة خورماتو"],
    "الأنبار": ["الرمادي", "الفلوجة", "القائم", "هيت", "حديثة"],
    "صلاح الدين": ["تكريت", "سامراء", "بيجي", "الشرقاط", "بلد"],
    "ديالى": ["بعقوبة", "الخالص", "المقدادية", "خانقين", "بلدروز"],
    "بابل": ["الحلة", "المحاويل", "المسيب", "الهاشمية", "القاسم"],
    "كربلاء": ["كربلاء", "عين التمر", "الحسينية"],
    "النجف": ["النجف", "الكوفة", "المناذرة", "المشخاب"],
    "القادسية": ["الديوانية", "الشامية", "عفك", "غماس"],
    "واسط": ["الكوت", "النعمانية", "الحي", "الصويرة", "العزيزية"],
    "ميسان": ["العمارة", "المجر الكبير", "قلعة صالح", "علي الغربي", "علي الشرقي"],
    "ذي قار": ["الناصرية", "الشطرة", "سوق الشيوخ", "الرفاعي", "الجبايش"],
    "المثنى": ["السماوة", "الرميثة", "الخضر", "السلمان"],
    "حلبجة": ["حلبجة", "خورمال", "بيارة", "سيد صادق"],
    "أربيل": ["أربيل", "عنكاوا", "خبات", "كويسنجق", "مخمور"],
    "دهوك": ["دهوك", "زاخو", "العمادية", "سيميل", "عقرة"]
  };

  @override
  void onInit() {
    super.onInit();
    // 1. تهيئة المتحكمات بقيم فارغة مبدئياً لتجنب LateInitializationError
    nameController = TextEditingController();
    phoneController = TextEditingController();

    // 2. استدعاء دالة جلب البيانات وتعبئة الحقول
    fetchAndPopulateUserData();
  }

  // دالة لجلب البيانات من الـ ProfileController وتحديث الواجهة
  Future<void> fetchAndPopulateUserData() async {
    isLoadingData.value = true;

    // استدعاء الدالة من ProfileController
    UserModel? user = await _profilController.getProfileData();

    if (user != null) {
      // 1. تعبئة النصوص
      nameController.text = user.name ?? "";
      phoneController.text = user.phone ?? "";

      // 2. تعبئة المحافظة والمدينة
      if (user.governorate != null && iraqData.containsKey(user.governorate)) {
        selectedGovernorate.value = user.governorate!;
        // تحديث قائمة المدن
        currentCitiesList.value = iraqData[user.governorate]!;

        // التحقق من المدينة
        if (user.city != null && currentCitiesList.contains(user.city)) {
          selectedCity.value = user.city!;
        }
      }
    }

    isLoadingData.value = false;
  }

  void updateGovernorate(String? val) {
    if (val != null) {
      selectedGovernorate.value = val;
      currentCitiesList.value = iraqData[val] ?? [];
      selectedCity.value = '';
    }
  }

  void updateCity(String? val) {
    if (val != null) {
      selectedCity.value = val;
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      newImage.value = File(pickedFile.path);
    }
  }

  Future<void> saveProfile() async {
    if (nameController.text.isEmpty) {
      Get.snackbar("تنبيه", "الاسم مطلوب");
      return;
    }

    await _profilController.updateProfile(
      name: nameController.text,
      phone: phoneController.text,
      city: selectedCity.value.isNotEmpty ? selectedCity.value : null,
      governorate: selectedGovernorate.value.isNotEmpty ? selectedGovernorate.value : null,
      imagePath: newImage.value?.path,
    );
  }
}