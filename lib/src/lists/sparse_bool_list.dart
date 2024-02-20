part of lists;

/// Sparse bool list based on the grouped range lists.
class SparseBoolList extends SparseList<bool> {
  SparseBoolList() : super(defaultValue: false);

  SparseBoolList.fixed(int length) : super.fixed(length, defaultValue: false);

  @override
  bool operator [](int index) => super[index]!;
}
