// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treasury.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TreasuryStore on _TreasuryStore, Store {
  final _$membersAtom = Atom(name: '_TreasuryStore.members');

  @override
  List<dynamic> get members {
    _$membersAtom.reportRead();
    return super.members;
  }

  @override
  set members(List<dynamic> value) {
    _$membersAtom.reportWrite(value, super.members, () {
      super.members = value;
    });
  }

  final _$proposalsAtom = Atom(name: '_TreasuryStore.proposals');

  @override
  List<dynamic> get proposals {
    _$proposalsAtom.reportRead();
    return super.proposals;
  }

  @override
  set proposals(List<dynamic> value) {
    _$proposalsAtom.reportWrite(value, super.proposals, () {
      super.proposals = value;
    });
  }

  final _$approvalsAtom = Atom(name: '_TreasuryStore.approvals');

  @override
  List<dynamic> get approvals {
    _$approvalsAtom.reportRead();
    return super.approvals;
  }

  @override
  set approvals(List<dynamic> value) {
    _$approvalsAtom.reportWrite(value, super.approvals, () {
      super.approvals = value;
    });
  }

  final _$tipsAtom = Atom(name: '_TreasuryStore.tips');

  @override
  List<TipData> get tips {
    _$tipsAtom.reportRead();
    return super.tips;
  }

  @override
  set tips(List<TipData> value) {
    _$tipsAtom.reportWrite(value, super.tips, () {
      super.tips = value;
    });
  }

  final _$proposalCountAtom = Atom(name: '_TreasuryStore.proposalCount');

  @override
  int get proposalCount {
    _$proposalCountAtom.reportRead();
    return super.proposalCount;
  }

  @override
  set proposalCount(int value) {
    _$proposalCountAtom.reportWrite(value, super.proposalCount, () {
      super.proposalCount = value;
    });
  }

  final _$spendPeriodAtom = Atom(name: '_TreasuryStore.spendPeriod');

  @override
  int get spendPeriod {
    _$spendPeriodAtom.reportRead();
    return super.spendPeriod;
  }

  @override
  set spendPeriod(int value) {
    _$spendPeriodAtom.reportWrite(value, super.spendPeriod, () {
      super.spendPeriod = value;
    });
  }

  final _$treasuryBalanceAtom = Atom(name: '_TreasuryStore.treasuryBalance');

  @override
  TreasuryBalance? get treasuryBalance {
    _$treasuryBalanceAtom.reportRead();
    return super.treasuryBalance;
  }

  @override
  set treasuryBalance(TreasuryBalance? value) {
    _$treasuryBalanceAtom.reportWrite(value, super.treasuryBalance, () {
      super.treasuryBalance = value;
    });
  }

  final _$_TreasuryStoreActionController =
      ActionController(name: '_TreasuryStore');

  @override
  void setMembers(List<dynamic> data) {
    final _$actionInfo = _$_TreasuryStoreActionController.startAction(
        name: '_TreasuryStore.setMembers');
    try {
      return super.setMembers(data);
    } finally {
      _$_TreasuryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProposals(Map<dynamic, dynamic> data) {
    final _$actionInfo = _$_TreasuryStoreActionController.startAction(
        name: '_TreasuryStore.setProposals');
    try {
      return super.setProposals(data);
    } finally {
      _$_TreasuryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSummary(Map<dynamic, dynamic> data) {
    final _$actionInfo = _$_TreasuryStoreActionController.startAction(
        name: '_TreasuryStore.setSummary');
    try {
      return super.setSummary(data);
    } finally {
      _$_TreasuryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTips(List<TipData> data) {
    final _$actionInfo = _$_TreasuryStoreActionController.startAction(
        name: '_TreasuryStore.setTips');
    try {
      return super.setTips(data);
    } finally {
      _$_TreasuryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
members: ${members},
proposals: ${proposals},
approvals: ${approvals},
tips: ${tips},
proposalCount: ${proposalCount},
spendPeriod: ${spendPeriod},
treasuryBalance: ${treasuryBalance}
    ''';
  }
}
