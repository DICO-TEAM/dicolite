import 'package:cached_network_image/cached_network_image.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/nft_token_info_model.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:flutter/material.dart';

class NftItem extends StatelessWidget {
  const NftItem(this.nft, {Key? key}) : super(key: key);
  final NftTokenInfoModel nft;

  @override
  Widget build(BuildContext context) {
    S dic = S.of(context);
    return Card(
      key: Key(nft.data.classId + (nft.tokenId ?? "")),
      margin: EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    color: Config.bgColor,
                    child: CachedNetworkImage(
                      imageUrl: nft.imageUrl,
                      width: Adapt.px(140),
                      height: Adapt.px(140),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nft.level,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: Adapt.px(30)),
                      ),
                      Text(
                        "#${nft.data.classId}-${nft.tokenId ?? ''}",
                      ),
                    ],
                  ),
                ),
              ),
              nft.data.status.isInSale
                  ? Container(
                      padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFFF3D00),
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(15),
                        ),
                      ),
                      child: Text(
                        dic.on_sale,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Container(),
              nft.data.status.isActiveImage
                  ? Container(
                     padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(15),
                        ),
                      ),
                    child: Text(
                        dic.avatar,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
