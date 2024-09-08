import 'package:floor/floor.dart';

@entity
class TWLabel {
  @PrimaryKey(autoGenerate: true)
  int? id;

  String? title;

  String? type;

  DateTime time;

  TWLabel(
    this.id,
    this.title,
    this.type,
    this.time,
  );

  factory TWLabel.optional({
    int? id,
    String? title,
    String? type,
    DateTime? time,
  }) =>
      TWLabel(
        id,
        title,
        type,
        time ?? DateTime.now(),
      );
}
