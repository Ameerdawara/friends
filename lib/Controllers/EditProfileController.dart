import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../features/auth/controller/auth_controller.dart';

class EditProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  late TextEditingController nameController;
  late TextEditingController phoneController;

  // متغيرات المحافظة والمدينة
  var selectedGovernorate = ''.obs;
  var selectedCity = ''.obs;
  RxList<String> currentCitiesList = <String>[].obs;

  // الصورة
  var newImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  // بيانات العراق (نفس الموجودة في SignUpController)
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
    final user = _authController.currentUser.value;

    // 1. تعبئة النصوص
    nameController = TextEditingController(text: user?.name ?? "");
    phoneController = TextEditingController(text: user?.phone ?? "");

    // 2. تعبئة المحافظة والمدينة الحالية
    if (user?.governorate != null && iraqData.containsKey(user!.governorate)) {
      selectedGovernorate.value = user!.governorate!;
      // تحديث قائمة المدن بناءً على المحافظة
      currentCitiesList.value = iraqData[user!.governorate]!;

      // التحقق من أن المدينة موجودة في القائمة
      if (user?.city != null && currentCitiesList.contains(user!.city)) {
        selectedCity.value = user!.city!;
      }
    }
  }

  // تحديث المحافظة
  void updateGovernorate(String? val) {
    if (val != null) {
      selectedGovernorate.value = val;
      currentCitiesList.value = iraqData[val] ?? [];
      selectedCity.value = ''; // تصفير المدينة عند تغيير المحافظة
    }
  }

  // تحديث المدينة
  void updateCity(String? val) {
    if (val != null) {
      selectedCity.value = val;
    }
  }

  // اختيار الصورة
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      newImage.value = File(pickedFile.path);
    }
  }

  // حفظ التغييرات
  Future<void> saveProfile() async {
    if (selectedGovernorate.value.isEmpty || selectedCity.value.isEmpty) {
      Get.snackbar("تنبيه", "يرجى اختيار المحافظة والمدينة");
      return;
    }

    await _authController.updateProfile(
      name: nameController.text,
      phone: phoneController.text,
      governorate: selectedGovernorate.value,
      city: selectedCity.value,
      imagePath: newImage.value?.path,
    );
  }
}