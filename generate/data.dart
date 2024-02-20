import 'package:unicode_ng/src/lists/lists.dart';

import 'constants.dart';
import 'models.dart';

List<Character?> parseUnicodeData(List<String> lines) {
  bool isRangeStart(List<String> parts) {
    var name = parts[1];
    if (name.startsWith('<') && name.endsWith('>')) {
      name = name.substring(1, name.length - 1);
      final parts2 = name.split(',');
      if (parts2.length == 2) {
        if (parts2[1].trim().toLowerCase() == 'first') {
          return true;
        }
      }
    }

    return false;
  }

  final characters = <Character?>[];
  characters.length = unicodeLength;
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final parts = line.split(';');
    final index = int.parse(parts[0], radix: 16);
    var count = 1;
    if (isRangeStart(parts)) {
      final line2 = lines[++i];
      final parts2 = line2.split(';');
      final index2 = int.parse(parts2[0], radix: 16);
      count = index2 - index + 1;
    }

    for (var j = index; j < index + count; j++) {
      final character = Character(j, parts);
      characters[j] = character;
    }
  }

  return characters;
}

Map<Category, SparseBoolList> createCategories(List<Character?> characters) {
  final categories = <Category, SparseBoolList>{};

  for (final category in Category.abbrToCategory.values) {
    final list = SparseBoolList();
    list.length = unicodeLength;
    categories[category] = list;
  }

  for (final character in characters.nonNulls) {
    final category = Category.abbrToCategory[character.category];

    if (category == null) {
      throw StateError('Unknown character category: ${character.category}');
    }

    categories[category]![character.code] = true;
  }
  return categories;
}

SparseList<int> getCharacters(Map<Category, SparseBoolList> categories) {
  final characters = SparseList<int>(defaultValue: 0);

  for (final category in categories.keys) {
    final categoryCharacters = categories[category]!;
    for (final group in categoryCharacters.groups) {
      final group2 = GroupedRangeList<int>(group.start, group.end, category.id);
      characters.addGroup(group2);
    }
  }

  return characters;
}
