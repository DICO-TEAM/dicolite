import 'package:flutter/material.dart';

class Config {
  static const String tokenId = "0";
  static const String tokenSymbol = "KICO";
  static const int tokenDecimals = 14;

  static const String kUSDid = "10";
  static const String kUSDSymbol = "kUSD";
  static const int kUSDDecimals = 12;
  static const int default_ss58_prefix = 42;
  static const double swapfee = 0.003;
  static const double lbpSwapfee = 0.005;

  static const String farmSupplyPublicKey =
      "0x6d6f646c6469636f2f66616d0000000000000000000000000000000000000000";

  static final BigInt liquidityFirstId =
      BigInt.from(4) * (BigInt.from(10).pow(9));

  static const String kycMessageSuffix =
      "00000000000000000000000000000000000000";
  static const int lbpWeightDecimals = 10;

  static const int liquidityDecimals = 10;
  static const List ipfsNodeList = [
    {"desc": "IPFS node", "url": "https://ipfs.dico.io"},
  ];

  static String logo = "assets/logo.png";
  static String logoCDN =
      "https://cdn.jsdelivr.net/gh/DICO-TEAM/resources/logo/";
  static List<String> areaCode = [
    "AD",
    "AE",
    "AF",
    "AG",
    "AI",
    "AL",
    "AM",
    "AO",
    "AQ",
    "AR",
    "AS",
    "AT",
    "AU",
    "AW",
    "AX",
    "AZ",
    "BA",
    "BB",
    "BD",
    "BE",
    "BF",
    "BG",
    "BH",
    "BI",
    "BJ",
    "BL",
    "BM",
    "BN",
    "BO",
    "BQ",
    "BR",
    "BS",
    "BT",
    "BV",
    "BW",
    "BY",
    "BZ",
    "CA",
    "CC",
    "CD",
    "CF",
    "CG",
    "CH",
    "CI",
    "CK",
    "CL",
    "CM",
    "CN",
    "CO",
    "CR",
    "CU",
    "CV",
    "CW",
    "CX",
    "CY",
    "CZ",
    "DE",
    "DJ",
    "DK",
    "DM",
    "DO",
    "DZ",
    "EC",
    "EE",
    "EG",
    "EH",
    "ER",
    "ES",
    "ET",
    "FI",
    "FJ",
    "FK",
    "FM",
    "FO",
    "FR",
    "GA",
    "GB",
    "GD",
    "GE",
    "GF",
    "GG",
    "GH",
    "GI",
    "GL",
    "GM",
    "GN",
    "GP",
    "GQ",
    "GR",
    "GS",
    "GT",
    "GU",
    "GW",
    "GY",
    "HK",
    "HM",
    "HN",
    "HR",
    "HT",
    "HU",
    "ID",
    "IE",
    "IL",
    "IM",
    "IN",
    "IO",
    "IQ",
    "IR",
    "IS",
    "IT",
    "JE",
    "JM",
    "JO",
    "JP",
    "KE",
    "KG",
    "KH",
    "KI",
    "KM",
    "KN",
    "KP",
    "KR",
    "KW",
    "KY",
    "KZ",
    "LA",
    "LB",
    "LC",
    "LI",
    "LK",
    "LR",
    "LS",
    "LT",
    "LU",
    "LV",
    "LY",
    "MA",
    "MC",
    "MD",
    "ME",
    "MF",
    "MG",
    "MH",
    "MK",
    "ML",
    "MM",
    "MN",
    "MO",
    "MP",
    "MQ",
    "MR",
    "MS",
    "MT",
    "MU",
    "MV",
    "MW",
    "MX",
    "MY",
    "MZ",
    "NA",
    "NC",
    "NE",
    "NF",
    "NG",
    "NI",
    "NL",
    "NO",
    "NP",
    "NR",
    "NU",
    "NZ",
    "OM",
    "PA",
    "PE",
    "PF",
    "PG",
    "PH",
    "PK",
    "PL",
    "PM",
    "PN",
    "PR",
    "PS",
    "PT",
    "PW",
    "PY",
    "QA",
    "RE",
    "RO",
    "RS",
    "RU",
    "RW",
    "SA",
    "SB",
    "SC",
    "SD",
    "SE",
    "SG",
    "SH",
    "SI",
    "SJ",
    "SK",
    "SL",
    "SM",
    "SN",
    "SO",
    "SR",
    "SS",
    "ST",
    "SV",
    "SX",
    "SY",
    "SZ",
    "TC",
    "TD",
    "TF",
    "TG",
    "TH",
    "TJ",
    "TK",
    "TL",
    "TM",
    "TN",
    "TO",
    "TR",
    "TT",
    "TV",
    "TW",
    "TZ",
    "UA",
    "UG",
    "UM",
    "US",
    "UY",
    "UZ",
    "VA",
    "VC",
    "VE",
    "VG",
    "VI",
    "VN",
    "VU",
    "WF",
    "WS",
    "YE",
    "YT",
    "ZA",
    "ZM",
    "ZW"
  ];
  static String baseUrl = "https://dico.io";

  static String scanBaseUrl = "https://scan.kico.dico.io";
  static String scanUrl = "https://scan.kico.dico.io/kico-chain";

  static const List<String> template1List = [
    "BY",
    "CN",
    "CD",
    "CU",
    "IQ",
    "IR",
    "KP",
    "SD",
    "SY",
    "US",
    "AS",
    "GU",
    "MP",
    "PR",
    "VI",
    "ZW"
  ];
  static const List<String> template2List = [
    "JP",
    "CU",
    "IR",
    "CN",
    "HK",
    "MO",
    "KP",
    "SD",
    "SY",
    "US",
    "AS",
    "GU",
    "MP",
    "PR",
    "VI",
    "CA",
    "SG"
  ];

  static const List<String> networkList = [
    "kico",
    "dico",
  ];

  static const List<String> supportNetworkList = [
    "kico",
  ];

  static const List<String> nftNameList = [
    "All",
    "Rookie",
    "Angel",
    "Wall Street Elite",
    "Unicorn Hunter",
    "Mafia",
    "Grandmaster",
    "Other",
  ];
  static const List<List> nftList = [
    /// [name, require ico USD, fee,id]
    ["Rookie", 100, 1, "0"],
    ["Angel", 1000, 100, "1"],
    ["Wall Street Elite", 10000, 1000, "2"],
    ["Unicorn Hunter", 100000, 10000, "3"],
    ["Mafia", 1000000, 100000, "4"],
    ["Grandmaster", 10000000, 1000000, "5"],
  ];

  static const String kicoNode = 'wss://rpc.kico.dico.io';
  static const String testNode = 'wss://rpc.tico.dico.io';
  static const String nftImageUrl = 'https://crustipfs.xyz/ipfs/';
  static const Color themeColor = Color(0xFF00CEA6);
  static const Color bgColor = Color(0xFFF8F8F8);
  static const Color colorfff07 = Color(0xBBFFFFFF);
  static const Color color333 = Color(0xFF333333);
  static const Color color666 = Color(0xFF666666);
  static const Color color999 = Color(0xFF999999);
  static const Color secondColor = Colors.blue;
  static const Color errorColor = Color(0xFFF14B79);
}