import 'package:test/test.dart';
import 'package:unicode_ng/src/lists/lists.dart';

void main() {
  test('', () {
    testAddGroup();
    testClear();
    testGetAllSpace();
    testGetAlignedGroups();
    testGetGroups();
    testGetIndexes();
    testLength();
    testRemoveValues();
    testResetValues();
    testSetDifferent();
    testSetTheSame();
    testSetWithStep();
    testsetGroupDifferent();
    testSetGroupTheSame();
    testStartAndEnd();
    testTrim();
  });
}

const int failureValue = 13;

const int successValue = 41;

GroupedRangeList<T> grp<T>(int start, int end, T value) {
  return GroupedRangeList<T>(start, end, value);
}

int patternLength(List<bool> pattern) {
  var length = 0;
  for (var i = 0; i < pattern.length; i++) {
    if (pattern[i]) {
      length = i + 1;
    }
  }

  return length;
}

RangeList rng(int start, int end) {
  return RangeList(start, end);
}

void testAddGroup() {
  const subject = 'SparseList.AddGroup()';
  const depth = 5;
  void action(List<bool> first, List<bool> second) {
    final sparse = SparseList<int>();
    final ranges = _patternToRanges(first);
    // Add group
    for (final range in ranges) {
      sparse.addGroup(grp(range.start, range.end, successValue));
    }

    // Test group count
    final groupCount = sparse.groupCount;
    expect(groupCount, ranges.length, reason: subject);

    // Test groups
    for (var i = 0; i < groupCount; i++) {
      final group = sparse.groups[i];
      final range = ranges[i];
      expect(group.start, range.start, reason: subject);
      expect(group.end, range.end, reason: subject);
    }

    // Test length
    final length = patternLength(first);
    expect(length, sparse.length, reason: subject);

    // Test values
    for (var i = 0; i < first.length; i++) {
      if (first[i]) {
        expect(sparse[i], successValue, reason: subject);
      }
    }
  }

  _walk(depth, action);
}

void testClear() {
  const subject = 'SparseList.clear()';
  //
  final sparse = SparseList<int>();
  sparse.length = 3;
  sparse.setGroup(grp(0, 2, 1));
  sparse.clear();
  final actual = sparse;
  expect(actual, <int>[], reason: subject);
  final groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
}

void testGetAlignedGroups() {
  const subject = 'SparseList.testGetAlignedGroups()';
  const depth = 5;
  void action(List<bool> first, List<bool> second) {
    final sparse = SparseList<int>(defaultValue: failureValue);
    var ranges = _patternToRanges(first);
    // Add group
    for (final range in ranges) {
      sparse.addGroup(grp(range.start, range.end, successValue));
    }

    ranges = _patternToRanges(second);
    for (final range in ranges) {
      final groups = sparse.getAlignedGroups(range);
      var min = -1;
      var max = -1;
      var start = -1;
      var end = -1;
      for (final group in groups) {
        if (min == -1) {
          min = range.start;
        } else if (min > range.start) {
          min = range.start;
        }

        if (max == -1) {
          max = range.end;
        } else if (max < range.end) {
          max = range.end;
        }

        if (start == -1) {
          start = group.start;
        } else if (start > group.start) {
          start = group.start;
        }

        if (end == -1) {
          end = group.end;
        } else if (end < group.end) {
          end = group.end;
        }

        final indexes = sparse.getIndexes().toList();
        if (indexes.isEmpty) {
          // Sparse list is empty
          expect(group.key, failureValue, reason: subject);
        } else {
          // Sparse list is not empty
          final listStart = indexes.first;
          final listEnd = indexes.last;
          //
          if (group.start < listStart) {
            expect(group.key, failureValue, reason: subject);
          }

          if (group.start >= listStart && group.start <= listStart) {
            expect(group.key, successValue, reason: subject);
          }

          if (group.start > listEnd) {
            expect(group.key, failureValue, reason: subject);
          }
        }
      }

      // Test alignment in specified range
      expect(start, min, reason: subject);
      expect(end, max, reason: subject);
    }
  }

  _walk(depth, action);
}

void testGetAllSpace() {
  const subject = 'SparseList.testAllSpace()';
  final sparse = SparseList<int>(defaultValue: failureValue);
  sparse.length = 10;
  sparse.addGroup(grp(2, 3, successValue));
  sparse.addGroup(grp(7, 8, successValue));
  final space = sparse.getAllSpace(rng(0, 10));
  expect(
    space,
    [
      [0, 1],
      [2, 3],
      [4, 5, 6],
      [7, 8],
      [9, 10],
    ],
    reason: subject,
  );
}

