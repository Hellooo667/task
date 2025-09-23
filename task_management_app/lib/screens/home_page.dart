import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/task_models.dart';
import '../widgets/ui_components.dart';
import 'task_detail_page.dart';
import '../theme/design_tokens.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = demoTasks();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.screenHPad, vertical: Spacing.screenVPad),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _profileAvatar(),
                const Spacer(),
                _circleButton(icon: Icons.add, bg: AppColors.tagImportant),
                const SizedBox(width: 14),
                _notificationButton(count: 8),
              ]),
              const SizedBox(height: 20),
              Text('Hello, Jane', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              Text('You have 6 tasks to complete', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: Spacing.sectionGapMd + 12),
              Row(children: [
                Expanded(child: StatCard(title: 'Task Today', value: '8', subtitle: 'Tasks', iconColor: AppColors.purpleStart)),
                const SizedBox(width: 18),
                Expanded(child: StatCard(title: 'In Progress', value: '4', subtitle: 'Tasks', iconColor: AppColors.blueStart)),
              ]),
              const SizedBox(height: Spacing.sectionGapMd),
              Text('Your Task', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: Spacing.sectionGapSm - 2),
              _dateRow(),
              const SizedBox(height: Spacing.sectionGapSm + 6),
              Expanded(
                child: ListView.separated(
                  itemCount: tasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: Spacing.cardGap),
                  itemBuilder: (context, i) => TaskCard(
                    task: tasks[i],
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailPage(task: tasks[i]))),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }

  Widget _dateRow() {
    final inactive = GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary);
    return Row(children: [
      Text('Monday 16 Oct, 2023', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
      const Spacer(),
      Text('Tue', style: inactive),
      const SizedBox(width: 16),
      Text('Wed', style: inactive),
      const SizedBox(width: 16),
      Text('Thu', style: inactive),
    ]);
  }

  Widget _circleButton({required IconData icon, required Color bg}) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle, boxShadow: [
        BoxShadow(color: bg.withValues(alpha: .4), blurRadius: 16, offset: const Offset(0, 8)),
      ]),
      child: Icon(icon, color: Colors.white, size: 26),
    );
  }

  Widget _notificationButton({required int count}) {
    const bg = AppColors.white;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 10, offset: const Offset(0, 4)),
            ],
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary, size: 26),
        ),
        Positioned(
          top: -2,
          right: -2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.tagImportant,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: AppColors.tagImportant.withValues(alpha: .5), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Text(
              '$count',
              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  Widget _profileAvatar() {
    const path = 'assets/avatars/jane.png';
    return Container(
      width: AvatarSizes.homeProfile,
      height: AvatarSizes.homeProfile,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: .06), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          path,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => Container(
            color: AppColors.purpleStart.withValues(alpha: .15),
            child: Icon(Icons.person, size: 28, color: AppColors.purpleStart.withValues(alpha: .55)),
          ),
        ),
      ),
    );
  }
}
