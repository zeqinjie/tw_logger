import 'package:floor/floor.dart';

@entity
class TWCrash {
  @PrimaryKey(autoGenerate: true)
  int? id;

  /// Timestamp
  DateTime time;

  /// crash stack trace
  String? stacktrace;

  // crash error
  String? error;

  TWCrash(
    this.id,
    this.time,
    this.stacktrace,
    this.error,
  );

  factory TWCrash.optional({
    int? id,
    DateTime? time,
    String? stacktrace,
    String? error,
  }) =>
      TWCrash(
        id,
        time ?? DateTime.now(),
        stacktrace,
        error,
      );

  TWCrash copyWith({
    int? id,
    DateTime? time,
    String? stacktrace,
    String? error,
  }) {
    return TWCrash(
      id,
      time ?? DateTime.now(),
      stacktrace,
      error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TWCrash &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          time == other.time &&
          stacktrace == other.stacktrace &&
          error == other.error;

  @override
  int get hashCode =>
      id.hashCode ^ time.hashCode ^ stacktrace.hashCode ^ error.hashCode;

  @override
  String toString() {
    return 'TWCrashTable: \n {id: $id, date: $time, stacktrace: $stacktrace, error: $error}';
  }
}