void testGetGroups() {
  const subject = 'SparseList.getGroups()';
  //
  var sparse = SparseList<int>();
  sparse.addGroup(grp(0, 0, 1));
  sparse.addGroup(grp(2, 2, 1));
  sparse.addGroup(grp(4, 4, 1));
  var groups = sparse.getGroups(rng(0, 4)).toList();
  var actual = groups;
  expect(
    actual,
    [
      [0],
      [2],
      [4],
    ],
    reason: subject,
  );
  //
  groups = sparse.getGroups(rng(0, 0)).toList();
  actual = groups;
  expect(
    actual,
    [
      [0],
    ],
    reason: subject,
  );
  //
  groups = sparse.getGroups(rng(0, 2)).toList();
  actual = groups;
  expect(
    actual,
    [
      [0],
      [2],
    ],
    reason: subject,
  );
  //
  groups = sparse.getGroups(rng(2, 2)).toList();
  actual = groups;
  expect(
    actual,
    [
      [2],
    ],
    reason: subject,
  );
  //
  groups = sparse.getGroups(rng(2, 4)).toList();
  actual = groups;
  expect(
    actual,
    [
      [2],
      [4],
    ],
    reason: subject,
  );
  //
  sparse = SparseList<int>();
  sparse.addGroup(grp(0, 2, 1));
  groups = sparse.getGroups(rng(1, 1)).toList();
  actual = groups;
  expect(
    actual,
    [
      [0, 1, 2],
    ],
    reason: subject,
  );
  // Get all groups
  sparse = SparseList<int>();
  sparse.addGroup(grp(0, 2, 1));
  groups = sparse.getGroups().toList();
  actual = groups;
  expect(
    actual,
    [
      [0, 1, 2],
    ],
    reason: subject,
  );
  // From empty list
  sparse = SparseList<int>();
  groups = sparse.getGroups(rng(0, 0)).toList();
  actual = groups;
  expect(actual, <GroupedRangeList<int>>[], reason: subject);
  // From empty list
  sparse = SparseList<int>();
  groups = sparse.getGroups(rng(1, 2)).toList();
  actual = groups;
  expect(actual, <GroupedRangeList<int>>[], reason: subject);
}

void testGetIndexes() {
  const subject = 'SparseList.getIndexes()';
  //
  var sparse = SparseList<int>();
  sparse.addGroup(grp(2, 4, 1));
  var actual = sparse.getIndexes();
  expect(actual, [2, 3, 4], reason: subject);
  //
  sparse = SparseList<int>();
  sparse.addGroup(grp(2, 4, 1));
  sparse.addGroup(grp(6, 8, 1));
  actual = sparse.getIndexes();
  expect(actual, [2, 3, 4, 6, 7, 8], reason: subject);
}

