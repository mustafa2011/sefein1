import 'dart:convert';

class Tag {
  final int tag;
  final String value;

  Tag(this.tag, this.value) {
    if (value.isEmpty) {
      throw Exception("Value cannot be null or empty");
    }
  }

  int getTag() => tag;

  String getValue() => value;

  int getLength() {
    List<int> bytes = utf8.encode(value);
    return bytes.length;
  }
}
