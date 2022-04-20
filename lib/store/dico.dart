import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/model/currency_model.dart';
import 'package:dicolite/model/dao_proposal_model.dart';
import 'package:dicolite/model/farm_pool_extend_model.dart';
import 'package:dicolite/model/farm_pool_model.dart';
import 'package:dicolite/model/farm_rule_data_model.dart';
import 'package:dicolite/model/ico_add_list_model.dart';
import 'package:dicolite/model/ico_model.dart';
import 'package:dicolite/model/ico_request_release_info_model.dart';
import 'package:dicolite/model/kyc_ias_or_sword_holder_model.dart';
import 'package:dicolite/model/lbp_model.dart';
import 'package:dicolite/model/liquidity_model.dart';
import 'package:dicolite/model/my_liquidity_model.dart';
import 'package:dicolite/model/new_heads_model.dart';
import 'package:dicolite/model/nft_token_info_model.dart';
import 'package:dicolite/model/token_balance_model.dart';
import 'package:dicolite/store/assets/types/balancesInfo.dart';
import 'package:dicolite/utils/calculate_price.dart';
import 'package:dicolite/utils/format.dart';
import 'package:mobx/mobx.dart';

import 'app.dart';

part 'dico.g.dart';

class DicoStore = _DicoStoreBase with _$DicoStore;

abstract class _DicoStoreBase with Store {
  _DicoStoreBase(this.rootStore);
  final AppStore rootStore;

  /// all token list
  @observable
  ObservableList<CurrencyModel>? tokens = ObservableList<CurrencyModel>();

  @action
  void setTokens(List<CurrencyModel>? list) {
    tokens = list == null
        ? ObservableList<CurrencyModel>()
        : ObservableList.of(list);
    rootStore.localStorage.setTokens(
        rootStore.settings?.endpoint.info.toUpperCase() ?? Config.tokenSymbol,
        list?.map((e) => e.toJson()).toList());
  }

  @computed
  List<CurrencyModel> get tokensSort {
    BalancesInfo? dicoBalance = rootStore.assets?.balances[
        rootStore.settings?.networkState.tokenSymbol ?? Config.tokenSymbol];
    CurrencyModel dico = CurrencyModel(
        currencyId: '0',
        decimals: rootStore.settings?.networkState.tokenDecimals ?? 14,
        name:
            rootStore.settings?.networkState.tokenSymbol ?? Config.tokenSymbol,
        owner: '',
        symbol:
            rootStore.settings?.networkState.tokenSymbol ?? Config.tokenSymbol,
        tokenBalance: TokenBalanceModel(
            free: dicoBalance?.transferable ?? BigInt.zero,
            frozen: dicoBalance?.lockedBalance ?? BigInt.zero,
            reserved: dicoBalance?.reserved ?? BigInt.zero,
            total: dicoBalance?.total ?? BigInt.zero),
        totalIssuance: BigInt.zero);
    if (tokens != null && tokens!.isNotEmpty) {
      List<CurrencyModel> list = tokens!.toList();
      list.sort(
          (a, b) => (b.tokenBalance.total - a.tokenBalance.total).toInt());
      list.insert(0, dico);
      return list;
    }
    return [dico];
  }

  /// all token has liquidity list
  @observable
  ObservableList<CurrencyModel>? tokensInLP = ObservableList<CurrencyModel>();

  @action
  void setTokensInLP(List<CurrencyModel>? list) {
    tokensInLP = list == null
        ? ObservableList<CurrencyModel>()
        : ObservableList.of(list);
  }

  @computed
  List<CurrencyModel> get tokensInLPSort {
    if (rootStore.settings?.networkState.tokenSymbol != null &&
        rootStore.settings!.networkState.tokenSymbol.isNotEmpty) {
      BalancesInfo? dicoBalance = rootStore.assets?.balances[
          rootStore.settings?.networkState.tokenSymbol ?? Config.tokenSymbol];
      CurrencyModel dico = CurrencyModel(
          currencyId: '0',
          decimals: rootStore.settings?.networkState.tokenDecimals ?? 14,
          name: rootStore.settings?.networkState.tokenSymbol ??
              Config.tokenSymbol,
          owner: '',
          symbol: rootStore.settings?.networkState.tokenSymbol ??
              Config.tokenSymbol,
          tokenBalance: TokenBalanceModel(
              free: dicoBalance?.transferable ?? BigInt.zero,
              frozen: dicoBalance?.lockedBalance ?? BigInt.zero,
              reserved: dicoBalance?.reserved ?? BigInt.zero,
              total: dicoBalance?.total ?? BigInt.zero),
          totalIssuance: BigInt.zero);
      if (tokensInLP != null && tokensInLP!.isNotEmpty) {
        List<CurrencyModel> list = tokensInLP!.toList();
        list.sort(
            (a, b) => (b.tokenBalance.total - a.tokenBalance.total).toInt());
        list.insert(0, dico);
        return list;
      }
      return [dico];
    }
    return [];
  }

