import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const customTypesKey = 'custom_types';
  static const useBioKey = 'use_bio';
  static const accountsKey = 'wallet_account_list';
  static const userInfoKey = 'user_info';
  static const customEnterPointListInfoKey = 'custom_enter_point_list';
  static const registerStatusKey = 'register_status';
  static const receiveAddressesKey = 'receive_addresses_list';
  static const currentAccountKey = 'wallet_current_account';
  static const contactsKey = 'wallet_contact_list';
  static const localeKey = 'wallet_locale';
  static const endpointKey = 'wallet_endpoint';
  static const customSS58Key = 'wallet_custom_ss58';
  static const seedKey = 'wallet_seed';
  static const customKVKey = 'wallet_kv';
  static const isShowAmountKey = 'is_show_amount';
  static const tokensKey = 'tokens';
  static const myNftListKey = 'my_nft_list';

  static final storage = new _LocalStorage();

  static Future<void> setIsShowAmount(bool isShowAmount) async {
    return storage.setKV(isShowAmountKey, isShowAmount.toString());
  }

  static Future<bool> getIsShowAmount() async {
    return (await storage.getKV(isShowAmountKey) ?? "false") == "true";
  }

  static Future<void> setCustomTypes(String? customTypes) async {
    return storage.setKV(customTypesKey, customTypes);
  }

  static Future<String?> getCustomTypes() async {
    return storage.getKV(customTypesKey);
  }

  static Future<void> updateTokenToList(Map<String, dynamic> token) async {
    return await storage.updateItemInList(
        tokensKey, 'currencyId', token['currencyId'], token);
  }

  static Future<void> removeTokenFromList(Map<String, dynamic> token) async {
    return await storage.removeItemFromList(
        tokensKey, 'currencyId', token['currencyId']);
  }

  Future<void> setTokens(List<Map<String, dynamic>>? val) async {
    return await storage.setKV(tokensKey, jsonEncode(val));
  }

  Future<List<Map<String, dynamic>>?> getTokens() async {
    return storage.getList(tokensKey);
  }

  Future<void> setMyNftList(List<Map<String, dynamic>>? val) async {
    return await storage.setKV(myNftListKey, jsonEncode(val));
  }

  Future<List<Map<String, dynamic>>?> getMyNftList() async {
    return storage.getList(myNftListKey);
  }

  //Clear all local storage
  static Future clearAllLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    keys.map((e) => prefs.remove(e));
  }

  static Future<void> setUseBio(
      bool useBio, String publicKey) async {
    String? useBioMap = await storage.getKV(useBioKey);
    Map map;
    try {
      map = useBioMap != null
          ? jsonDecode(useBioMap)
          : Map();
    } catch (e) {
      print(e);
      map = Map();
    }

    map[publicKey] = useBio;

    return storage.setKV(useBioKey, jsonEncode(map));
  }

  static Future<bool> getUseBio(String publicKey) async {
    String? useBioMap = await storage.getKV(useBioKey);
    if (useBioMap == null) return false;
    try {
      Map map = jsonDecode(useBioMap);
      bool? isUse = map[publicKey];
      return isUse == null ? false : isUse;
      // return isUse==null?false:isUse=='true';
    } catch (e) {
      return false;
    }
  }

 


  static Future<void> addCustomEnterPointListInfo(
      Map<String, dynamic> node) async {
    return storage.addItemToList(customEnterPointListInfoKey, node);
  }

  static Future<List<Map<String, dynamic>>> getCustomEnterPointList() async {
    return storage.getList(customEnterPointListInfoKey);
  }

  static Future<void> removeCustomEnterPointList() async {
    await storage.setKV(customEnterPointListInfoKey, null);
  }

  ///
  static Future<void> addReceiveAddresses(Map<String, dynamic> con) async {
    return storage.addItemToList(receiveAddressesKey, con);
  }

  ///
  static Future<void> addReceiveAddressesList(
      List<Map<String, dynamic>> list) async {
    return storage.setKV(receiveAddressesKey, jsonEncode(list));
  }

  static Future<void> removeReceiveAddresses(String symbol) async {
    return storage.removeItemFromList(receiveAddressesKey, 'symbol', symbol);
  }

  static Future<void> updateReceiveAddresses(Map<String, dynamic> con) async {
    return storage.updateItemInList(
        receiveAddressesKey, 'symbol', con['symbol'], con);
  }

  static Future<List<Map<String, dynamic>>> getReceiveAddresses() async {
    return storage.getList(receiveAddressesKey);
  }

  Future<void> addAccount(Map<String, dynamic> acc) async {
    return storage.addItemToList(accountsKey, acc);
  }

  Future<void> removeAccount(String? pubKey) async {
    if (pubKey == null) return;
    return storage.removeItemFromList(accountsKey, 'pubKey', pubKey);
  }

  Future<List<Map<String, dynamic>>> getAccountList() async {
    return storage.getList(accountsKey);
  }

  Future<void> setCurrentAccount(String pubKey) async {
    return storage.setKV(currentAccountKey, pubKey);
  }

  Future<String?> getCurrentAccount() async {
    return storage.getKV(currentAccountKey);
  }

  Future<void> addContact(Map<String, dynamic> con) async {
    return storage.addItemToList(contactsKey, con);
  }

  Future<void> removeContact(String address) async {
    return storage.removeItemFromList(contactsKey, 'address', address);
  }

  Future<void> updateContact(Map<String, dynamic> con) async {
    return storage.updateItemInList(
        contactsKey, 'address', con['address'], con);
  }

  Future<List<Map<String, dynamic>>> getContactList() async {
    return storage.getList(contactsKey);
  }

  Future<void> setSeeds(String seedType, Map value) async {
    return storage.setKV('${seedKey}_$seedType', jsonEncode(value));
  }

  Future<Map> getSeeds(String seedType) async {
    String? value = await storage.getKV('${seedKey}_$seedType');
    if (value != null) {
      return jsonDecode(value);
    }
    return {};
  }

  static Future<void> setKV(String key, Object value) async {
    // String str = await compute(jsonEncode, value);
    String str = jsonEncode(value);
    return storage.setKV('${customKVKey}_$key', str);
  }

  static Future<Object?> getKV(String key) async {
    String? value = await storage.getKV('${customKVKey}_$key');
    if (value != null) {
      // Object data = await compute(jsonDecode, value);
      Object data = jsonDecode(value);
      return data;
    }
    return null;
  }

  Future<void> setObject(String key, Object value) async {
    // String str = await compute(jsonEncode, value);
    String str = jsonEncode(value);
    return storage.setKV('${customKVKey}_$key', str);
  }

  Future<Object?> getObject(String key) async {
    String? value = await storage.getKV('${customKVKey}_$key');
    if (value != null) {
      // Object data = await compute(jsonDecode, value);
      Object data = jsonDecode(value);
      return data;
    }
    return null;
  }

  Future<void> setAccountCache(
      String accPubKey, String key, Object value) async {
    Map? data = await getKV(key) as Map?;
    if (data == null) {
      data = {};
    }
    data[accPubKey] = value;
    setKV(key, data);
  }

  Future<Map?> getAccountCache(String accPubKey, String key) async {
    Map? data = await getKV(key) as Map?;
    if (data == null) {
      return null;
    }
    return data[accPubKey];
  }

  // cache timeout 10 minutes
  static const int customCacheTimeLength = 10 * 60 * 1000;

  static bool checkCacheTimeout(int cacheTime) {
    return DateTime.now().millisecondsSinceEpoch - customCacheTimeLength >
        cacheTime;
  }
}

