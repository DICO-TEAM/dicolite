
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';

class ApiAssets {
  ApiAssets(this.apiRoot);

  final Api apiRoot;
  final store = globalAppStore;

  // Future<void> fetchBalance(String pubKey) async {
  //   if (pubKey != null && pubKey.isNotEmpty) {
  //     String address = store.account!.currentAddress;
  //     Map res = await apiRoot.evalJavascript('account.getBalance("$address")');
  //     store.assets!.setAccountBalances(
  //         pubKey, Map.of({store.settings!.networkState.tokenSymbol: res}));
  //   }
  //   // if (store.settings!.endpoint.info == networkEndpointAcala.info) {
  //   //   apiRoot.acala.fetchTokens(store.account!.currentAccount.pubKey);
  //   //   apiRoot.acala.fetchAirdropTokens();
  //   // }
  // }

  // Future<Map> updateTxs(int page) async {
  //   store.assets!.setTxsLoading(true);

  //   String address = store.account!.currentAddress;
  //   Map res = await apiRoot.subScanApi.fetchTransfersAsync(
  //     address,
  //     page,
  //     network: store.settings!.endpoint.info,
  //   );

  //   if (page == 0) {
  //     store.assets!.clearTxs();
  //   }
  //   // cache first page of txs
  //   await store.assets!.addTxs(res, address, shouldCache: page == 0);

  //   store.assets!.setTxsLoading(false);
  //   return res;
  // }
}
