const String tableSettingsExt = 'settings_ext';

class SettingExtFields {
  // static const String vatNumber = 'vatNumber';
  static const String id = '_id';
  static const String terms1 = 'terms1';
  static const String terms2 = 'terms2';
  static const String terms3 = 'terms3';
  static const String terms4 = 'terms4';
  static const String terms5 = 'terms5';

  static final List<String> values = [
    id,
    terms1,
    terms2,
    terms3,
    terms4,
    terms5
  ];
}

class SettingExt {
  final int? id;
  final String terms1;
  final String terms2;
  final String terms3;
  final String terms4;
  final String terms5;

  const SettingExt({
    this.id,
    this.terms1 = '',
    this.terms2 = '',
    this.terms3 = '',
    this.terms4 = '',
    this.terms5 = '',
  });

  SettingExt copy({
    int? id,
    String? terms1,
    String? terms2,
    String? terms3,
    String? terms4,
    String? terms5,
  }) =>
      SettingExt(
        id: id ?? this.id,
        terms1: terms1 ?? this.terms1,
        terms2: terms2 ?? this.terms2,
        terms3: terms3 ?? this.terms3,
        terms4: terms4 ?? this.terms4,
        terms5: terms5 ?? this.terms5,
      );

  factory SettingExt.fromJson(dynamic json) {
    return SettingExt(
      id: json[SettingExtFields.id] as int,
      terms1: json[SettingExtFields.terms1] as String,
      terms2: json[SettingExtFields.terms2] as String,
      terms3: json[SettingExtFields.terms3] as String,
      terms4: json[SettingExtFields.terms4] as String,
      terms5: json[SettingExtFields.terms5] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        SettingExtFields.id: id,
        SettingExtFields.terms1: terms1,
        SettingExtFields.terms2: terms2,
        SettingExtFields.terms3: terms3,
        SettingExtFields.terms4: terms4,
        SettingExtFields.terms5: terms5,
      };
}
