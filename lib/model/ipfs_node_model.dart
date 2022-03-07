class IpfsNodeModel {
  String desc;
  String url;

  IpfsNodeModel(this.desc,this.url);

  IpfsNodeModel.fromJson(json)
      : desc = json["desc"],
        url = json["url"];
}
