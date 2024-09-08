import 'package:floor/floor.dart';

@entity
class TWRegular {
  @PrimaryKey(autoGenerate: true)
  int? id;

  /// Timestamp
  DateTime time;

  /// Message
  String? message;

  /// StackTrace
  String? stacktrace;

  /// level
  String? level;

  TWRegular(
    this.id,
    this.time,
    this.message,
    this.level,
    this.stacktrace,
  );

  factory TWRegular.optional({
    int? id,
    DateTime? time,
    String? message,
    String? level,
    String? stacktrace,
  }) =>
      TWRegular(
        id,
        time ?? DateTime.now(),
        message,
        level,
        stacktrace,
      );

  TWRegular copyWith({
    int? id,
    DateTime? time,
    String? message,
    String? level,
    String? stacktrace,
  }) {
    return TWRegular(
      id,
      time ?? DateTime.now(),
      message,
      level,
      stacktrace,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TWRegular &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          time == other.time &&
          message == other.message;

  @override
  int get hashCode => id.hashCode ^ time.hashCode ^ message.hashCode;

  @override
  String toString() {
    return 'TWRegularTable: \n {id: $id, date: $time, message: $message}';
  }
}
