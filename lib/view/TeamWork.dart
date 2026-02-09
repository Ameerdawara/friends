import 'package:flutter/material.dart';
import 'package:testing/constans/MyColor.dart'; // تأكد من المسار الصحيح

class TeamWork extends StatelessWidget {
  const TeamWork({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, String>> teamMembers = [
      {"name": "المهندس قيس العفيف", "role": ""},
      {"name": "المهندسة دلع عدوان", "role": ""},
      {"name": "المهندسة أمير دواره", "role": ""},
      {"name": "المهندس غيث كحل", "role": ""},
      {"name": "المهندسة حلا هلال", "role": ""},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            backgroundColor: MyColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text(
                "CyperNST",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network('https://images.unsplash.com/photo-1522071820081-009f0129c71c?q=80&w=1000', fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [MyColors.primary, Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 4,
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildInfoSection(context, Icons.rocket_launch_rounded, "رسالة CyperNST", "نسعى لتقديم حلول تكنولوجية مبتكرة تعزز كفاءة الأعمال."),
                      const Divider(height: 30),
                      _buildInfoSection(context, Icons.lightbulb_outline_rounded, "رؤيتنا", "أن نكون الشريك التقني الأول من خلال الابتكار المستمر."),
                      const Divider(height: 30),
                      _buildInfoSection(context, Icons.manage_accounts_rounded, "بإدارة", "شام بلان"),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                "فريق العمل",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MyColors.primary),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildTeamMemberListItem(
                  context,
                  teamMembers[index]['name']!,
                  teamMembers[index]['role']!,
                  MyColors.primary,
                ),
                childCount: teamMembers.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, IconData icon, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: MyColors.primary, size: 24),
            const SizedBox(width: 10),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: MyColors.primary)),
          ],
        ),
        const SizedBox(height: 8),
        Text(content, style: Theme.of(context).textTheme.bodyMedium)
      ],
    );
  }

  Widget _buildTeamMemberListItem(BuildContext context, String name, String role, Color primaryColor) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.04), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: primaryColor.withOpacity(0.1),
          child: Icon(Icons.person, color: primaryColor),
        ),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).textTheme.bodyLarge?.color)),
        subtitle: Text(role, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6), fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12),
      ),
    );
  }
}