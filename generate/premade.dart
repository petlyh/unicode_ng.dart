import 'package:code_builder/code_builder.dart';

import 'constants.dart';
import 'generate.dart';

List<Spec> allPremadeFunctions = [
  toCaseCode,
  toRuneCode,
  toRunesCode,
  // generateBoolGroupCode, // unused
  generateCategoryCode,
  generateIntGroupCode,
  generateIntMappingCode,
];

const generateIntGroupRef = Reference('_generateIntGroup');

final generateIntGroupCode = Code('''
SparseList<int> ${generateIntGroupRef.symbol}(List<int> data) {  
  final list = SparseList<int>(defaultValue: 0);
  list.length = $unicodeLength;
  final length = data.length;
  var start = 0;
  var end = 0;
  for (var i = 0; i < length; i+= 3) {
    start += data[i + 0];
    end += data[i + 1];
    final key = data[i + 2];
    list.addGroup(GroupedRangeList<int>(start, end, key));
  }

  list.freeze();
  return list;
}
''');

const generateCategoryRef = Reference('_generateCategory');

final generateCategoryCode = Code('''
SparseBoolList ${generateCategoryRef.symbol}(int category) {
  final list = SparseBoolList();
  list.length = $unicodeLength;
  for (final group in (${generalCategoriesRef.symbol} as SparseList<int>).groups) {
    if (group.key == category) {
      list.addGroup(GroupedRangeList<bool>(group.start, group.end, true));
    }
  }

  list.freeze();
  return list;
}
''');

const generateBoolGroupRef = Reference('_generateBoolGroup');

final generateBoolGroupCode = Code('''
SparseBoolList ${generateBoolGroupRef.symbol}(List<int> data) {
  final list = SparseBoolList();
  list.length = $unicodeLength;
  final length = data.length;
  for (var i = 0; i < length; i += 2) {
    final start = data[i + 0];
    final end = data[i + 1];
    list.addGroup(GroupedRangeList<bool>(start, end, true));
  }

  list.freeze();
  return list;
}
''');

const generateIntMappingRef = Reference('_generateIntMapping');

final generateIntMappingCode = Code('''
Map<int, int> ${generateIntMappingRef.symbol}(List<int> data) {  
  final map = HashMap<int, int>();
  final length = data.length;
  var key = 0;
  var value = 0;
  for (var i = 0; i < length; i+= 2) {
    key += data[i + 0];
    value += data[i + 1];
    map[key] = value;
  }

  return UnmodifiableMapView<int, int>(map);
}
''');

const toRunesRef = Reference('toRunes');

final toRunesCode = Code('''
List<int> ${toRunesRef.symbol}(String string) {
  final length = string.length;
  if (length == 0) {
    return const <int>[];
  }

  final runes = List.filled(length, 0);
  var i = 0;
  var pos = 0;
  for ( ; i < length; pos++) {
    final start = string.codeUnitAt(i);
    i++;
    if ((start & 0xFC00) == 0xD800 && i < length) {
      final end = string.codeUnitAt(i);
      if ((end & 0xFC00) == 0xDC00) {
        runes[pos] = (0x10000 + ((start & 0x3FF) << 10) + (end & 0x3FF));
        i++;
      } else {
        runes[pos] = start;
      }
    } else {
      runes[pos] = start;
    }
  }

  return runes.sublist(0, pos);  
}
''');

const toRuneRef = Reference('toRune');

final toRuneCode = Code('''
int ${toRuneRef.symbol}(String string) {
  final length = string.length;
  if (length == 0) {
    throw StateError('An empty string contains no elements.');
  }

  final start = string.codeUnitAt(0);
  if (length == 1) {
    return start;
  }

  if ((start & 0xFC00) == 0xD800) {
    final end = string.codeUnitAt(1);
    if ((end & 0xFC00) == 0xDC00) {
      return (0x10000 + ((start & 0x3FF) << 10) + (end & 0x3FF));
    }
  }

  return start;
}
''');

const toCaseRef = Reference('toCase');

final toCaseCode = Code('''
String ${toCaseRef.symbol}(String string, Map<int, int> mapping) {
  final runes = ${toRunesRef.symbol}(string);
  final length = runes.length;
  for (var i = 0; i < length; i++) {
    final character = mapping[runes[i]];
    if (character != null) {
      runes[i] = character;
    }
  }
  return String.fromCharCodes(runes);
}
''');
