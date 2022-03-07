import 'package:mobx/mobx.dart';

part 'public.g.dart';

class PublicStore extends _PublicStore with _$PublicStore {
  // PublicStore(AccountStore store) : super(store);
}

abstract class _PublicStore with Store {
  // _PublicStore(this.account);

  // final AccountStore account;

  @observable
  int bestNumber = 0;

  @action
  void setBestNumber(int number) {
    bestNumber = number;
  }
}