import 'package:mobx/mobx.dart';
import 'package:dicolite/store/council/types/electionData.dart';
import 'package:dicolite/store/council/types/electionsInfo.dart';

part 'council.g.dart';

class CouncilStore extends _CouncilStore with _$CouncilStore {
  // CouncilStore(AccountStore store) : super(store);
}

abstract class _CouncilStore with Store {
  // _CouncilStore(this.account);

  // final AccountStore account;

  @observable
  String primes="";

  @observable
  ElectionsInfo? electionsInfo;

  @observable
  List<ElectionData> candidates = [];

  @observable
  List<ElectionData> members = [];

  @observable
  List<ElectionData> runnersUp = [];

  @observable
  List<ElectionData> checkdElection = [];
  
  @observable
  Map<String, List> allVotes = {};
 
   @observable
  List motions = [];

  @action
  void setPrimes(String primes, {bool shouldCache = true}) {
    primes = primes;
  }

  @action
  void setElectionsInfo(ElectionsInfo info, {bool shouldCache = true}) {
    electionsInfo = info;
  }

  @action
  void setCandidates(List<ElectionData> data, {bool shouldCache = true}) {
    candidates = data;
  }

  @action
  void setMembers(List<ElectionData> data, {bool shouldCache = true}) {
    members = data;
  }

  @action
  void setRunnersUp(List<ElectionData> data, {bool shouldCache = true}) {
    runnersUp = data;
  }

  @action
  void setCheckdElection(List<ElectionData> data, {bool shouldCache = true}) {
    checkdElection = data;
  }

  @action
  void setAllVotes(Map<String, List> data, {bool shouldCache = true}) {
    allVotes = data;
  }

  @action
  void setMotions(List data, {bool shouldCache = true}) {
    motions = data;
  }
 
}