class _LocalStorage {
  Future<String?> getKV(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> setKV(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      prefs.remove(key);
    } else {
      prefs.setString(key, value);
    }
  }

  Future<void> addItemToList(String storeKey, Map<String, dynamic> acc) async {
    List<Map<String, dynamic>> ls = [];

    String? str = await getKV(storeKey);
    if (str != null) {
      Iterable l = jsonDecode(str);
      ls = l.map((i) => Map<String, dynamic>.from(i)).toList();
    }

    ls.add(acc);

    setKV(storeKey, jsonEncode(ls));
  }

  Future<void> removeItemFromList(
      String storeKey, String itemKey, String itemValue) async {
    var ls = await getList(storeKey);
    ls.removeWhere((item) => item[itemKey] == itemValue);
    setKV(storeKey, jsonEncode(ls));
  }

  Future<void> updateItemInList(String storeKey, String itemKey,
      String itemValue, Map<String, dynamic> itemNew) async {
    var ls = await getList(storeKey);
    ls.removeWhere((item) => item[itemKey] == itemValue);
    ls.add(itemNew);
    setKV(storeKey, jsonEncode(ls));
  }

  Future<List<Map<String, dynamic>>> getList(String storeKey) async {
    List<Map<String, dynamic>> res = [];

    String? str = await getKV(storeKey);
    if (str != null) {
      Iterable l = jsonDecode(str);
      res = l.map((i) => Map<String, dynamic>.from(i)).toList();
    }
    return res;
  }
}
