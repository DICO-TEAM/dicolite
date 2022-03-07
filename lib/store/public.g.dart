// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PublicStore on _PublicStore, Store {
  final _$bestNumberAtom = Atom(name: '_PublicStore.bestNumber');

  @override
  int get bestNumber {
    _$bestNumberAtom.reportRead();
    return super.bestNumber;
  }

  @override
  set bestNumber(int value) {
    _$bestNumberAtom.reportWrite(value, super.bestNumber, () {
      super.bestNumber = value;
    });
  }

  final _$_PublicStoreActionController = ActionController(name: '_PublicStore');

  @override
  void setBestNumber(int number) {
    final _$actionInfo = _$_PublicStoreActionController.startAction(
        name: '_PublicStore.setBestNumber');
    try {
      return super.setBestNumber(number);
    } finally {
      _$_PublicStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
bestNumber: ${bestNumber}
    ''';
  }
}
