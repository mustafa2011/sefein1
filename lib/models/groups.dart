const String tableGroups = 'groups';

class GroupFields {
  static const String id = 'id';
  static const String type = 'type';

  /// values to be selected: [EXPENSE], [DAMAGE], etc.
  static const String name = 'name';

  static List<String> getGroupFields() => [id, type, name];
}

class Group {
  final int? id;
  final String type;
  final String name;

  const Group({
    this.id,
    required this.type,
    this.name = '',
  });

  Group copy({
    int? id,
    String? type,
    String? name,
  }) =>
      Group(
        id: id ?? this.id,
        type: type ?? this.type,
        name: name ?? this.name,
      );

  factory Group.fromJson(dynamic json) {
    return Group(
      id: json[GroupFields.id] as int,
      type: json[GroupFields.type] as String,
      name: json[GroupFields.name] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        GroupFields.id: id,
        GroupFields.type: type,
        GroupFields.name: name,
      };
}
