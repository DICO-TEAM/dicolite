// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'council.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CouncilStore on _CouncilStore, Store {
  final _$primesAtom = Atom(name: '_CouncilStore.primes');

  @override
  String get primes {
    _$primesAtom.reportRead();
    return super.primes;
  }

  @override
  set primes(String value) {
    _$primesAtom.reportWrite(value, super.primes, () {
      super.primes = value;
    });
  }

  final _$electionsInfoAtom = Atom(name: '_CouncilStore.electionsInfo');

  @override
  ElectionsInfo? get electionsInfo {
    _$electionsInfoAtom.reportRead();
    return super.electionsInfo;
  }

  @override
  set electionsInfo(ElectionsInfo? value) {
    _$electionsInfoAtom.reportWrite(value, super.electionsInfo, () {
      super.electionsInfo = value;
    });
  }

  final _$candidatesAtom = Atom(name: '_CouncilStore.candidates');

  @override
  List<ElectionData> get candidates {
    _$candidatesAtom.reportRead();
    return super.candidates;
  }

  @override
  set candidates(List<ElectionData> value) {
    _$candidatesAtom.reportWrite(value, super.candidates, () {
      super.candidates = value;
    });
  }

  final _$membersAtom = Atom(name: '_CouncilStore.members');

  @override
  List<ElectionData> get members {
    _$membersAtom.reportRead();
    return super.members;
  }

  @override
  set members(List<ElectionData> value) {
    _$membersAtom.reportWrite(value, super.members, () {
      super.members = value;
    });
  }

  final _$runnersUpAtom = Atom(name: '_CouncilStore.runnersUp');

  @override
  List<ElectionData> get runnersUp {
    _$runnersUpAtom.reportRead();
    return super.runnersUp;
  }

  @override
  set runnersUp(List<ElectionData> value) {
    _$runnersUpAtom.reportWrite(value, super.runnersUp, () {
      super.runnersUp = value;
    });
  }

  final _$checkdElectionAtom = Atom(name: '_CouncilStore.checkdElection');

  @override
  List<ElectionData> get checkdElection {
    _$checkdElectionAtom.reportRead();
    return super.checkdElection;
  }

  @override
  set checkdElection(List<ElectionData> value) {
    _$checkdElectionAtom.reportWrite(value, super.checkdElection, () {
      super.checkdElection = value;
    });
  }

  final _$allVotesAtom = Atom(name: '_CouncilStore.allVotes');

  @override
  Map<String, List<dynamic>> get allVotes {
    _$allVotesAtom.reportRead();
    return super.allVotes;
  }

  @override
  set allVotes(Map<String, List<dynamic>> value) {
    _$allVotesAtom.reportWrite(value, super.allVotes, () {
      super.allVotes = value;
    });
  }

  final _$motionsAtom = Atom(name: '_CouncilStore.motions');

  @override
  List<dynamic> get motions {
    _$motionsAtom.reportRead();
    return super.motions;
  }

  @override
  set motions(List<dynamic> value) {
    _$motionsAtom.reportWrite(value, super.motions, () {
      super.motions = value;
    });
  }

  final _$_CouncilStoreActionController =
      ActionController(name: '_CouncilStore');

  @override
  void setPrimes(String primes, {bool shouldCache = true}) {
    final _$actionInfo = _$_CouncilStoreActionController.startAction(
        name: '_CouncilStore.setPrimes');
    try {
      return super.setPrimes(primes, shouldCache: shouldCache);
    } finally {
      _$_CouncilStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setElectionsInfo(ElectionsInfo info, {bool shouldCache = true}) {
    final _$actionInfo = _$_CouncilStoreActionController.startAction(
        name: '_CouncilStore.setElectionsInfo');
    try {
      return super.setElectionsInfo(info, shouldCache: shouldCache);
    } finally {
      _$_CouncilStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCandidates(List<ElectionData> data, {bool shouldCache = true}) {
    final _$actionInfo = _$_CouncilStoreActionController.startAction(
        name: '_CouncilStore.setCandidates');
    try {
      return super.setCandidates(data, shouldCache: shouldCache);
    } finally {
      _$_CouncilStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMembers(List<ElectionData> data, {bool shouldCache = true}) {
    final _$actionInfo = _$_CouncilStoreActionController.startAction(
        name: '_CouncilStore.setMembers');
    try {
      return super.setMembers(data, shouldCache: shouldCache);
    } finally {
      _$_CouncilStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRunnersUp(List<ElectionData> data, {bool shouldCache = true}) {
    final _$actionInfo = _$_CouncilStoreActionController.startAction(
        name: '_CouncilStore.setRunnersUp');
    try {
      return super.setRunnersUp(data, shouldCache: shouldCache);
    } finally {
      _$_CouncilStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCheckdElection(List<ElectionData> data, {bool shouldCache = true}) {
    final _$actionInfo = _$_CouncilStoreActionController.startAction(
        name: '_CouncilStore.setCheckdElection');
    try {
      return super.setCheckdElection(data, shouldCache: shouldCache);
    } finally {
      _$_CouncilStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAllVotes(Map<String, List<dynamic>> data, {bool shouldCache = true}) {
    final _$actionInfo = _$_CouncilStoreActionController.startAction(
        name: '_CouncilStore.setAllVotes');
    try {
      return super.setAllVotes(data, shouldCache: shouldCache);
    } finally {
      _$_CouncilStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMotions(List<dynamic> data, {bool shouldCache = true}) {
    final _$actionInfo = _$_CouncilStoreActionController.startAction(
        name: '_CouncilStore.setMotions');
    try {
      return super.setMotions(data, shouldCache: shouldCache);
    } finally {
      _$_CouncilStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
primes: ${primes},
electionsInfo: ${electionsInfo},
candidates: ${candidates},
members: ${members},
runnersUp: ${runnersUp},
checkdElection: ${checkdElection},
allVotes: ${allVotes},
motions: ${motions}
    ''';
  }
}
