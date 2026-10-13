import 'package:hive/hive.dart';
part 'focus_session_log.g.dart';

// Hive ko bol raha hai: “Ye ek Hive-storable object type hai.”
@HiveType(typeId:1)
class FocusSessionLog {
  // Hive ko bol raha hai: “Is property ko field number 0 ke naam se store karo.”
  @HiveField(0)
  DateTime startTime;
  @HiveField(1)
  DateTime endTime;
  @HiveField(2)
  int plannedDurationMinutes;
  @HiveField(3)
  int pauseCount;
  @HiveField(4)
  int backgroundExitCount;
  @HiveField(5)
  int totalBackgroundSeconds;
  @HiveField(6)
  String taskId;
  @HiveField(7)
  int actualFocusedSeconds;

  FocusSessionLog({
    required this.startTime,
    required this.endTime,
    required this.plannedDurationMinutes,
    required this.pauseCount,
    required this.backgroundExitCount,
    required this.totalBackgroundSeconds,
    required this.taskId,
    required this.actualFocusedSeconds,
  });
}