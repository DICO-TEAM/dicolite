class ElectionData {
  String address="";
  String accountName="";
  String balance="";
  List<dynamic> voters=[];

  ElectionData();

  ElectionData.fromJson(Map data):
    address = data['address'],
    accountName = data['accountName'],
    balance = data['balance'].toString(),
    voters = data['voters'];
  
}