import 'package:code_builder/code_builder.dart';

import 'premade.dart';

Spec generateSparseListInt(String name, List<int> data) =>
    declareFinal(name, type: const Reference('List<int?>'))
        .assign(generateIntGroupRef.call([literalList(data)]))
        .statement;

Spec generateCharacterSet(String name, int id) =>
    declareFinal(name, type: const Reference('List<bool?>'))
        .assign(generateCategoryRef.call([literalNum(id)]))
        .statement;

Spec generateMapping(String name, List<int> data) =>
    declareFinal(name, type: const Reference('Map<int, int>'))
        .assign(generateIntMappingRef.call([literalList(data)]))
        .statement;

Spec generateIsCategory(String name, String characterSet) => Method((b) => b
  ..name = 'is$name'
  ..returns = const Reference('bool')
  ..requiredParameters.add(Parameter((b) => b
    ..name = 'character'
    ..type = const Reference('int')))
  ..body = Reference(characterSet)
      .index(const Reference('character'))
      .nullChecked
      .code);