  @action
  Future getTokens() async {
    List<Map<String, dynamic>>? res = await rootStore.localStorage.getTokens(
        rootStore.settings?.endpoint.info.toUpperCase() ?? Config.tokenSymbol);
    if (res != null) {
      List<CurrencyModel> list =
          res.map((e) => CurrencyModel.fromJson(e)).toList();
      tokens = ObservableList.of(list);
    }
  }

  /// all passed ico list
  @observable
  ObservableList<IcoModel>? passedIcoList;

  @action
  void setPassedIcoList(List<IcoModel>? list) {
    passedIcoList = list == null ? null : ObservableList.of(list);
  }

  /// My liquidity list
  @observable
  ObservableList<MyLiquidityModel>? myLiquidityList;

  @action
  void setMyLiquidityList(List<MyLiquidityModel>? list) {
    myLiquidityList = list == null ? null : ObservableList.of(list);
  }

  @computed
  List<IcoModel>? get icoComingUpList {
    if (passedIcoList != null && newHeads != null) {
      return passedIcoList!
          .where((e) => newHeads!.number < e.startTime!)
          .toList();
    }
    return null;
  }

  @computed
  List<IcoModel>? get icoOngoingList {
    if (passedIcoList != null && newHeads != null) {
      return passedIcoList!
          .where((e) =>
              newHeads!.number >= e.startTime! &&
              e.icoDuration + e.startTime! >= newHeads!.number &&
              e.totalUnrealeaseAmount < e.exchangeTokenTotalAmount &&
              !e.isTerminated)
          .toList();
    }
    return null;
  }

  @computed
  List<IcoModel>? get icoFinishedList {
    if (passedIcoList != null && newHeads != null) {
      return passedIcoList!
          .where((e) =>
              (e.icoDuration + e.startTime! <= newHeads!.number) ||
              e.totalUnrealeaseAmount >= e.exchangeTokenTotalAmount ||
              e.isTerminated)
          .toList();
    }
    return null;
  }

  /// all participated ico list
  @observable
  ObservableList<IcoModel>? participatedIcoList;

  @action
  void setParticipatedIcoList(List<IcoModel>? list) {
    participatedIcoList = list == null ? null : ObservableList.of(list);
  }

  /// all added ico list
  @observable
  ObservableList<IcoAddListModel>? addedIcoList;

  @action
  void setAddedIcoList(List<IcoAddListModel>? list) {
    addedIcoList = list == null ? null : ObservableList.of(list);
  }

  /// request Release list
  @observable
  ObservableList<IcoRequestReleaseInfoModel> requestReleaseList =
      ObservableList<IcoRequestReleaseInfoModel>();

  @action
  void setRequestReleaseList(List<IcoRequestReleaseInfoModel> list) {
    requestReleaseList = ObservableList.of(list);
  }

  /// Dao proposal List
  @observable
  ObservableList<DaoProposalModel>? daoProposalList;

  @action
  void setDaoProposalList(List<DaoProposalModel>? list) {
    daoProposalList = list == null ? null : ObservableList.of(list);
  }

  /// liquidity List
  @observable
  ObservableList<LiquidityModel>? liquidityList;

  @action
  void setLiquidityList(List<LiquidityModel>? list) {
    liquidityList = list == null ? null : ObservableList.of(list);
  }

  /// farmPools List
  @observable
  ObservableList<FarmPoolModel>? farmPools;

  @action
  void setFarmPools(List<FarmPoolModel>? list) {
    farmPools = list == null ? null : ObservableList.of(list);
  }

  @computed
  int? get totalFarmAllocPoint {
    if (farmPools != null && farmPools!.isNotEmpty && newHeads != null) {
      int total = 0;
      farmPools!.forEach((e) {
        if (!e.isFinished) {
          total += e.allocPoint;
        }
      });
      return total;
    }
    return null;
  }

