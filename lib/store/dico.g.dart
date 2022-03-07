// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dico.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DicoStore on _DicoStoreBase, Store {
  Computed<List<CurrencyModel>>? _$tokensSortComputed;

  @override
  List<CurrencyModel> get tokensSort => (_$tokensSortComputed ??=
          Computed<List<CurrencyModel>>(() => super.tokensSort,
              name: '_DicoStoreBase.tokensSort'))
      .value;
  Computed<List<CurrencyModel>>? _$tokensInLPSortComputed;

  @override
  List<CurrencyModel> get tokensInLPSort => (_$tokensInLPSortComputed ??=
          Computed<List<CurrencyModel>>(() => super.tokensInLPSort,
              name: '_DicoStoreBase.tokensInLPSort'))
      .value;
  Computed<List<IcoModel>?>? _$icoComingUpListComputed;

  @override
  List<IcoModel>? get icoComingUpList => (_$icoComingUpListComputed ??=
          Computed<List<IcoModel>?>(() => super.icoComingUpList,
              name: '_DicoStoreBase.icoComingUpList'))
      .value;
  Computed<List<IcoModel>?>? _$icoOngoingListComputed;

  @override
  List<IcoModel>? get icoOngoingList => (_$icoOngoingListComputed ??=
          Computed<List<IcoModel>?>(() => super.icoOngoingList,
              name: '_DicoStoreBase.icoOngoingList'))
      .value;
  Computed<List<IcoModel>?>? _$icoFinishedListComputed;

  @override
  List<IcoModel>? get icoFinishedList => (_$icoFinishedListComputed ??=
          Computed<List<IcoModel>?>(() => super.icoFinishedList,
              name: '_DicoStoreBase.icoFinishedList'))
      .value;
  Computed<int?>? _$totalFarmAllocPointComputed;

  @override
  int? get totalFarmAllocPoint => (_$totalFarmAllocPointComputed ??=
          Computed<int?>(() => super.totalFarmAllocPoint,
              name: '_DicoStoreBase.totalFarmAllocPoint'))
      .value;
  Computed<BigInt?>? _$totalFarmRewardCurrentBlockComputed;

  @override
  BigInt? get totalFarmRewardCurrentBlock =>
      (_$totalFarmRewardCurrentBlockComputed ??= Computed<BigInt?>(
              () => super.totalFarmRewardCurrentBlock,
              name: '_DicoStoreBase.totalFarmRewardCurrentBlock'))
          .value;
  Computed<int?>? _$farmPhaseComputed;

  @override
  int? get farmPhase =>
      (_$farmPhaseComputed ??= Computed<int?>(() => super.farmPhase,
              name: '_DicoStoreBase.farmPhase'))
          .value;
  Computed<List<LbpModel>?>? _$lbpPoolsInProgressComputed;

  @override
  List<LbpModel>? get lbpPoolsInProgress => (_$lbpPoolsInProgressComputed ??=
          Computed<List<LbpModel>?>(() => super.lbpPoolsInProgress,
              name: '_DicoStoreBase.lbpPoolsInProgress'))
      .value;
  Computed<List<LbpModel>?>? _$lbpPoolsFinishedComputed;

  @override
  List<LbpModel>? get lbpPoolsFinished => (_$lbpPoolsFinishedComputed ??=
          Computed<List<LbpModel>?>(() => super.lbpPoolsFinished,
              name: '_DicoStoreBase.lbpPoolsFinished'))
      .value;
  Computed<List<LbpModel>?>? _$lbpPoolsMyComputed;

  @override
  List<LbpModel>? get lbpPoolsMy => (_$lbpPoolsMyComputed ??=
          Computed<List<LbpModel>?>(() => super.lbpPoolsMy,
              name: '_DicoStoreBase.lbpPoolsMy'))
      .value;
  Computed<NftTokenInfoModel?>? _$activeNftTokenComputed;

  @override
  NftTokenInfoModel? get activeNftToken => (_$activeNftTokenComputed ??=
          Computed<NftTokenInfoModel?>(() => super.activeNftToken,
              name: '_DicoStoreBase.activeNftToken'))
      .value;

  final _$tokensAtom = Atom(name: '_DicoStoreBase.tokens');

  @override
  ObservableList<CurrencyModel>? get tokens {
    _$tokensAtom.reportRead();
    return super.tokens;
  }

  @override
  set tokens(ObservableList<CurrencyModel>? value) {
    _$tokensAtom.reportWrite(value, super.tokens, () {
      super.tokens = value;
    });
  }

  final _$tokensInLPAtom = Atom(name: '_DicoStoreBase.tokensInLP');

  @override
  ObservableList<CurrencyModel>? get tokensInLP {
    _$tokensInLPAtom.reportRead();
    return super.tokensInLP;
  }

  @override
  set tokensInLP(ObservableList<CurrencyModel>? value) {
    _$tokensInLPAtom.reportWrite(value, super.tokensInLP, () {
      super.tokensInLP = value;
    });
  }

  final _$passedIcoListAtom = Atom(name: '_DicoStoreBase.passedIcoList');

  @override
  ObservableList<IcoModel>? get passedIcoList {
    _$passedIcoListAtom.reportRead();
    return super.passedIcoList;
  }

  @override
  set passedIcoList(ObservableList<IcoModel>? value) {
    _$passedIcoListAtom.reportWrite(value, super.passedIcoList, () {
      super.passedIcoList = value;
    });
  }

  final _$myLiquidityListAtom = Atom(name: '_DicoStoreBase.myLiquidityList');

  @override
  ObservableList<MyLiquidityModel>? get myLiquidityList {
    _$myLiquidityListAtom.reportRead();
    return super.myLiquidityList;
  }

  @override
  set myLiquidityList(ObservableList<MyLiquidityModel>? value) {
    _$myLiquidityListAtom.reportWrite(value, super.myLiquidityList, () {
      super.myLiquidityList = value;
    });
  }

  final _$participatedIcoListAtom =
      Atom(name: '_DicoStoreBase.participatedIcoList');

  @override
  ObservableList<IcoModel>? get participatedIcoList {
    _$participatedIcoListAtom.reportRead();
    return super.participatedIcoList;
  }

  @override
  set participatedIcoList(ObservableList<IcoModel>? value) {
    _$participatedIcoListAtom.reportWrite(value, super.participatedIcoList, () {
      super.participatedIcoList = value;
    });
  }

  final _$addedIcoListAtom = Atom(name: '_DicoStoreBase.addedIcoList');

  @override
  ObservableList<IcoAddListModel>? get addedIcoList {
    _$addedIcoListAtom.reportRead();
    return super.addedIcoList;
  }

  @override
  set addedIcoList(ObservableList<IcoAddListModel>? value) {
    _$addedIcoListAtom.reportWrite(value, super.addedIcoList, () {
      super.addedIcoList = value;
    });
  }

  final _$requestReleaseListAtom =
      Atom(name: '_DicoStoreBase.requestReleaseList');

  @override
  ObservableList<IcoRequestReleaseInfoModel> get requestReleaseList {
    _$requestReleaseListAtom.reportRead();
    return super.requestReleaseList;
  }

  @override
  set requestReleaseList(ObservableList<IcoRequestReleaseInfoModel> value) {
    _$requestReleaseListAtom.reportWrite(value, super.requestReleaseList, () {
      super.requestReleaseList = value;
    });
  }

  final _$daoProposalListAtom = Atom(name: '_DicoStoreBase.daoProposalList');

  @override
  ObservableList<DaoProposalModel>? get daoProposalList {
    _$daoProposalListAtom.reportRead();
    return super.daoProposalList;
  }

  @override
  set daoProposalList(ObservableList<DaoProposalModel>? value) {
    _$daoProposalListAtom.reportWrite(value, super.daoProposalList, () {
      super.daoProposalList = value;
    });
  }

  final _$liquidityListAtom = Atom(name: '_DicoStoreBase.liquidityList');

  @override
  ObservableList<LiquidityModel>? get liquidityList {
    _$liquidityListAtom.reportRead();
    return super.liquidityList;
  }

  @override
  set liquidityList(ObservableList<LiquidityModel>? value) {
    _$liquidityListAtom.reportWrite(value, super.liquidityList, () {
      super.liquidityList = value;
    });
  }

  final _$farmPoolsAtom = Atom(name: '_DicoStoreBase.farmPools');

  @override
  ObservableList<FarmPoolModel>? get farmPools {
    _$farmPoolsAtom.reportRead();
    return super.farmPools;
  }

  @override
  set farmPools(ObservableList<FarmPoolModel>? value) {
    _$farmPoolsAtom.reportWrite(value, super.farmPools, () {
      super.farmPools = value;
    });
  }

  final _$farmRuleDataAtom = Atom(name: '_DicoStoreBase.farmRuleData');

  @override
  FarmRuleDataModel? get farmRuleData {
    _$farmRuleDataAtom.reportRead();
    return super.farmRuleData;
  }

  @override
  set farmRuleData(FarmRuleDataModel? value) {
    _$farmRuleDataAtom.reportWrite(value, super.farmRuleData, () {
      super.farmRuleData = value;
    });
  }

  final _$farmPoolExtendsAtom = Atom(name: '_DicoStoreBase.farmPoolExtends');

  @override
  ObservableList<FarmPoolExtendModel>? get farmPoolExtends {
    _$farmPoolExtendsAtom.reportRead();
    return super.farmPoolExtends;
  }

  @override
  set farmPoolExtends(ObservableList<FarmPoolExtendModel>? value) {
    _$farmPoolExtendsAtom.reportWrite(value, super.farmPoolExtends, () {
      super.farmPoolExtends = value;
    });
  }

  final _$lbpPoolListAtom = Atom(name: '_DicoStoreBase.lbpPoolList');

  @override
  ObservableList<LbpModel>? get lbpPoolList {
    _$lbpPoolListAtom.reportRead();
    return super.lbpPoolList;
  }

  @override
  set lbpPoolList(ObservableList<LbpModel>? value) {
    _$lbpPoolListAtom.reportWrite(value, super.lbpPoolList, () {
      super.lbpPoolList = value;
    });
  }

  final _$iasAtom = Atom(name: '_DicoStoreBase.ias');

  @override
  KycIasOrSwordHolderModel? get ias {
    _$iasAtom.reportRead();
    return super.ias;
  }

  @override
  set ias(KycIasOrSwordHolderModel? value) {
    _$iasAtom.reportWrite(value, super.ias, () {
      super.ias = value;
    });
  }

  final _$swordHolderAtom = Atom(name: '_DicoStoreBase.swordHolder');

  @override
  KycIasOrSwordHolderModel? get swordHolder {
    _$swordHolderAtom.reportRead();
    return super.swordHolder;
  }

  @override
  set swordHolder(KycIasOrSwordHolderModel? value) {
    _$swordHolderAtom.reportWrite(value, super.swordHolder, () {
      super.swordHolder = value;
    });
  }

  final _$myNftTokenListAtom = Atom(name: '_DicoStoreBase.myNftTokenList');

  @override
  ObservableList<NftTokenInfoModel>? get myNftTokenList {
    _$myNftTokenListAtom.reportRead();
    return super.myNftTokenList;
  }

  @override
  set myNftTokenList(ObservableList<NftTokenInfoModel>? value) {
    _$myNftTokenListAtom.reportWrite(value, super.myNftTokenList, () {
      super.myNftTokenList = value;
    });
  }

  final _$newHeadsAtom = Atom(name: '_DicoStoreBase.newHeads');

  @override
  NewHeadsModel? get newHeads {
    _$newHeadsAtom.reportRead();
    return super.newHeads;
  }

  @override
  set newHeads(NewHeadsModel? value) {
    _$newHeadsAtom.reportWrite(value, super.newHeads, () {
      super.newHeads = value;
    });
  }

  final _$getTokensAsyncAction = AsyncAction('_DicoStoreBase.getTokens');

  @override
  Future<dynamic> getTokens() {
    return _$getTokensAsyncAction.run(() => super.getTokens());
  }

  final _$getMyNftTokenListAsyncAction =
      AsyncAction('_DicoStoreBase.getMyNftTokenList');

  @override
  Future<dynamic> getMyNftTokenList() {
    return _$getMyNftTokenListAsyncAction.run(() => super.getMyNftTokenList());
  }

  final _$initAsyncAction = AsyncAction('_DicoStoreBase.init');

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  final _$_DicoStoreBaseActionController =
      ActionController(name: '_DicoStoreBase');

  @override
  void setTokens(List<CurrencyModel>? list) {
    final _$actionInfo = _$_DicoStoreBaseActionController.startAction(
        name: '_DicoStoreBase.setTokens');
    try {
      return super.setTokens(list);
    } finally {
      _$_DicoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTokensInLP(List<CurrencyModel>? list) {
    final _$actionInfo = _$_DicoStoreBaseActionController.startAction(
        name: '_DicoStoreBase.setTokensInLP');
    try {
      return super.setTokensInLP(list);
    } finally {
      _$_DicoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassedIcoList(List<IcoModel>? list) {
    final _$actionInfo = _$_DicoStoreBaseActionController.startAction(
        name: '_DicoStoreBase.setPassedIcoList');
    try {
      return super.setPassedIcoList(list);
    } finally {
      _$_DicoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMyLiquidityList(List<MyLiquidityModel>? list) {
    final _$actionInfo = _$_DicoStoreBaseActionController.startAction(
        name: '_DicoStoreBase.setMyLiquidityList');
    try {
      return super.setMyLiquidityList(list);
    } finally {
      _$_DicoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setParticipatedIcoList(List<IcoModel>? list) {
    final _$actionInfo = _$_DicoStoreBaseActionController.startAction(
        name: '_DicoStoreBase.setParticipatedIcoList');
    try {
      return super.setParticipatedIcoList(list);
    } finally {
      _$_DicoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAddedIcoList(List<IcoAddListModel>? list) {
    final _$actionInfo = _$_DicoStoreBaseActionController.startAction(
        name: '_DicoStoreBase.setAddedIcoList');
    try {
      return super.setAddedIcoList(list);
    } finally {
      _$_DicoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRequestReleaseList(List<IcoRequestReleaseInfoModel> list) {
    final _$actionInfo = _$_DicoStoreBaseActionController.startAction(
        name: '_DicoStoreBase.setRequestReleaseList');
    try {
      return super.setRequestReleaseList(list);
    } finally {
      _$_DicoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDaoProposalList(List<DaoProposalModel>? list) {
    final _$actionInfo = _$_DicoStoreBaseActionController.startAction(
        name: '_DicoStoreBase.setDaoProposalList');
    try {
      return super.setDaoProposalList(list);
    } finally {
      _$_DicoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLiquidityList(List<LiquidityModel>? list) {
    final _$actionInfo = _$_DicoStoreBaseActionController.startAction(
        name: '_DicoStoreBase.setLiquidityList');
    try {
      return super.setLiquidityList(list);
    } finally {
      _$_DicoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFarmPools(List<FarmPoolModel>? list) {
    final _$actionInfo = _$_DicoStoreBaseActionController.startAction(
        name: '_DicoStoreBase.setFarmPools');
    try {
      return super.setFarmPools(list);
    } finally {
      _$_DicoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFarmRuleData(FarmRuleDataModel? data) {
    final _$actionInfo = _$_DicoStoreBaseActionController.startAction(
        name: '_DicoStoreBase.setFarmRuleData');
    try {
      return super.setFarmRuleData(data);
    } finally {
      _$_DicoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFarmPoolExtends(List<FarmPoolExtendModel>? list) {
    final _$actionInfo = _$_DicoStoreBaseActionController.startAction(
        name: '_DicoStoreBase.setFarmPoolExtends');
    try {
      return super.setFarmPoolExtends(list);
    } finally {
      _$_DicoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLbpPoolList(List<LbpModel>? list) {
    final _$actionInfo = _$_DicoStoreBaseActionController.startAction(
        name: '_DicoStoreBase.setLbpPoolList');
    try {
      return super.setLbpPoolList(list);
    } finally {
      _$_DicoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIas(KycIasOrSwordHolderModel? n) {
    final _$actionInfo = _$_DicoStoreBaseActionController.startAction(
        name: '_DicoStoreBase.setIas');
    try {
      return super.setIas(n);
    } finally {
      _$_DicoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSwordHolder(KycIasOrSwordHolderModel? n) {
    final _$actionInfo = _$_DicoStoreBaseActionController.startAction(
        name: '_DicoStoreBase.setSwordHolder');
    try {
      return super.setSwordHolder(n);
    } finally {
      _$_DicoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMyNftTokenList(List<NftTokenInfoModel>? list) {
    final _$actionInfo = _$_DicoStoreBaseActionController.startAction(
        name: '_DicoStoreBase.setMyNftTokenList');
    try {
      return super.setMyNftTokenList(list);
    } finally {
      _$_DicoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNewHeads(Map<dynamic, dynamic>? n) {
    final _$actionInfo = _$_DicoStoreBaseActionController.startAction(
        name: '_DicoStoreBase.setNewHeads');
    try {
      return super.setNewHeads(n);
    } finally {
      _$_DicoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearState() {
    final _$actionInfo = _$_DicoStoreBaseActionController.startAction(
        name: '_DicoStoreBase.clearState');
    try {
      return super.clearState();
    } finally {
      _$_DicoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tokens: ${tokens},
tokensInLP: ${tokensInLP},
passedIcoList: ${passedIcoList},
myLiquidityList: ${myLiquidityList},
participatedIcoList: ${participatedIcoList},
addedIcoList: ${addedIcoList},
requestReleaseList: ${requestReleaseList},
daoProposalList: ${daoProposalList},
liquidityList: ${liquidityList},
farmPools: ${farmPools},
farmRuleData: ${farmRuleData},
farmPoolExtends: ${farmPoolExtends},
lbpPoolList: ${lbpPoolList},
ias: ${ias},
swordHolder: ${swordHolder},
myNftTokenList: ${myNftTokenList},
newHeads: ${newHeads},
tokensSort: ${tokensSort},
tokensInLPSort: ${tokensInLPSort},
icoComingUpList: ${icoComingUpList},
icoOngoingList: ${icoOngoingList},
icoFinishedList: ${icoFinishedList},
totalFarmAllocPoint: ${totalFarmAllocPoint},
totalFarmRewardCurrentBlock: ${totalFarmRewardCurrentBlock},
farmPhase: ${farmPhase},
lbpPoolsInProgress: ${lbpPoolsInProgress},
lbpPoolsFinished: ${lbpPoolsFinished},
lbpPoolsMy: ${lbpPoolsMy},
activeNftToken: ${activeNftToken}
    ''';
  }
}
