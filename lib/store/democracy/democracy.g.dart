// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'democracy.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DemocracyStore on _DemocracyStore, Store {
  final _$democracyInfoAtom = Atom(name: '_DemocracyStore.democracyInfo');

  @override
  DemocracyInfo? get democracyInfo {
    _$democracyInfoAtom.reportRead();
    return super.democracyInfo;
  }

  @override
  set democracyInfo(DemocracyInfo? value) {
    _$democracyInfoAtom.reportWrite(value, super.democracyInfo, () {
      super.democracyInfo = value;
    });
  }

  final _$referendumsAtom = Atom(name: '_DemocracyStore.referendums');

  @override
  List<ReferendumData> get referendums {
    _$referendumsAtom.reportRead();
    return super.referendums;
  }

  @override
  set referendums(List<ReferendumData> value) {
    _$referendumsAtom.reportWrite(value, super.referendums, () {
      super.referendums = value;
    });
  }

  final _$proposalsAtom = Atom(name: '_DemocracyStore.proposals');

  @override
  List<ProposalData> get proposals {
    _$proposalsAtom.reportRead();
    return super.proposals;
  }

  @override
  set proposals(List<ProposalData> value) {
    _$proposalsAtom.reportWrite(value, super.proposals, () {
      super.proposals = value;
    });
  }

  final _$dispatchQueueAtom = Atom(name: '_DemocracyStore.dispatchQueue');

  @override
  List<ProposalData> get dispatchQueue {
    _$dispatchQueueAtom.reportRead();
    return super.dispatchQueue;
  }

  @override
  set dispatchQueue(List<ProposalData> value) {
    _$dispatchQueueAtom.reportWrite(value, super.dispatchQueue, () {
      super.dispatchQueue = value;
    });
  }

  final _$nextExternalAtom = Atom(name: '_DemocracyStore.nextExternal');

  @override
  ExternalData? get nextExternal {
    _$nextExternalAtom.reportRead();
    return super.nextExternal;
  }

  @override
  set nextExternal(ExternalData? value) {
    _$nextExternalAtom.reportWrite(value, super.nextExternal, () {
      super.nextExternal = value;
    });
  }

  final _$_DemocracyStoreActionController =
      ActionController(name: '_DemocracyStore');

  @override
  void setDemocracyInfo(DemocracyInfo data, {bool shouldCache = true}) {
    final _$actionInfo = _$_DemocracyStoreActionController.startAction(
        name: '_DemocracyStore.setDemocracyInfo');
    try {
      return super.setDemocracyInfo(data, shouldCache: shouldCache);
    } finally {
      _$_DemocracyStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setReferendums(List<ReferendumData> data, {bool shouldCache = true}) {
    final _$actionInfo = _$_DemocracyStoreActionController.startAction(
        name: '_DemocracyStore.setReferendums');
    try {
      return super.setReferendums(data, shouldCache: shouldCache);
    } finally {
      _$_DemocracyStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProposals(List<ProposalData> data, {bool shouldCache = true}) {
    final _$actionInfo = _$_DemocracyStoreActionController.startAction(
        name: '_DemocracyStore.setProposals');
    try {
      return super.setProposals(data, shouldCache: shouldCache);
    } finally {
      _$_DemocracyStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDispatchQueue(List<ProposalData> data, {bool shouldCache = true}) {
    final _$actionInfo = _$_DemocracyStoreActionController.startAction(
        name: '_DemocracyStore.setDispatchQueue');
    try {
      return super.setDispatchQueue(data, shouldCache: shouldCache);
    } finally {
      _$_DemocracyStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNextExternal(ExternalData data, {bool shouldCache = true}) {
    final _$actionInfo = _$_DemocracyStoreActionController.startAction(
        name: '_DemocracyStore.setNextExternal');
    try {
      return super.setNextExternal(data, shouldCache: shouldCache);
    } finally {
      _$_DemocracyStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
democracyInfo: ${democracyInfo},
referendums: ${referendums},
proposals: ${proposals},
dispatchQueue: ${dispatchQueue},
nextExternal: ${nextExternal}
    ''';
  }
}
