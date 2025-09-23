class SubTask {
  final String title;
  final bool isCompleted;
  const SubTask({required this.title, required this.isCompleted});
}

class TaskItem {
  final String id;
  final String title;
  final String description;
  final String createdBy;
  final String createdByAvatar; // path to asset
  final DateTime dueDate;
  final double progress; // 0..1
  final List<String> teamMembers; // asset paths
  final String priority; // important | urgent | basic
  final List<SubTask> subTasks;

  const TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.createdByAvatar,
    required this.dueDate,
    required this.progress,
    required this.teamMembers,
    required this.priority,
    required this.subTasks,
  });
}

List<TaskItem> demoTasks() => [
  TaskItem(
    id: '1',
    title: '3D Character Cute Robot',
    description: 'Create a 3d robot character using blender, the style used is simple and cute and uses soft colors.',
      createdBy: 'Smith',
      createdByAvatar: 'assets/avatars/smith.jpeg',
    dueDate: DateTime(2023, 10, 16),
    progress: 0.65,
    teamMembers: [
      'assets/avatars/team_member1.png',
      'assets/avatars/team_member2.png',
      'assets/avatars/team_member3.png',
      'assets/avatars/jane.png',
    ],
    priority: 'important',
    subTasks: const [
      SubTask(title: 'Task 1', isCompleted: true),
      SubTask(title: 'Task 2', isCompleted: false),
      SubTask(title: 'Task 3', isCompleted: false),
    ],
  ),
  TaskItem(
    id: '2',
    title: 'Illustration for Caraso Company',
    description: 'There are 1 unfinished tasks',
      createdBy: 'Jane',
      createdByAvatar: 'assets/avatars/jane.png',
    dueDate: DateTime(2023, 10, 20),
    progress: 0.79,
    teamMembers: [
        'assets/avatars/team_member1.png',
        'assets/avatars/team_member2.png',
        'assets/avatars/team_member3.png',
      ],
    priority: 'basic',
    subTasks: const [
      SubTask(title: 'Research', isCompleted: true),
      SubTask(title: 'Design', isCompleted: false),
    ],
  ),
];
