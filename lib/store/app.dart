import 'package:mobx/mobx.dart';
import 'package:dicolite/store/council/council.dart';
import 'package:dicolite/store/democracy/democracy.dart';
import 'package:dicolite/store/public.dart';
import 'package:dicolite/store/account/account.dart';
import 'package:dicolite/store/assets/assets.dart';
import 'package:dicolite/store/gov/governance.dart';
import 'package:dicolite/store/settings.dart';
import 'package:dicolite/store/dico.dart';
import 'package:dicolite/store/treasury/treasury.dart';
import 'package:dicolite/utils/local_storage.dart';

// part 'app.g.dart';

final AppStore globalAppStore = AppStore();

class AppStore with Store {
  @observable
  AccountStore? account;

  @observable
  AssetsStore? assets;

  @observable
  PublicStore? public;


  @observable
  DemocracyStore? democ;

  @observable
  CouncilStore? council;

  @observable
  GovernanceStore? gov;

  @observable
  TreasuryStore? treasury;

  @observable
  SettingsStore? settings;

  @observable
  bool isReady = false;

  @observable
  DicoStore? dico;

  LocalStorage localStorage = LocalStorage();

  @action
  Future<void> init(String sysLocaleCode) async {
    // wait settings store loaded
    settings = SettingsStore(this);
    await settings?.init(sysLocaleCode);
    dico = DicoStore(this);
    await dico?.init();

    account = AccountStore(this);
    await account?.loadAccount();
    assets = AssetsStore(this);
    gov = GovernanceStore(this);
    public = PublicStore();
    democ = DemocracyStore();
    council = CouncilStore();
    treasury = TreasuryStore();

    assets?.loadCache();
    // gov.loadCache();

    isReady = true;
  }
}
