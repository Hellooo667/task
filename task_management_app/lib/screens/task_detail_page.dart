import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/task_models.dart';
import '../widgets/ui_components.dart';
import 'package:intl/intl.dart';
import '../theme/design_tokens.dart';

class TaskDetailPage extends StatelessWidget {
  final TaskItem task;
  const TaskDetailPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: .06), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(children: [
                    const _PencilWithLine(),
                    const SizedBox(width: 8),
                    Text('Edit Task', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                  ]),
                ),
              ),
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.screenHPad, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TagChip(label: 'Important', priority: task.priority),
                  ),
                  const SizedBox(height: Spacing.sectionGapSm),
                  Text(task.title, style: AppTextStyles.h1),
                  const SizedBox(height: Spacing.sectionGapMd),
                  Row(children: [
                    Expanded(child: _createdBy()),
                    Expanded(child: _dueDate()),
                  ]),
                  const SizedBox(height: Spacing.sectionGapLg),
                  Text('Description', style: AppTextStyles.h3),
                  const SizedBox(height: Spacing.sectionGapSm - 4),
                  Text(task.description, style: AppTextStyles.body),
                  const SizedBox(height: Spacing.sectionGapLg),
                  Row(children: [
                    Text('Team Member (${task.teamMembers.length})', style: AppTextStyles.h3),
                    const Spacer(),
                    ProgressCircle(progress: task.progress),
                  ]),
                  const SizedBox(height: Spacing.sectionGapSm),
                  _teamRow(),
                  const SizedBox(height: Spacing.sectionGapLg),
                  Text('Task Progress', style: AppTextStyles.h3),
                  const SizedBox(height: Spacing.sectionGapSm),
                ]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.screenHPad),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final s = task.subTasks[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: Spacing.sectionGapSm - 2),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Radii.subTask),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: s.isCompleted ? Colors.white : Colors.grey[300],
                          shape: BoxShape.circle,
                          border: s.isCompleted ? Border.all(color: Colors.black, width: 2) : null,
                        ),
                        child: s.isCompleted ? const Icon(Icons.check, size: 14, color: Colors.black) : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(s.title,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            )),
                      ),
                      const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    ]),
                  );
                }, childCount: task.subTasks.length),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      );
  }

  Widget _createdBy() {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      _circleImage(task.createdByAvatar, 42),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Created', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
        Text(task.createdBy, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
      ])
    ]);
  }

  Widget _dueDate() {
    return Row(children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: AppColors.purpleStart.withValues(alpha: .18), shape: BoxShape.circle),
        child: const Icon(Icons.calendar_today, size: 18, color: AppColors.purpleStart),
      ),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Due Date', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
        Text(DateFormat('d MMM yyyy').format(task.dueDate), style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
      ])
    ]);
  }

  Widget _teamRow() {
    const overlap = 34.0; // horizontal shift
    const size = 46.0;
    return SizedBox(
      height: size,
      child: Stack(children: [
        for (int i = 0; i < task.teamMembers.length; i++)
          Positioned(
            left: i * overlap,
            child: _circleImage(task.teamMembers[i], size),
          ),
        Positioned(
          left: task.teamMembers.length * overlap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: .12), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: const Icon(Icons.add, size: 22, color: Colors.white),
          ),
        ),
      ]),
    );
  }

  Widget _circleImage(String path, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: .06), blurRadius: 6, offset: const Offset(0, 3)),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          path,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => Container(
            color: AppColors.purpleStart.withValues(alpha: .15),
            child: Icon(Icons.person, size: size * .55, color: AppColors.purpleStart.withValues(alpha: .6)),
          ),
        ),
      ),
    );
  }
}

class _PencilWithLine extends StatelessWidget {
  const _PencilWithLine();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(Icons.edit, size: 14, color: AppColors.textPrimary),
          const SizedBox(height: 2),
          Container(width: 12, height: 2, color: AppColors.textPrimary.withValues(alpha: .9)),
        ],
      ),
    );
  }
}
