import 'package:test/test.dart';
import 'package:unicode_ng/src/lists/lists.dart';

void main() {
  test('', testContent);
}

FilledList<String> list(int length, String fill) => FilledList(length, fill);

void testContent() {
  final result = list(5, '1');
  expect(result, ['1', '1', '1', '1', '1'], reason: 'FilledList');
}
