import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:recase/recase.dart';
import 'package:unicode_ng/src/lists/lists.dart';

import 'compress.dart';
import 'generation_helpers.dart';
import 'helpers.dart';
import 'models.dart';
import 'premade.dart';

const imports = [
  'dart:collection',
  'package:unicode_ng/src/lists/lists.dart',
];

const generalCategoriesRef = Reference('generalCategories');

Library generateLibrary(
  Map<Category, SparseBoolList> categories,
  SparseList<int> characters,
  CaseMapping caseMapping,
) =>
    Library(
      (b) => b
        ..name = 'unicode'
        ..directives.addAll(imports.map((i) => Directive.import(i)))
        ..body.addAll([
          ...generateConstants(),
          generateVariableCategories(characters),
          ...generateVariableCharacterSet(categories),
          ...generateVariableSimpleCaseMapping(caseMapping),
          ...generateIsCategoryFunctions(),
          ...generateMethodToXxxCase(caseMapping),
          ...allPremadeFunctions,
        ]),
    );

List<Spec> generateConstants() => Category.abbrToCategory.values
    .map(
      (category) =>
          declareConst(category.name.camelCase, type: const Reference('int'))
              .assign(literalNum(category.id))
              .statement,
    )
    .toList();

Spec generateVariableCategories(SparseList<int> characters) =>
    generateSparseListInt(
      generalCategoriesRef.symbol!,
      compressGroups(
        characters.groups
            .map((group) => [group.start, group.end, group.key])
            .flattened
            .toList(),
      ),
    );

List<Spec> generateVariableCharacterSet(
  Map<Category, SparseBoolList> categories,
) =>
    categories.keys
        .map(
          (category) =>
              generateCharacterSet(getCharacterSetName(category), category.id),
        )
        .toList();

List<Spec> generateVariableSimpleCaseMapping(CaseMapping caseMapping) =>
    caseMapping
        .toMap()
        .entries
        .map(
          (entry) => generateMapping(
            getSimpleCaseMappingName(entry.key),
            compressMapping(
              entry.value.entries
                  .map((e) => [e.key, e.value])
                  .flattened
                  .toList(),
            ),
          ),
        )
        .toList();

List<Spec> generateIsCategoryFunctions() => Category.abbrToCategory.values
    .map(
      (category) => generateIsCategory(
        category.name.pascalCase,
        getCharacterSetName(category),
      ),
    )
    .toList();

List<Spec> generateMethodToXxxCase(CaseMapping caseMapping) => caseMapping
    .toMap()
    .keys
    .map(
      (key) => Method(
        (b) => b
          ..name = 'to_$key'.camelCase
          ..returns = const Reference('String')
          ..requiredParameters.add(
            Parameter(
              (p) => p
                ..name = 'string'
                ..type = const Reference('String'),
            ),
          )
          ..body = toCaseRef.call([
            const Reference('string'),
            Reference(getSimpleCaseMappingName(key)),
          ]).code,
      ),
    )
    .toList();
