import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/task_models.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../theme/design_tokens.dart';

Color _priorityColor(String p) {
  switch (p) {
    case 'important':
      return AppColors.tagImportant;
    case 'urgent':
      return AppColors.tagUrgent;
    case 'basic':
    default:
      return AppColors.tagBasic;
  }
}

class TagChip extends StatelessWidget {
  final String label;
  final String priority;
  const TagChip({super.key, required this.label, required this.priority});
  @override
  Widget build(BuildContext context) {
    final c = _priorityColor(priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label,
          style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white)),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color iconColor;
  const StatCard({super.key, required this.title, required this.value, required this.subtitle, required this.iconColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Radii.cardStat),
        boxShadow: [
          BoxShadow(color: iconColor.withValues(alpha: .15), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: iconColor.withValues(alpha: .18), borderRadius: BorderRadius.circular(10)),
          child: Icon(Icons.task_alt, size: 20, color: iconColor),
        ),
        const SizedBox(height: 14),
        Text(title, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Row(children: [
          Text(value, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(width: 4),
          Text(subtitle, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
        ])
      ]),
    );
  }
}

class AvatarGroup extends StatelessWidget {
  final List<String> members; // asset paths
  final double size;
  final int maxVisible;
  const AvatarGroup({super.key, required this.members, this.size = 32, this.maxVisible = 4});
  @override
  Widget build(BuildContext context) {
    final visible = members.take(maxVisible).toList();
    final overlap = size * 0.55;
    final totalWidth = visible.isEmpty ? size : size + (visible.length - 1) * overlap;
    return SizedBox(
      height: size,
      width: totalWidth,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < visible.length; i++)
            Positioned(
              left: i * overlap,
              top: 0,
              child: _AvatarImage(path: visible[i], size: size),
            ),
        ],
      ),
    );
  }
}

class _AvatarImage extends StatelessWidget {
  final String path;
  final double size;
  const _AvatarImage({required this.path, required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: .07), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          path,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) => _fallbackAvatar(size: size),
        ),
      ),
    );
  }

  Widget _fallbackAvatar({required double size}) {
    return Container(
      color: AppColors.purpleStart.withValues(alpha: .15),
      child: Center(
        child: Icon(Icons.person, size: size * .55, color: AppColors.purpleStart.withValues(alpha: .65)),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final TaskItem task;
  final VoidCallback onTap;
  const TaskCard({super.key, required this.task, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final gradient = task.priority == 'basic'
        ? const [AppColors.blueStart, AppColors.blueEnd]
        : const [Color(0xFF9C88FF), Color(0xFFB794F6)];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight, stops: const [0.0, 1.0]),
          borderRadius: BorderRadius.circular(Radii.cardLarge),
          boxShadow: [
            BoxShadow(color: gradient.first.withValues(alpha: .35), blurRadius: 18, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Text(task.title,
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
            TagChip(label: task.priority == 'basic' ? 'Basic' : 'Important', priority: task.priority),
          ]),
          const SizedBox(height: 8),
            Text(
              task.description,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withValues(alpha: .9)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 18),
          Row(children: [
            Text('There are ${task.subTasks.where((t)=>!t.isCompleted).length} unfinished tasks',
                style: GoogleFonts.poppins(fontSize: 10, color: Colors.white.withValues(alpha: .85))),
            const Spacer(),
            CircularPercentIndicator(
              radius: 20,
              lineWidth: 3,
              percent: task.progress,
              center: Text('${(task.progress * 100).round()}%', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white)),
              progressColor: Colors.white,
              backgroundColor: Colors.white.withValues(alpha: .3),
            ),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Text(DateFormat('d MMM yyyy').format(task.dueDate),
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
            const Spacer(),
            AvatarGroup(members: task.teamMembers, size: 28),
          ])
        ]),
      ),
    );
  }
}

class ProgressCircle extends StatelessWidget {
  final double progress;
  const ProgressCircle({super.key, required this.progress});
  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 25,
      lineWidth: 4,
      percent: progress,
      center: Text('${(progress * 100).round()}%', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      progressColor: AppColors.purpleStart,
      backgroundColor: Colors.grey[200]!,
    );
  }
}

class DecorativeBackground extends StatelessWidget {
  final Widget child;
  const DecorativeBackground({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
        child: CustomPaint(painter: _ScribblePainter()),
      ),
      child,
    ]);
  }
}

class _ScribblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = AppColors.purpleStart.withValues(alpha: .12);
    final path = Path();
    final amplitude = 22.0;
    final cycles = 3;
    final startX = size.width * .65;
    final startY = 40.0;
    path.moveTo(startX, startY);
    for (int i = 0; i < cycles * 2; i++) {
      final x = startX + i * 26;
      final y = startY + (i.isEven ? -amplitude : amplitude);
      path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);

    final randomSpots = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.purpleEnd.withValues(alpha: .15);
    for (int i = 0; i < 8; i++) {
      final dx = startX - 60 + i * 18;
      final dy = startY + math.sin(i.toDouble()) * 30 + 180;
      canvas.drawCircle(Offset(dx, dy), 6, randomSpots);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