  @computed
  BigInt? get totalFarmRewardCurrentBlock {
    try {
      if (farmPhase != null && farmRuleData != null) {
        return BigInt.parse((Decimal.fromBigInt(farmRuleData!.dicoPerBlock) /
                Decimal.fromInt(2).pow(farmPhase!))
            .toStringAsFixed(0));
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// farmRuleData
  @observable
  FarmRuleDataModel? farmRuleData;

  @action
  void setFarmRuleData(FarmRuleDataModel? data) {
    farmRuleData = data;
  }

  @computed
  int? get farmPhase {
    if (farmRuleData != null && newHeads != null) {
      if ((newHeads!.number > farmRuleData!.startBlock) &&
          farmRuleData!.halvingPeriod != 0) {
        return (newHeads!.number - farmRuleData!.startBlock - 1) ~/
            farmRuleData!.halvingPeriod;
      }
      return 0;
    }
    return null;
  }

  /// farmPoolsExtend List
  @observable
  ObservableList<FarmPoolExtendModel>? farmPoolExtends;

  @action
  void setFarmPoolExtends(List<FarmPoolExtendModel>? list) {
    farmPoolExtends = list == null ? null : ObservableList.of(list);
  }

  // @compute
  // List<FarmPoolExtendModel>? get farmPoolExtendLive{
  //   if()
  // }

  /// lbpPoolList List
  @observable
  ObservableList<LbpModel>? lbpPoolList;

  @action
  void setLbpPoolList(List<LbpModel>? list) {
    lbpPoolList = list == null ? null : ObservableList.of(list);
  }

  @computed
  List<LbpModel>? get lbpPoolsInProgress {
    if (lbpPoolList != null) {
      return lbpPoolList!.where((e) => (e.status == "InProgress")).toList();
    }
    return null;
  }

  @computed
  List<LbpModel>? get lbpPoolsFinished {
    if (lbpPoolList != null) {
      return lbpPoolList!.where((e) => (e.status == "Finished")).toList();
    }
    return null;
  }

  @computed
  List<LbpModel>? get lbpPoolsMy {
    if (lbpPoolList != null) {
      return lbpPoolList!
          .where((e) => (e.owner == rootStore.account!.currentAddress))
          .toList();
    }
    return null;
  }

  /// Ias
  @observable
  KycIasOrSwordHolderModel? ias;

  @action
  void setIas(KycIasOrSwordHolderModel? n) {
    ias = n;
  }

  /// SwordHolder
  @observable
  KycIasOrSwordHolderModel? swordHolder;

  @action
  void setSwordHolder(KycIasOrSwordHolderModel? n) {
    swordHolder = n;
  }

  /// My nft token list
  @observable
  ObservableList<NftTokenInfoModel>? myNftTokenList;

  @action
  void setMyNftTokenList(List<NftTokenInfoModel>? list) {
    myNftTokenList = list == null ? null : ObservableList.of(list);
    rootStore.localStorage.setMyNftList(list?.map((e) => e.toJson()).toList());
  }

  @action
  Future getMyNftTokenList() async {
    List<Map<String, dynamic>>? res =
        await rootStore.localStorage.getMyNftList();
    if (res != null) {
      List<NftTokenInfoModel> list =
          res.map((e) => NftTokenInfoModel.fromJson(e)).toList();
      myNftTokenList = ObservableList.of(list);
    }
  }

  @computed
  NftTokenInfoModel? get activeNftToken {
    if (myNftTokenList != null && myNftTokenList!.isNotEmpty) {
      int index =
          myNftTokenList!.indexWhere((e) => e.data.status.isActiveImage);
      if (index != -1) {
        return myNftTokenList![index];
      }
    }
    return null;
  }

  /// newHeads
  @observable
  NewHeadsModel? newHeads;

  @action
  void setNewHeads(Map? n) {
    newHeads = n != null ? NewHeadsModel.fromJson(n) : null;
  }

  @computed
  String get rawTokenPrice {
    if (liquidityList != null && liquidityList!.isNotEmpty) {
      Decimal? price = CalculatePrice.calcuteTokenBestPrice(
          liquidityList!, Decimal.fromInt(1), Config.tokenId);
      if (price != null) {
        return Fmt.decimalFixed(price, 5);
      }
    }
    return "~";
  }

  @action
  void clearState() {
    ias = null;
    swordHolder = null;
    myNftTokenList = null;
    newHeads = null;
  }

  @action
  Future<void> init() async {
    getTokens();
    getMyNftTokenList();
  }
}
