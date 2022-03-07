import 'package:mobx/mobx.dart';
import 'package:dicolite/store/democracy/types/democracyInfo.dart';
import 'package:dicolite/store/democracy/types/externalData.dart';
import 'package:dicolite/store/democracy/types/proposalData.dart';
import 'package:dicolite/store/democracy/types/referendumData.dart';

part 'democracy.g.dart';

class DemocracyStore extends _DemocracyStore with _$DemocracyStore {
  // DemocracyStore(AccountStore store) : super(store);
}

abstract class _DemocracyStore with Store {
  // _DemocracyStore(this.account);

  // final AccountStore account;

  @observable
  DemocracyInfo? democracyInfo;

  @observable
  List<ReferendumData> referendums = [];
  
  @observable
  List<ProposalData> proposals = [];
 
  @observable
  List<ProposalData> dispatchQueue = [];

  @observable
  ExternalData? nextExternal;

  @action
  void setDemocracyInfo(DemocracyInfo data, {bool shouldCache = true}) {
    democracyInfo = data;
  }

  @action
  void setReferendums(List<ReferendumData> data, {bool shouldCache = true}) {
    referendums = data;
  }

  @action
  void setProposals(List<ProposalData> data, {bool shouldCache = true}) {
    proposals = data;
  }

  @action
  void setDispatchQueue(List<ProposalData> data, {bool shouldCache = true}) {
    dispatchQueue = data;
  }

  @action
  void setNextExternal(ExternalData data, {bool shouldCache = true}) {
    nextExternal = data;
  }
 
}