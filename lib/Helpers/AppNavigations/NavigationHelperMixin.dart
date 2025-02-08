// ignore_for_file: file_names

part of 'NavigationHelpers.dart';

mixin _$BottomNavigationConfig on _BottomNavConfigMobxBase, Store {
  late final _$currentIndexAtom =
      Atom(name: '_BottomNavConfigMobxBase.currentIndex');

  @override
  int get currentIndex {
    _$currentIndexAtom.reportRead();
    return super.currentIndex;
  }

  @override
  set currentIndex(int value) {
    _$currentIndexAtom.reportWrite(value, super.currentIndex, () {
      super.currentIndex = value;
    });
  }

  @override
  String toString() {
    return '''
currentIndex: ${currentIndex}
    ''';
  }
}

