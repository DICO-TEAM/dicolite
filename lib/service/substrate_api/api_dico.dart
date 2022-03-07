import 'dart:convert';

import 'package:dicolite/config/config.dart';
import 'package:dicolite/model/currency_model.dart';
import 'package:dicolite/model/dao_proposal_model.dart';
import 'package:dicolite/model/farm_rule_data_model.dart';
import 'package:dicolite/model/ico_add_list_model.dart';
import 'package:dicolite/model/ico_model.dart';
import 'package:dicolite/model/ico_request_release_info_model.dart';
import 'package:dicolite/model/kyc_application_form_model.dart';
import 'package:dicolite/model/kyc_fileds_model.dart';
import 'package:dicolite/model/kyc_ias_or_sword_holder_model.dart';
import 'package:dicolite/model/my_liquidity_model.dart';
import 'package:dicolite/model/nft_token_info_model.dart';
import 'package:dicolite/model/token_balance_model.dart';
import 'package:dicolite/store/account/account.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:flutter/material.dart';

import 'api.dart';

class ApiDico {
  ApiDico(this.apiRoot);

  final Api apiRoot;
  final store = globalAppStore;

  ///Fetch fetchAddedIcoList
  Future fetchAddedIcoList() async {
    try {
      String addr = store.account!.currentAccount.address;
      var res =
          await apiRoot.evalJavascript('dico.fetchInitiatedIcoesOf("$addr")');
      if (res != null) {
        List<IcoAddListModel>? list =
            (res as List).map((e) => IcoAddListModel.fromJson(e)).toList();
        store.dico!.setAddedIcoList(list);
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
  }

  ///Fetch fetchpassedIcoes
  Future fetchpassedIcoes({dynamic initFectchData}) async {
    try {
      if (apiRoot.hasLoadAccountData == false) return;
      List? res;
      if (initFectchData != null) {
        res = initFectchData as List?;
      } else {
        res = await apiRoot.evalJavascript('dico.fetchpassedIcoes()');
      }
      if (res != null) {
        List<IcoModel> list = res.map((e) => IcoModel.fromJson(e)).toList();
        store.dico!.setPassedIcoList(list);
      }
      await fetchUserJoinIcoAmount();
      await fetchAddedIcoList();
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
  }

  Future<List<IcoModel>?> fetchPendingIco() async {
    try {
      String addr = store.account!.currentAccount.address;
      var res = await apiRoot.evalJavascript('dico.fetchPendingIco("$addr")');
      if (res != null) {
        return (res as List).map((e) => IcoModel.fromJson(e?["ico"])).toList();
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
    return null;
  }

  ///Fetch ico min max usdt amount
  Future<List?> fetchMinMaxUSDTAmount() async {
    try {
      var res = await apiRoot.evalJavascript('dico.fetchMinMaxUSDTAmount()');
      if (res != null) {
        return res as List;
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
    return null;
  }

  ///Fetch user join ico amount
  Future<List?> fetchUserJoinIcoAmount() async {
    try {
      String addr = store.account!.currentAccount.address;
      List? res =
          await apiRoot.evalJavascript('dico.fetchUserJoinIcoAmount("$addr")');
      if (res != null) {
        if (res[1] != null) {
          List<IcoModel> icoList =
              (res[1] as List).map((e) => IcoModel.fromJson(e)).toList();
          store.dico!.setParticipatedIcoList(icoList);
        }
        return res[0] as List;
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
    return null;
  }

  ///fetch request release list
  Future<void> fetchReleaseList({dynamic initFectchData}) async {
    try {
      List? res;
      if (initFectchData != null) {
        res = initFectchData as List?;
      } else {
        res =
            await apiRoot.evalJavascript('api.query.ico.requestReleaseInfo()');
      }
      if (res != null) {
        List<IcoRequestReleaseInfoModel> list =
            res.map((e) => IcoRequestReleaseInfoModel.fromJson(e)).toList();
        store.dico!.setRequestReleaseList(list);
      } else {
        store.dico!.setRequestReleaseList([]);
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
  }

  ///Fetch ico get amount
  Future<List> fetchIcoGetAmount(String currencyId, int index) async {
    try {
      String addr = store.account!.currentAccount.address;
      var res = await apiRoot.evalJavascript(
          'dico.fetchIcoGetAmount("$addr","$currencyId",$index)');
      if (res != null) {
        return res as List;
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
    return [];
  }

  ///fetch dao propose list
  Future<void> fetchDaoProposeList() async {
    try {
      List<String> curencyidList = [];
      if (store.dico?.passedIcoList != null) {
        curencyidList = store.dico!.passedIcoList!
            .map((e) => e.currencyId)
            .toSet()
            .toList();
      }
     
      if (curencyidList.isEmpty) {
        store.dico!.setDaoProposalList([]);
        return;
      }
      String data = jsonEncode(curencyidList);
      List? res =
          await apiRoot.evalJavascript('dico.fetchDaoProposeList($data)');
      if (res != null) {
        List<DaoProposalModel> list =
            res.map((e) => DaoProposalModel.fromJson(e)).toList();

        store.dico!.passedIcoList?.forEach((e) {
          list.forEach((x) {
            if (e.currencyId == x.currencyId && e.index == x.icoIndex) {
              x.ico = e;
            }
          });
        });

        store.dico!.requestReleaseList.forEach((e) {
          list.forEach((x) {
            if (e.currencyId == x.currencyId && e.index == x.icoIndex) {
              x.icoRequestReleaseInfo = e;
            }
          });
        });

        /// remove icoRequestReleaseInfo==null DaoProposal
        list = list.where((e) => e.icoRequestReleaseInfo != null).toList();
        store.dico!.setDaoProposalList(list);
      } else {
        store.dico!.setDaoProposalList([]);
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
  }

  /// all dico token info
  Future fetchAllTokenInfoList() async {
    try {
      String addr = store.account!.currentAccount.address;
      var res =
          await apiRoot.evalJavascript('dico.fetchAllTokenInfoList("$addr")');
      if (res != null) {
        return res;
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
    return null;
  }

  /// dico token info
  Future fetchTokenInfo(String currencyId) async {
    try {
      String addr = store.account!.currentAccount.address;
      var res = await apiRoot
          .evalJavascript('dico.fetchTokenInfo("$currencyId","$addr")');
      if (res != null) {
        return res;
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
    return null;
  }

  /// dico token info List
  Future<List<CurrencyModel>> fetchTokenInfoList(
      List<String> currencyIds) async {
    try {
      String addr = store.account!.currentAccount.address;
      List? res = await apiRoot
          .evalJavascript('dico.fetchTokenInfoList($currencyIds,"$addr")');
      if (res != null) {
        return res.map((e) => CurrencyModel.fromJson(e)).toList();
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
    return [];
  }

  /// dico fetch kyc recommand fee
  Future<BigInt?> fetchKYCRecommandFee(String fields) async {
    try {
      var res =
          await apiRoot.evalJavascript('dico.fetchKYCRecommandFee("$fields")');
      if (res != null) {
        return BigInt.parse(res.toString());
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
    return null;
  }

  /// Get my seed
  Future<String?> _getMySeed(BuildContext context) async {
    if (store.account?.currentAccount.observation == null ||
        store.account!.currentAccount.observation) return null;
    var password = await doAuth(context, store.account!.currentAccountPubKey);
    if (password == null) {
      return null;
    }
    String type = await store.account!.checkSeedExist(
            AccountStore.seedTypeRawSeed, store.account!.currentAccount.pubKey)
        ? AccountStore.seedTypeRawSeed
        : AccountStore.seedTypeMnemonic;
    String? mySeed = await store.account
        ?.decryptSeed(store.account!.currentAccount.pubKey, type, password);
    if (mySeed == null) {
      return null;
    }
    return mySeed;
  }

  /// Fetch ias message list
  Future<void> fetchKYCIasListAndSwordHolderList(
      {dynamic initFectchData}) async {
    String addr = store.account!.currentAccount.address;
    String fields = KycFiledsModel.Area.toString().split(".")[1];
    try {
      var res;
      if (initFectchData != null) {
        res = initFectchData;
      } else {
        res = await apiRoot.evalJavascript(
            'dico.fetchKYCIasListAndSwordHolderList("$fields")');
      }
      if (res != null && (res as List).isNotEmpty) {
        List<KycIasOrSwordHolderModel> iasList = (res[0] as List)
            .map((e) => KycIasOrSwordHolderModel.fromJson(e))
            .toList();
        List<KycIasOrSwordHolderModel> swordHolderList = (res[1] as List)
            .map((e) => KycIasOrSwordHolderModel.fromJson(e))
            .toList();
        int iasIndex = iasList.indexWhere((e) => e.account == addr);
        int swordHolderIndex =
            swordHolderList.indexWhere((e) => e.account == addr);
        if (iasIndex != -1) {
          store.dico!.setIas(iasList[iasIndex]);
        } else {
          store.dico!.setIas(null);
        }
        if (swordHolderIndex != -1) {
          store.dico!.setSwordHolder(swordHolderList[swordHolderIndex]);
        } else {
          store.dico!.setSwordHolder(null);
        }
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
  }

  /// Fetch ias message list
  Future<List<KycApplicationFormModel>?> fetchIasMessageList() async {
    String addr = store.account!.currentAccount.address;
    try {
      List? res =
          await apiRoot.evalJavascript('dico.fetchIasMessageList("$addr")');
      if (res != null) {
        return res.map((e) => KycApplicationFormModel.fromJson(e)).toList();
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
    return null;
  }

  /// Fetch sword holder message list
  Future<List<KycApplicationFormModel>?> fetchSwordHolderMessageList() async {
    String addr = store.account!.currentAccount.address;
    try {
      List? res = await apiRoot
          .evalJavascript('dico.fetchSwordHolderMessageList("$addr")');
      if (res != null) {
        return res.map((e) => KycApplicationFormModel.fromJson(e)).toList();
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
    return null;
  }

  /// Fetch kyc my curve public key
  Future<String?> fetchKYCMyCurvePublicKey(BuildContext context) async {
    String? mySeed = await _getMySeed(context);
    if (mySeed == null) {
      return null;
    }
    try {
      var res = await apiRoot
          .evalJavascript('dico.fetchKYCMyCurvePublicKey("$mySeed")');
      if (res != null) {
        return res;
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
    return null;
  }

  /// Encrypt kyc message
  Future<String?> encryptKYCMessage(
      BuildContext context, String message, String otherPublic) async {
    try {
      String? mySeed = await _getMySeed(context);
      if (mySeed == null) {
        return null;
      }
      var res = await apiRoot.evalJavascript(
          'dico.encryptKYCMessage("$message","$otherPublic","$mySeed")');
      if (res != null) {
        return res;
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
    return null;
  }

  /// decrypt kyc message
  Future<String?> decryptKYCMessage(
      BuildContext context, String message, String otherPublic) async {
    try {
      String? mySeed = await _getMySeed(context);
      if (mySeed == null) {
        return null;
      }
      var res = await apiRoot.evalJavascript(
          'dico.decryptKYCMessage("$message","$otherPublic","$mySeed")');
      if (res != null) {
        return res;
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
    return null;
  }

  /// dico fetch kyc info
  Future<List?> fetchKYCInfo({String addr = ''}) async {
    addr = addr.isEmpty ? store.account!.currentAccount.address : addr;

    try {
      var res = await apiRoot.evalJavascript('dico.fetchKYCInfo("$addr")');
      if (res != null) {
        return res as List;
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }

    return null;
  }

  /// fetchFarmSupplyBalance
  Future<BigInt?> fetchFarmSupplyBalance(String currencyId, int ss58) async {
    try {
      var res = await apiRoot.evalJavascript(
          'dico.fetchFarmSupplyBalance($currencyId,"${Config.farmSupplyPublicKey}",$ss58)');
      if (res != null) {
        return BigInt.parse(res.toString());
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }

    return null;
  }

  ///Fetch liquidity token balance
  Future<void> fetchLiquidityTokenBalance() async {
    await Future.delayed(Duration(seconds: 1));
    if (store.dico?.liquidityList == null) return null;
    try {
      String addr = store.account!.currentAccount.address;
      List list =
          store.dico!.liquidityList!.map((e) => [addr, e.liquidityId]).toList();
      if (list.isEmpty) {
        store.dico!.setMyLiquidityList([]);
        return;
      }
      String data = jsonEncode(list);
      List? res = await apiRoot
          .evalJavascript('dico.fetchLiquidityTokenBalance($data)') as List?;
      if (res != null) {
        List<MyLiquidityModel> data = [];
        for (var i = 0; i < res.length; i++) {
          TokenBalanceModel item = TokenBalanceModel.fromJson(res[i]);
          if (item.free != BigInt.zero) {
            data.add(MyLiquidityModel(store.dico!.liquidityList![i], item));
          }
        }
        store.dico!.setMyLiquidityList(data);
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
    return null;
  }

  /// Get farm participant reward
  Future<BigInt> getFarmParticipantReward(int poolId) async {
    String addr = store.account!.currentAccount.address;
    if (addr.isNotEmpty) {
      try {
        var res = await apiRoot.evalJavascript(
            'api.rpc.farm.getParticipantReward("$addr",$poolId)');
        if (res != null) {
          return BigInt.parse(res.toString());
        }
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
    return BigInt.zero;
  }

  /// Fetch lbp support fundraising assets list
  Future<List<CurrencyModel>> fetchLbpSupportFundraisingAssetsList() async {
    String addr = store.account!.currentAccount.address;
    if (addr.isNotEmpty) {
      try {
        var res = await apiRoot.evalJavascript(
            'dico.fetchLbpSupportFundraisingAssetsList("$addr")');
        if (res != null) {
          return (res as List).map((e) => CurrencyModel.fromJson(e)).toList();
        }
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
    return [];
  }

  /// Fetch lbp price history
  Future<List?> fetchLbpPriceHistory(String lbpId) async {
    String addr = store.account!.currentAccount.address;
    if (addr.isNotEmpty) {
      try {
        var res =
            await apiRoot.evalJavascript('api.query.lbp.priceHistory($lbpId)');
        if (res != null) {
          return res;
        }
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
    return null;
  }

  ///Fetch farm rule data:[ startBlock,halvingPeriod,dicoPerBlock]
  Future<void> fetchFarmRuleData({dynamic initFectchData}) async {
    try {
      var res;
      if (initFectchData != null) {
        res = initFectchData;
      } else {
        res = await apiRoot.evalJavascript('dico.fetchFarmRuleData()');
      }
      if (res != null) {
        store.dico!.setFarmRuleData(FarmRuleDataModel.fromList(res as List));
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
  }

  /// Fetch can claim nft list and my ico total usd
  Future<List?> fetchCanClaimNftListAndMyIcoTotalUsd() async {
    String addr = store.account!.currentAccount.address;
    try {
      var res = await apiRoot
          .evalJavascript('dico.fetchCanClaimNftListAndMyIcoTotalUsd("$addr")');
      if (res != null) {
        return res as List;
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }

    return null;
  }

  /// Fetch nft on sale list
  Future<List?> fetchNftOnSaleList() async {
    try {
      var res = await apiRoot.evalJavascript('dico.fetchNftOnSaleList()');
      if (res != null) {
        return res as List;
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }

    return null;
  }

  /// Fetch my nft token list
  Future<void> fetchMyNftTokenList({dynamic initFectchData}) async {
    String addr = store.account!.currentAccount.address;

    try {
      List? res;
      if (initFectchData != null) {
        res = initFectchData as List?;
      } else {
        res = await apiRoot.evalJavascript('dico.fetchMyNftTokenList("$addr")');
      }
      if (res != null) {
        List<NftTokenInfoModel> list =
            res.map((e) => NftTokenInfoModel.fromJson(e)).toList();
        store.dico!.setMyNftTokenList(list);
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
  }

  ///sub balance change
  Future<void> subBalanceChange() async {
    String addr = store.account!.currentAccount.address;
    String pubKey = store.account!.currentAccount.pubKey;
    if (addr.isNotEmpty) {
      await apiRoot.evalJavascript(
        'dico.subBalanceChange("$addr","$pubKey")',
      );
    }
  }

  ///Sub lbp pools change
  Future<void> subLbpPoolsChange() async {
    String addr = store.account!.currentAccount.address;
    if (addr.isNotEmpty) {
      await apiRoot.evalJavascript(
        'dico.subLbpPoolsChange("$addr")',
      );
    }
  }

  ///Sub farm pools change
  Future<void> subFarmPoolsChange() async {
    String addr = store.account!.currentAccount.address;
    if (addr.isNotEmpty) {
      await apiRoot.evalJavascript(
        'dico.subFarmPoolsChange("$addr")',
      );
    }
  }

  ///Sub farm pool extends change
  Future<void> subFarmPoolExtendsChange() async {
    String addr = store.account!.currentAccount.address;
    if (addr.isNotEmpty) {
      await apiRoot.evalJavascript(
        'dico.subFarmPoolExtendsChange("$addr")',
      );
    }
  }

  ///Sub liquidity list change
  Future<void> subLiquidityListChange() async {
    String addr = store.account!.currentAccount.address;
    await apiRoot.evalJavascript('dico.subLiquidityListChange("$addr")');
  }

  ///sub token balance
  Future<void> subTokensBalanceChange() async {
    String addr = store.account!.currentAccount.address;
    List tokens = store.dico?.tokens?.map((e) => e.currencyId).toList() ?? [];
    if (tokens.isNotEmpty) {
      await apiRoot
          .evalJavascript('dico.subTokensBalanceChange("$addr",$tokens)');
    }
  }

  ///sub new heads change
  Future<void> subNewHeadsChange() async {
    String addr = store.account!.currentAccount.address;
    if (addr.isNotEmpty) {
      await apiRoot.evalJavascript('dico.subNewHeads()');
    }
  }

  /// sub change together :
  /// await dico!.subBalanceChange();
  /// await dico!.subNewHeadsChange();
  /// await dico!.subLiquidityListChange();
  /// await dico!.subLbpPoolsChange();
  /// await dico!.subFarmPoolsChange();
  Future<void> subChangeTogether() async {
    String addr = store.account!.currentAccount.address;
    String pubKey = store.account!.currentAccount.pubKey;
    if (addr.isNotEmpty) {
      await apiRoot.evalJavascript(
        'dico.subChangeTogether("$addr","$pubKey")',
      );
    }
  }

  /// Fetch init data
  Future<void> fetchInitData() async {
    String addr = store.account!.currentAccount.address;
    String fields = KycFiledsModel.Area.toString().split(".")[1];
    if (addr.isNotEmpty) {
      var res = await apiRoot.evalJavascript(
        'dico.fetchInitData("$addr","$fields")',
      );
      fetchMyNftTokenList(initFectchData: res[0]);
      fetchpassedIcoes(initFectchData: res[1]);
      fetchReleaseList(initFectchData: res[2]);
      fetchFarmRuleData(initFectchData: res[3]);
      fetchKYCIasListAndSwordHolderList(initFectchData: res[4]);
    }
  }
}
