
import 'package:mobx/mobx.dart';
import 'package:dicolite/store/treasury/types/tipData.dart';
import 'package:dicolite/store/treasury/types/treasuryBalance.dart';

part 'treasury.g.dart';

class TreasuryStore extends _TreasuryStore with _$TreasuryStore {
  // TreasuryStore(AccountStore store) : super(store);
}

abstract class _TreasuryStore with Store {
  // _TreasuryStore(this.account);

  // final AccountStore account;

  @observable
  List<dynamic> members = ObservableList<Map>();

  @observable
  List<dynamic> proposals = ObservableList<Map>();

  @observable
  List<dynamic> approvals = ObservableList<Map>();

  @observable
  List<TipData> tips = [];

  @observable
  int proposalCount = 0;

  @observable
  int spendPeriod = 0;

  @observable
  TreasuryBalance? treasuryBalance;

  @action
  void setMembers(List<dynamic> data) {
    members = data;
  }

  @action
  void setProposals(Map data) {
    proposals = data['proposals'];
    approvals = data['approvals'];
    proposalCount = data['proposalCount'];
  }

  @action
  void setSummary(Map data) {
    spendPeriod = data['spendPeriod'];
    treasuryBalance = TreasuryBalance.fromJson(data['treasuryBalance']);
  }

  @action
  void setTips(List<TipData> data) {
    tips = data;
  }
}