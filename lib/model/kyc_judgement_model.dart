enum KycJudgementModel{
    Pass,
    Unknown,
    OutOfDate,
    LowQuality,
    Erroneous
    // FeePaid,
 
}

List<String> judgementList =KycJudgementModel.values.map((e) => e.toString().split(".")[1]).toList();