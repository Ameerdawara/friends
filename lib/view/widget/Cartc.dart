import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ServiceCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String lottiePath;
  final Color cardColor; // متغير جديد للون الكارد
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.lottiePath,
    required this.cardColor, // استقبال اللون
    this.onTap,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        if (widget.onTap != null) widget.onTap!();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 140, // تقليل الارتفاع قليلاً ليناسب التصميم العرضي
          decoration: BoxDecoration(
            color: widget.cardColor, // استخدام اللون الممرر
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: widget.cardColor.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // زخرفة خلفية (دائرة شفافة كبيرة)
                Positioned(
                  right: -30,
                  top: -30,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                Row(
                  children: [
                    // 1. قسم اللوتي (على اليمين حسب اتجاه العربية أو اليسار حسب تصميم Row)
                    // بما أننا نستخدم Row، العنصر الأول سيكون على اليمين إذا كان التطبيق RTL
                    // أو يمكنك التحكم في الترتيب يدوياً. هنا وضعناه في البداية.
                    Container(
                      width: 130, // تحديد عرض ثابت للأنيميشن
                      height: 140,
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Lottie.asset(
                          widget.lottiePath,
                          fit: BoxFit.contain,
                          repeat: true,
                          frameRate: FrameRate(60),

                        ),
                      ),
                    ),

                    // 2. قسم النصوص
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.subtitle,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // أيقونة السهم في النهاية
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white.withOpacity(0.7),
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}