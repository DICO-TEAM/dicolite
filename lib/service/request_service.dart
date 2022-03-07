import 'package:dicolite/config/config.dart';
import 'package:dicolite/utils/http_manager.dart';
import 'package:dicolite/utils/result_data.dart';

const int tx_list_page_size = 20;

class RequestService {
  static Future getNewVersionData() async {
    return await HttpManager.request(
      '/app/dico-version.json',
      isShowError: false,
    );
  }

  static Future getIpfsData(String url, {bool isPost = true}) async {
    return await HttpManager.request(
      url,
      method: isPost ? "POST" : "GET",
      useBaseUrl: false,
      isShowError: false,
    );
  }

  /// Get token transaction txs
  static Future getTokenTransactionTxs(
      String address, String tokenId, String network, int page) async {
    if (!Config.supportNetworkList.contains(network))
      return ResultData("", 500);
    return await HttpManager.request(
        '${Config.scanBaseUrl}/api/v1/balances/transfer?filter[address]=$address&filter[asset_id]=$tokenId&page[number]=$page',
        method: 'GET',
        useBaseUrl: false);
  }
}
