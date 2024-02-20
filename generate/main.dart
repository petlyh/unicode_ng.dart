import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';
import 'data.dart';
import 'generate.dart';
import 'models.dart';

void main(List<String> args) async {
  if (args.isEmpty) {
    // ignore: avoid_print
    print('Supply filename as first argument');
    return;
  }

  final data = await fetchData(unicodeDataUrl);
  final rawCharacters = parseUnicodeData(data);

  final categories = createCategories(rawCharacters);
  final characters = getCharacters(categories);
  final caseMapping = CaseMapping.fromCharacters(rawCharacters);

  final library = generateLibrary(categories, characters, caseMapping);
  final filename = args[0];
  await writeLibrary(filename, library);
}

Future<List<String>> fetchData(String url) async {
  final response = await http.read(Uri.parse(url));
  final data =
      response.replaceAll('\r\n', '\n').replaceAll('\r', '\n').split('\n');

  if (data.last.isEmpty) {
    data.removeLast();
  }

  return data;
}

Future<void> writeLibrary(String filename, Library library) async {
  final emitter = DartEmitter.scoped();
  final source = DartFormatter().format('${library.accept(emitter)}');
  await File(filename).writeAsString(source);
}
