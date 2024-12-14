import 'dart:math' as math;

import 'package:vlu_project_1/core/utils/extensions/num_extensions.dart';





extension ListExtension<T> on List<T> {
  List<T> addBetweenEvery(T value) {
    List<T> r = [];
    asMap().forEach((i, e) => i < length - 1 ? r.addAll([e, value]) : r.add(e));
    return r;
  }

  // interleave merge list function
  List<T> interleave(List<T> other) {
    final result = <T>[];
    final length = math.max(this.length, other.length);
    for (var i = 0; i < length; i++) {
      if (i < this.length) {
        result.add(this[i]);
      }
      if (i < other.length) {
        result.add(other[i]);
      }
    }
    return result;
  }

  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }

  List<T> assignAll(List<T> other) {
    clear();
    addAll(other);
    return this;
  }

  T? get firstOrNull {
    try {
      return first;
    } catch (e) {
      return null;
    }
  }

  T? atOrNull(int index) {
    try {
      return this[index];
    } catch (e) {
      return null;
    }
  }

  void replaceWhere(bool Function(T item) match, T replace) {
    int index = indexWhere(match);
    if (index != -1) {
      this[index] = replace;
    }
  }

  void sort2(Comparable Function(T) getSortValue, bool isAsc) {
    sort((e1, e2) =>
        (isAsc ? 1 : -1) * getSortValue(e1).compareTo(getSortValue(e2)));
  }

  List<List<T>> split(int groupSize) {
    int groupNums = (length / groupSize).ceil();
    int realIndex(int grpIndex, int grpItemIndex) {
      return grpIndex * groupSize + grpItemIndex;
    }

    return groupNums.genList(
      (grpIndex) => (realIndex(grpIndex, groupSize - 1) < length
              ? groupSize
              : length % groupSize)
          .genList(
        (grpItemIndex) => elementAt(
          realIndex(grpIndex, grpItemIndex),
        ),
      ),
    );
  }

  void swap(int index1, index2) {
    T tmp = this[index1];
    this[index1] = this[index2];
    this[index2] = tmp;
  }

  void removeLastSafe() {
    if (isNotEmpty) {
      removeLast();
    }
  }

  List<T> clone() {
    return [...this];
  }
}

extension IterableExt<T> on Iterable<T> {
  List<TMap> mapList<TMap>(TMap Function(T item) mapper) {
    return map<TMap>(mapper).toList();
  }

  Map<K, List<T>> groupBy<K>(K Function(T e) getKey) {
    Map<K, List<T>> result = {};
    for (var item in this) {
      K key = getKey(item);
      if (result.containsKey(key)) {
        result[key]!.add(item);
      } else {
        result[key] = [item];
      }
    }
    return result;
  }

  String joinSlash() {
    return join('/ ');
  }
}

extension NullableListExtension<T> on List<T>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
