part of 'lists.dart';

/// Sparse bool list based on the grouped range lists.
class SparseBoolList extends SparseList<bool> {
  SparseBoolList() : super(defaultValue: false);

  SparseBoolList.fixed(super.length) : super.fixed(defaultValue: false);

  @override
  bool operator [](int index) => super[index]!;
}
