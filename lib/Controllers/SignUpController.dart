// SignUpController.dart
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignUpController extends GetxController {
  // --- منطق الصورة (موجود سابقاً) ---
  var selectedImagePath = ''.obs;
  var isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    // ... نفس الكود السابق للصورة ...
    try {
      isLoading.value = true;
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
      }
    } catch (e) {
      // ...
    } finally {
      isLoading.value = false;
    }
  }

  void clearImage() {
    selectedImagePath.value = '';
  }

  // --- منطق المحافظات والمدن (الجديد) ---

  // المتغيرات المراقبة للاختيارات
  var selectedGovernorate = ''.obs;
  var selectedCity = ''.obs;

  // قائمة المدن الحالية بناءً على المحافظة المختارة
  RxList<String> currentCitiesList = <String>[].obs;

  // بيانات العراق
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

  // دالة تُستدعى عند اختيار محافظة
  void updateGovernorate(String? val) {
    if (val != null) {
      selectedGovernorate.value = val;
      // تحديث قائمة المدن
      currentCitiesList.value = iraqData[val] ?? [];
      // تصفير المدينة المختارة سابقاً لأنها قد لا تكون موجودة في المحافظة الجديدة
      selectedCity.value = '';
    }
  }

  // دالة تُستدعى عند اختيار مدينة
  void updateCity(String? val) {
    if (val != null) {
      selectedCity.value = val;
    }
  }
}