import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/dao_proposal_model.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:flutter/material.dart';

class VoteRateLine extends StatelessWidget {
  const VoteRateLine(this.proposal, {Key? key}) : super(key: key);

  final DaoProposalModel proposal;

  ///

  @override
  Widget build(BuildContext context) {
    S dic = S.of(context);
    final int ayes = computeAyeRate(proposal);

    ///
    final int nays = computeNayRate(proposal);

    final int threshold = proposal.threshold;

    /// between 0 ~ 1
    double ayesRate = ayes / 100;

    /// between 0 ~ 1
    double naysRate = nays / 100;

    double progressWidth = Adapt.px(300);
    double lightingProgress = progressWidth * threshold / 100;
    double ayesProgress = progressWidth * ayesRate;
    double naysProgress = progressWidth * naysRate;
    double height = 16;
    double lineHeight = 4;

    Color ayeBgColor = Theme.of(context).primaryColor.withAlpha(50);
    Color ayeColor = Theme.of(context).primaryColor;

    Color nayBgColor = Colors.orange.withAlpha(50);
    Color nayColor = Colors.orange;
    bool? isPassing;

    if (ayes >= threshold) {
      isPassing = true;
    } else if (nays >= (100 - threshold)) {
      isPassing = false;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                dic.aye,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                "($ayes%/$threshold%)",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
        Column(
          children: [
            isPassing != null
                ? Row(
                    children: [
                      isPassing
                          ? Icon(Icons.check_circle,
                              color: Theme.of(context).primaryColor, size: 20)
                          : Icon(Icons.remove_circle,
                              color: Colors.orange, size: 20),
                      Text(
                        isPassing ? dic.passing_true : dic.passing_false,
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                      ),
                    ],
                  )
                : Container(),
            Container(
              width: progressWidth,
              height: height,
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: height,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            child: Container(
                              margin: EdgeInsets.only(
                                top: (height / 2) - (lineHeight / 2),
                              ),
                              width: lightingProgress,
                              height: lineHeight,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular((lineHeight / 2)),
                                color: ayeBgColor,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              margin: EdgeInsets.only(
                                top: (height / 2) - (lineHeight / 2),
                              ),
                              width: (progressWidth - lightingProgress),
                              height: lineHeight,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular((lineHeight / 2)),
                                color: nayBgColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      height: height,
                      child: Stack(
                        children: [
                          
                          Positioned(
                            left: 0,
                            child: Container(
                              margin: EdgeInsets.only(
                                top: (height / 2) - (lineHeight / 2),
                              ),
                              width: ayesProgress,
                              height: lineHeight,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular((lineHeight / 2)),
                                color: ayeColor,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              margin: EdgeInsets.only(
                                top: (height / 2) - (lineHeight / 2),
                              ),
                              width: naysProgress,
                              height: lineHeight,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular((lineHeight / 2)),
                                color: nayColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: lightingProgress - 5,
                    child: Image.asset(
                      "assets/images/dico/lightning.png",
                      height: height,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                dic.nay,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                "($nays%/${100 - threshold}%)",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