void testLength() {
  const subject = 'SparseList.length=';
  //
  var sparse = SparseList<int>();
  sparse.length = 10;
  sparse.setGroup(grp(0, 9, 1));
  sparse.length = 3;
  var actual = sparse;
  expect(actual, [1, 1, 1], reason: subject);
  var groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  //
  sparse = SparseList<int>();
  sparse.add(1);
  sparse.length = 3;
  actual = sparse;
  expect(actual, [1, null, null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
}

void testRemoveValues() {
  const subject = 'SparseList.removeValues()';
  var sparse = SparseList<int>();
  sparse.length = 3;
  sparse.removeValues(rng(0, 2));
  var actual = sparse;
  expect(actual, <int>[], reason: subject);
  var groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  var actualLength = sparse.length;
  expect(actualLength, 0, reason: subject);
  //
  sparse = SparseList<int>();
  sparse.addGroup(grp(0, 2, 1));
  sparse.removeValues(rng(0, 2));
  actual = sparse;
  expect(actual, <int>[], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 0, reason: subject);
  //
  sparse = SparseList<int>();
  sparse.length = 3;
  sparse.removeValues(rng(1, 2));
  actual = sparse;
  expect(actual, [null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 1, reason: subject);
  //
  sparse = SparseList<int>();
  sparse.addGroup(grp(0, 2, 1));
  sparse.removeValues(rng(1, 2));
  actual = sparse;
  expect(actual, [1], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 1, reason: subject);
  //
  sparse = SparseList<int>();
  sparse.length = 3;
  sparse.removeValues(rng(0, 1));
  actual = sparse;
  expect(actual, <int>[], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 0, reason: subject);
  //
  sparse = SparseList<int>();
  sparse.addGroup(grp(0, 2, 1));
  sparse.removeValues(rng(0, 1));
  actual = sparse;
  expect(actual, [null, null, 1], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 3, reason: subject);
  //
  sparse = SparseList<int>();
  sparse.length = 3;
  sparse.setGroup(grp(0, 2, 1));
  sparse.removeValues(rng(1, 2));
  actual = sparse;
  expect(actual, [1], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 1, reason: subject);
  //
  sparse = SparseList<int>();
  sparse.length = 3;
  sparse.setGroup(grp(0, 2, 1));
  sparse.removeValues(rng(1, 1));
  actual = sparse;
  expect(actual, [1, null, 1], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 3, reason: subject);
  // Out of bounds
  sparse = SparseList<int>();
  sparse.length = 5;
  sparse.setGroup(grp(2, 4, 1));
  sparse.removeValues(rng(0, 5));
  actual = sparse;
  expect(actual, <int>[], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 0, reason: subject);
  // Out of bounds
  sparse = SparseList<int>();
  sparse.length = 5;
  sparse.setGroup(grp(0, 1, 1));
  sparse.setGroup(grp(3, 4, 1));
  sparse.removeValues(rng(0, 5));
  actual = sparse;
  expect(actual, <int>[], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 0, reason: subject);
  // Decrease length
  sparse = SparseList<int>();
  sparse.length = 2;
  sparse[1] = 1;
  sparse.removeValues(rng(4, 6));
  actual = sparse;
  expect(actual, [null, 1], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 2, reason: subject);
  // After last
  sparse = SparseList<int>();
  sparse.length = 3;
  sparse.removeValues(rng(5, 7));
  actual = sparse;
  expect(actual, [null, null, null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 3, reason: subject);
}

void testResetValues() {
  const subject = 'SparseList.resetValues()';
  const depth = 5;
  void action(List<bool> first, List<bool> second) {
    final sparse = SparseList<int>.fixed(depth);
    // Set values
    for (var i = 0; i < depth; i++) {
      if (first[i]) {
        sparse[i] = 1;
      }
    }

    final ranges = _patternToRanges(second);
    // Reset values
    for (final range in ranges) {
      sparse.resetValues(range);
    }

    // Test values
    for (final range in ranges) {
      for (var i = range.start; i <= range.end; i++) {
        final actual = sparse[i];
        expect(actual, null, reason: subject);
      }
    }
  }

  _walk(depth, action);
}

void testSetDifferent() {
  const subject = 'SparseList.[]';
  /*
   * -
   * -
   */
  var sparse = SparseList<String>.fixed(1);
  sparse[0] = '1';
  sparse[0] = '2';
  var actual = sparse;
  expect(actual, ['2'], reason: subject);
  var groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * --
   * -
   */
  sparse = SparseList<String>.fixed(2);
  sparse[0] = '1';
  sparse[1] = '1';
  sparse[0] = '2';
  actual = sparse;
  expect(actual, ['2', '1'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * -
   * --
   */
  sparse = SparseList<String>.fixed(2);
  sparse[0] = '1';
  sparse[0] = '2';
  sparse[1] = '2';
  actual = sparse;
  expect(actual, ['2', '2'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * -
   *  -
   */
  sparse = SparseList<String>.fixed(2);
  sparse[0] = '1';
  sparse[1] = '2';
  actual = sparse;
  expect(actual, ['1', '2'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * --
   *  -
   */
  sparse = SparseList<String>.fixed(2);
  sparse[0] = '1';
  sparse[1] = '1';
  sparse[1] = '2';
  actual = sparse;
  expect(actual, ['1', '2'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * ---
   *  -
   */
  sparse = SparseList<String>.fixed(3);
  sparse[0] = '1';
  sparse[1] = '1';
  sparse[2] = '1';
  sparse[1] = '2';
  actual = sparse;
  expect(actual, ['1', '2', '1'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 3, reason: subject);
  /*
   * ---
   *  --
   */
  sparse = SparseList<String>.fixed(3);
  sparse[0] = '1';
  sparse[1] = '1';
  sparse[2] = '1';
  sparse[1] = '2';
  sparse[2] = '2';
  actual = sparse;
  expect(actual, ['1', '2', '2'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * ---
   *  ---
   */
  sparse = SparseList<String>.fixed(4);
  sparse[0] = '1';
  sparse[1] = '1';
  sparse[2] = '1';
  sparse[1] = '2';
  sparse[2] = '2';
  sparse[3] = '2';
  actual = sparse;
  expect(actual, ['1', '2', '2', '2'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * - - -
   *  ---
   */
  sparse = SparseList<String>.fixed(5);
  sparse[0] = '1';
  sparse[2] = '1';
  sparse[4] = '1';
  sparse[1] = '2';
  sparse[2] = '2';
  sparse[3] = '2';
  actual = sparse;
  expect(actual, ['1', '2', '2', '2', '1'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 3, reason: subject);
}

void testsetGroupDifferent() {
  const subject = 'SparseList.setGroup()';
  /*
   * -
   * -
   */
  var sparse = SparseList<String>.fixed(1);
  sparse.setGroup(grp(0, 0, '1'));
  sparse.setGroup(grp(0, 0, '2'));
  var actual = sparse;
  expect(actual, ['2'], reason: subject);
  var groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * --
   * -
   */
  sparse = SparseList<String>.fixed(2);
  sparse.setGroup(grp(0, 1, '1'));
  sparse.setGroup(grp(0, 0, '2'));
  actual = sparse;
  expect(actual, ['2', '1'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * -
   * --
   */
  sparse = SparseList<String>.fixed(2);
  sparse.setGroup(grp(0, 0, '1'));
  sparse.setGroup(grp(0, 1, '2'));
  actual = sparse;
  expect(actual, ['2', '2'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * -
   *  -
   */
  sparse = SparseList<String>.fixed(2);
  sparse.setGroup(grp(0, 0, '1'));
  sparse.setGroup(grp(1, 1, '2'));
  actual = sparse;
  expect(actual, ['1', '2'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * --
   *  -
   */
  sparse = SparseList<String>.fixed(2);
  sparse.setGroup(grp(0, 1, '1'));
  sparse.setGroup(grp(1, 1, '2'));
  actual = sparse;
  expect(actual, ['1', '2'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * ---
   *  -
   */
  sparse = SparseList<String>.fixed(3);
  sparse.setGroup(grp(0, 2, '1'));
  sparse.setGroup(grp(1, 1, '2'));
  actual = sparse;
  expect(actual, ['1', '2', '1'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 3, reason: subject);
  /*
   * ---
   *  --
   */
  sparse = SparseList<String>.fixed(3);
  sparse.setGroup(grp(0, 2, '1'));
  sparse.setGroup(grp(1, 2, '2'));
  actual = sparse;
  expect(actual, ['1', '2', '2'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * ---
   *  ---
   */
  sparse = SparseList<String>.fixed(4);
  sparse.setGroup(grp(0, 2, '1'));
  sparse.setGroup(grp(1, 3, '2'));
  actual = sparse;
  expect(actual, ['1', '2', '2', '2'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * - - -
   *  ---
   */
  sparse = SparseList<String>.fixed(5);
  sparse.setGroup(grp(0, 4, '1'));
  sparse.setGroup(grp(1, 3, '2'));
  actual = sparse;
  expect(actual, ['1', '2', '2', '2', '1'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 3, reason: subject);
}

void testSetGroupTheSame() {
  const subject = 'SparseList.setGroup()';
  /*
   * -
   * -
   */
  var sparse = SparseList<String>.fixed(1);
  sparse.setGroup(grp(0, 0, '1'));
  var actual = sparse;
  expect(actual, ['1'], reason: subject);
  var groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * -
   *
   */
  sparse = SparseList<String>.fixed(1);
  actual = sparse;
  expect(actual, [null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  /*
   * --
   * -
   */
  sparse = SparseList<String>.fixed(2);
  sparse.setGroup(grp(0, 0, '1'));
  actual = sparse;
  expect(actual, ['1', null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * --
   *  -
   */
  sparse = SparseList<String>.fixed(2);
  sparse.setGroup(grp(1, 1, '1'));
  actual = sparse;
  expect(actual, [null, '1'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * ---
   *  -
   */
  sparse = SparseList<String>.fixed(3);
  sparse.setGroup(grp(1, 1, '1'));
  actual = sparse;
  expect(actual, [null, '1', null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * ---
   *  --
   */
  sparse = SparseList<String>.fixed(3);
  sparse.setGroup(grp(1, 2, '1'));
  actual = sparse;
  expect(actual, [null, '1', '1'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * ---
   *  ---
   */
  sparse = SparseList<String>.fixed(4);
  sparse.setGroup(grp(1, 3, '1'));
  actual = sparse;
  expect(actual, [null, '1', '1', '1'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  //
  sparse = SparseList<String>.fixed(2, defaultValue: '2');
  sparse.setGroup(grp(0, 1, '1'));
  sparse.setGroup(grp(0, 0, '2'));
  actual = sparse;
  expect(actual, ['2', '1'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  //
  sparse = SparseList<String>.fixed(3, defaultValue: '2');
  sparse.setGroup(grp(0, 2, '1'));
  sparse.setGroup(grp(1, 1, '2'));
  actual = sparse;
  expect(actual, ['1', '2', '1'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  //
  sparse = SparseList<String>.fixed(3, defaultValue: '2');
  sparse.setGroup(grp(0, 2, '1'));
  sparse.setGroup(grp(0, 2, '2'));
  actual = sparse;
  expect(actual, ['2', '2', '2'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
}

void testSetTheSame() {
  const subject = 'SparseList.[]';
  /*
   * -
   * -
   */
  var sparse = SparseList<String>.fixed(1);
  sparse[0] = '1';
  var actual = sparse;
  expect(actual, ['1'], reason: subject);
  var groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * --
   * -
   */
  sparse = SparseList<String>.fixed(2);
  sparse[0] = '1';
  actual = sparse;
  expect(actual, ['1', null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * --
   *  -
   */
  sparse = SparseList<String>.fixed(2);
  sparse[1] = '1';
  actual = sparse;
  expect(actual, [null, '1'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * ---
   *  -
   */
  sparse = SparseList<String>.fixed(3);
  sparse[1] = '1';
  actual = sparse;
  expect(actual, [null, '1', null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * ---
   *  --
   */
  sparse = SparseList<String>.fixed(3);
  sparse[1] = '1';
  sparse[2] = '1';
  actual = sparse;
  expect(actual, [null, '1', '1'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * ---
   *  ---
   */
  sparse = SparseList<String>.fixed(4);
  sparse[1] = '1';
  sparse[2] = '1';
  sparse[3] = '1';
  actual = sparse;
  expect(actual, [null, '1', '1', '1'], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
}

void testSetWithStep() {
  const count = 10000;
  const maxStep = count;
  for (var step = 1; step < maxStep; step++) {
    final sparseList = SparseList.fixed(count);
    final stepList = StepList(0, count - 1, step);
    for (final i in stepList) {
      sparseList[i] = true;
      expect(true, sparseList[i], reason: 'SparseList[]');
    }
  }
}

void testStartAndEnd() {
  var sparse = SparseList<int>();
  var actual = sparse.start;
  expect(actual, null, reason: 'Sparse.start');
  actual = sparse.end;
  expect(actual, null, reason: 'Sparse.end');
  //
  sparse = SparseList<int>();
  sparse.addGroup(grp(1, 3, 1));
  actual = sparse.start;
  expect(actual, 1, reason: 'Sparse.start');
  actual = sparse.end;
  expect(actual, 3, reason: 'Sparse.end');
}

void testTrim() {
  const subject = 'SparseList.addGroup()';
  //
  var sparse = SparseList<int>();
  sparse.length = 3;
  sparse.trim();
  var actual = sparse;
  expect(actual, <int>[], reason: subject);
  var groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  var length = sparse.length;
  expect(length, 0, reason: subject);
  //
  sparse = SparseList<int>();
  sparse.length = 3;
  sparse[0] = 1;
  sparse.trim();
  actual = sparse;
  expect(actual, [1], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  length = sparse.length;
  expect(length, 1, reason: subject);
  //
  sparse = SparseList<int>();
  sparse.length = 3;
  sparse[2] = 1;
  sparse.trim();
  actual = sparse;
  expect(actual, [null, null, 1], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  length = sparse.length;
  expect(length, 3, reason: subject);
}

List<RangeList> _patternToRanges(List<bool> pattern) {
  final ranges = <RangeList>[];
  final length = pattern.length;
  int? start;
  for (var i = 0; i < length; i++) {
    if (!pattern[i]) {
      if (start != null) {
        ranges.add(rng(start, i - 1));
        start = null;
      }
    } else {
      start ??= i;
    }
  }

  if (start != null) {
    ranges.add(rng(start, length - 1));
  }

  return ranges;
}

void _walk(
  int depth,
  void Function(List<bool> first, List<bool> second) action,
) {
  final count = 1 << depth;
  for (var i = 0; i < count; i++) {
    final first = List<bool>.filled(depth, false);
    var flag = i;
    for (var bit = 0; bit < depth; bit++) {
      if (flag & 1 != 0) {
        first[bit] = true;
      }

      flag >>= 1;
    }

    for (var j = 0; j < count; j++) {
      final second = List<bool>.filled(depth, false);
      var flag = j;
      for (var bit = 0; bit < depth; bit++) {
        if (flag & 1 != 0) {
          second[bit] = true;
        }

        flag >>= 1;
      }

      action(first, second);
    }
  }
}
