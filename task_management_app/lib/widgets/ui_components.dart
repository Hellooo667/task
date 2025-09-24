import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/task_models.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../theme/design_tokens.dart';
import 'dart:math' as math;

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
  final IconData? icon;
  final String? assetIconPath; // optional asset icon
  const StatCard({super.key, required this.title, required this.value, required this.subtitle, required this.iconColor, this.icon, this.assetIconPath});
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
        Builder(builder: (context) {
          final useAsset = assetIconPath != null && assetIconPath!.isNotEmpty;
          final double iconBox = useAsset ? 40 : 36; // slightly larger for asset image
          return Container(
            width: iconBox,
            height: iconBox,
            decoration: useAsset
                ? const BoxDecoration(
                    // No tint/background when using provided asset; show it exactly
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  )
                : BoxDecoration(
                    color: iconColor.withValues(alpha: .18),
                    borderRadius: BorderRadius.circular(10),
                  ),
            child: _buildIcon(),
          );
        }),
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

  Widget _buildIcon() {
    if (assetIconPath != null && assetIconPath!.isNotEmpty) {
      return Image.asset(
        assetIconPath!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(icon ?? Icons.hourglass_empty_rounded, size: 20, color: iconColor),
      );
    }
    return Icon(icon ?? Icons.hourglass_empty_rounded, size: 20, color: iconColor);
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
    final isBasic = task.priority == 'basic';
    // Background treatment
    const blueCardColor = Color(0xFFBBE6FF); // exact required color for blue card
    const purpleGradient = [AppColors.purpleStart, AppColors.purpleEnd];
    final shadowColor = isBasic
        ? const Color(0xFF5C9DE7).withValues(alpha: .35)
        : purpleGradient.first.withValues(alpha: .35);
    // Date chip background colors (exact hexes per design)
    final Color chipBgColor = isBasic
        ? const Color(0xFF5C9DE7)
        : const Color(0xFFC090F5);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        decoration: BoxDecoration(
          color: isBasic ? blueCardColor : null,
          gradient: isBasic
              ? null
              : const LinearGradient(colors: purpleGradient, begin: Alignment.topLeft, end: Alignment.bottomRight, stops: [0.0, 1.0]),
          borderRadius: BorderRadius.circular(Radii.cardLarge),
          boxShadow: [
            BoxShadow(color: shadowColor, blurRadius: 18, offset: const Offset(0, 10)),
          ],
        ),
        child: Stack(children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: isBasic ? _BlueBlobsPainter() : _PurpleScribblePainter(),
              ),
            ),
          ),
          // Content column
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Title with space for progress circle on right via padding
            Padding(
              padding: const EdgeInsets.only(right: 70),
              child: Text(task.title,
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
            const SizedBox(height: 8),
            if (task.description.isNotEmpty)
              Text(
                task.description,
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withValues(alpha: .9)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 14),
            Text('There are ${task.subTasks.where((t)=>!t.isCompleted).length} unfinished tasks',
                style: GoogleFonts.poppins(fontSize: 10, color: Colors.white.withValues(alpha: .85))),
            const SizedBox(height: 26),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  TagChip(label: task.priority == 'basic' ? 'Basic' : 'Important', priority: task.priority),
                  const SizedBox(width: 10),
                  _DateChip(date: task.dueDate, bgColor: chipBgColor),
                ]),
                const SizedBox(height: 12),
                // AvatarGroup moved to bottom-right via Positioned; leave space here for vertical rhythm
              ]),
            ])
          ]),
          // Progress circle positioned top-right
          Positioned(
            top: 4,
            right: 0,
            child: _CardProgress(
              percent: task.progress,
              color: isBasic ? AppColors.blueStart : AppColors.purpleStart,
              bg: Colors.white.withValues(alpha: .35),
            ),
          ),
          // Avatars positioned bottom-right
          Positioned(
            right: 0,
            bottom: 4,
            child: AvatarGroup(members: task.teamMembers, size: 28),
          ),
        ]),
      ),
    );
  }
}

class _CardProgress extends StatelessWidget {
  final double percent;
  final Color color;
  final Color bg;
  const _CardProgress({required this.percent, required this.color, required this.bg});
  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 24,
      lineWidth: 4,
      percent: percent,
      reverse: true,
      center: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: .12), blurRadius: 6, offset: const Offset(0, 2)),
        ]),
        child: Center(child: Text('${(percent * 100).round()}%', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
      ),
      progressColor: color,
      backgroundColor: bg,
    );
  }
}

// Painters for decorative backgrounds
class _PurpleScribblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    // Draw a few curved scribbles on top-right area
    final path1 = Path()
      ..moveTo(size.width * 0.78, size.height * 0.18)
      ..cubicTo(size.width * 0.86, size.height * 0.10, size.width * 0.94, size.height * 0.22, size.width * 0.88, size.height * 0.28);
    canvas.drawPath(path1, paint);
    final path2 = Path()
      ..moveTo(size.width * 0.80, size.height * 0.30)
      ..cubicTo(size.width * 0.88, size.height * 0.22, size.width * 0.96, size.height * 0.34, size.width * 0.90, size.height * 0.40);
    canvas.drawPath(path2, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BlueBlobsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
  final blobColor = Colors.white.withValues(alpha: 0.35);
    final paint = Paint()..color = blobColor;
    void blob(Offset c, double rx, double ry, double rotationDeg) {
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(rotationDeg * math.pi / 180);
      final rect = Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(ry)), paint);
      canvas.restore();
    }
    blob(Offset(size.width * .18, size.height * .18), 18, 10, -12);
    blob(Offset(size.width * .30, size.height * .12), 12, 8, 18);
    blob(Offset(size.width * .44, size.height * .16), 14, 9, -8);
    blob(Offset(size.width * .60, size.height * .10), 10, 7, 10);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DateChip extends StatelessWidget {
  final DateTime date;
  final Color bgColor;
  const _DateChip({required this.date, required this.bgColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(DateFormat('d MMM yyyy').format(date),
          style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white)),
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
      reverse: true,
      center: Text('${(progress * 100).round()}%', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      progressColor: AppColors.purpleStart,
      backgroundColor: Colors.grey[200]!,
    );
  }
}

