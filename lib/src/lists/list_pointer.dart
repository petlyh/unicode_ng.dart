part of 'lists.dart';

/// List which are points to the other list at the specified index.
/// var plist = new ListPointer(base, 20);
/// print(plist[-1]); // base[19]
/// print(plist[0]);  // base[20]
class ListPointer<T> extends Object with ListMixin<T> {
  final List<T> base;

  int offset = 0;

  /// Creates the list pointer.
  ///
  /// Parameters:
  ///   [List] base
  ///   Base list to be pointed.
  ///
  ///   [int] offset
  ///   Offset in the base list.
  ListPointer(this.base, [this.offset = 0]);

  @override
  int get length => base.length - offset;

  @override
  set length(int length) {
    throw UnsupportedError('set length');
  }

  @override
  ListPointer<T> operator +(Object other) {
    if (other is int) {
      return ListPointer<T>(base, offset + other);
    }

    throw ArgumentError.value(other, 'other');
  }

  ListPointer<T> operator -(Object other) {
    if (other is int) {
      return ListPointer<T>(base, offset - other);
    }

    throw ArgumentError.value(other, 'other');
  }

  bool operator <(Object other) {
    if (other is ListPointer) {
      if (identical(base, other.base)) {
        return offset < other.offset;
      }
    } else if (other is List) {
      if (identical(base, other)) {
        return offset < 0;
      }
    }

    return false;
  }

  bool operator <=(Object other) {
    if (other is ListPointer) {
      if (identical(base, other.base)) {
        return offset <= other.offset;
      }
    } else if (other is List) {
      if (identical(base, other)) {
        return offset <= 0;
      }
    }

    return false;
  }

  @override
  bool operator ==(Object other) {
    if (other is ListPointer) {
      if (identical(base, other.base)) {
        if (offset == other.offset) {
          return true;
        }
      }
    } else if (other is List) {
      if (identical(base, other)) {
        if (offset == 0) {
          return true;
        }
      }
    }

    return false;
  }

  @override
  int get hashCode => Object.hashAll([base, offset]);

  bool operator >(Object other) {
    if (other is ListPointer) {
      if (identical(base, other.base)) {
        return offset > other.offset;
      }
    } else if (other is List) {
      if (identical(base, other)) {
        return offset > 0;
      }
    }

    return false;
  }

  bool operator >=(Object other) {
    if (other is ListPointer) {
      if (identical(base, other.base)) {
        return offset >= other.offset;
      }
    } else if (other is List) {
      if (identical(base, other)) {
        return offset >= 0;
      }
    }

    return false;
  }

  @override
  T operator [](int index) {
    return base[offset + index];
  }

  @override
  void operator []=(int index, T value) {
    base[offset + index] = value;
  }

  ListPointer<T> increment(int n) {
    return ListPointer<T>(base, offset + n);
  }
}
