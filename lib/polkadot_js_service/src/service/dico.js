import {
  hexToString,
  u8aToString,
  hexToU8a,
  u8aToHex
} from "@polkadot/util";
import {
  cryptoWaitReady,
} from "@polkadot/util-crypto";
import {
  Keyring
} from "@polkadot/api";
let keyring = new Keyring({
  ss58Format: 42,
  type: "sr25519"
});
import kyc from '../utils/kyc';

async function fetchKYCInfo(addr) {
  try {
    var [reskycof, resList] = await Promise.all([
      api.query.kyc.kycOf(addr),
      api.query.kyc.applicationFormList(addr)

    ])
    if (reskycof) {

      reskycof = reskycof.toJSON()
      reskycof.info.name = hexToString(reskycof.info.name)
      reskycof.info.curvePublicKey = reskycof.info.curvePublicKey
      reskycof.info.email = hexToString(reskycof.info.email)
    }
    resList = resList.toJSON()

    return [reskycof, resList]
  } catch (error) {
    window.send("log", error)
  }

  return null;
}

async function fetchIasMessageList(addr) {
  try {
    var messageList = []
    var keys = await api.query.kyc.applicationFormList.keys();
    var appliList = []
    if (keys.length) {
      var senders = keys.map(e => e.args[0].toJSON());
      var senderList = [];

      var res = await api.query.kyc.applicationFormList.multi(senders);
      res = res.map((e, i) => {
        e = e.toJSON()
        e.forEach((x) => {
          if (x.progress == "IasDoing" && x.ias[1].account == addr) {
            x.sender = senders[i]
            senderList.push(x.sender)
            appliList.push(x)
          }
        })
        return e
      });
      var list = senderList.map(e => [e, addr]);


      if (list.length) {
        messageList = await api.query.kyc.messageList.multi(list);
        messageList = messageList.map((e, i) => {
          e = e.toJSON()
          appliList[i].message = hexToString(e[e.length - 1])
        })
      }
    }
    return appliList;
  } catch (error) {
    window.send("log", error)
  }

  return null;
}

async function fetchSwordHolderMessageList(addr) {
  try {
    var messageList = []
    var keys = await api.query.kyc.applicationFormList.keys();
    var appliList = []
    if (keys.length) {
      var senders = keys.map(e => e.args[0].toJSON());
      var senderList = [];

      var res = await api.query.kyc.applicationFormList.multi(senders);
      res = res.map((e, i) => {
        e = e.toJSON()
        e.forEach((x) => {
          if (x.progress == "IasDone" && x.swordHolder[1].account == addr) {
            x.sender = senders[i]
            senderList.push(x.ias[1].account)
            appliList.push(x)
          }
        })
        return e
      });
      var list = senderList.map(e => [e, addr]);


      if (list.length) {
        messageList = await api.query.kyc.messageList.multi(list);
        messageList = messageList.map((e, i) => {
          e = e.toJSON()
          appliList[i].message = hexToString(e[e.length - 1])
        })
      }
    }
    return appliList;
  } catch (error) {
    window.send("log", error)
  }

  return null;
}

async function fetchKYCMyCurvePublicKey(mySeed) {
  try {

    var res = kyc.getCurvePublicKey(mySeed);
    return res;
  } catch (error) {
    window.send("log", error)
  }
  return null;
}

async function encryptKYCMessage(message, otherPublic, seed) {
  try {
    var res = kyc.encryptMessage(message, otherPublic, seed);
    return res;
  } catch (error) {
    window.send("log", error)
  }
  return null;
}

async function decryptKYCMessage(message, otherPublic, seed) {
  try {
    var res = kyc.decryptMessage(message, otherPublic, seed);
    return res;
  } catch (error) {
    window.send("log", error)
  }
  return null;
}


async function fetchKYCIasListAndSwordHolderList(fields) {
  try {
    var res = await Promise.all([
      api.query.kyc.iasListOf(fields),
      api.query.kyc.swordHolderOf(fields),
    ])
    res = res.map(e => e.toJSON())
    return res
  } catch (error) {
    window.send("log", error.toString())
  }

  return null;
}

async function fetchKYCRecommandFee(fields) {
  try {
    var res = await Promise.all([
      api.query.kyc.iasListOf(fields),
      api.query.kyc.swordHolderOf(fields),
    ])
    res = res.map(e => e.toJSON())
    var s1 = res[0].sort((a, b) => a.fee - b.fee)
    var s2 = res[1].sort((a, b) => a.fee - b.fee)
    if (s1 && s2) {
      return Math.max((s2[0]?.fee ?? 0), (s1[0]?.fee ?? 0)) * 2;
    }
  } catch (error) {
    window.send("log", error.toString())
  }

  return null;
}

/** fetch all initiatedIcoesOf ico list */
async function fetchInitiatedIcoesOf(addr) {
  try {
    var res = await api.query.ico.initiatedIcoesOf(addr);
    res = res.toJSON()

    if (res != null) {
      res.map(e => {
        e.desc = hexToString(e.desc);
        e.tokenSymbol = hexToString(e.tokenSymbol);
        return e
      })
    }
    return res;
  } catch (error) {
    window.send("log", error.toString())
  }
  return null;
}

/** fetch pendingIco */
async function fetchPendingIco(addr) {
  try {
    var res = await api.query.ico.pendingIco();
    res = res.toJSON()
    res = res.filter(e => e.ico.initiator == addr)

    if (res != null) {
      res.map(e => {
        e.ico.desc = hexToString(e.ico?.desc);

        e.ico.officialWebsite = hexToString(e.ico?.officialWebsite);
        e.ico.projectName = hexToString(e.ico?.projectName);
        e.ico.tokenSymbol = hexToString(e.ico?.tokenSymbol);
        return e
      })
    }
    return res;
  } catch (error) {
    window.send("log", error.toString())
  }
  return null;
}

/** fetch fetchIcoListByIdAndIndex */
async function fetchIcoListByIdAndIndexList(list) {
  if (list && list.length) {

    try {
      var res = await api.query.ico.ico.multi(list);
      var initiatorList = [];
      res = res.map(e => {
        e = e.toJSON();
        e.desc = hexToString(e.desc);
        e.officialWebsite = hexToString(e.officialWebsite);
        e.projectName = hexToString(e.projectName);
        e.tokenSymbol = hexToString(e.tokenSymbol);
        initiatorList.push(e.initiator);
        return e
      })
      var unReleaseData = await api.query.ico.unReleaseAssets.multi(initiatorList)
      unReleaseData = unReleaseData.map(e => {
        e = e.toJSON()
        return e
      })
      res = res.map((e, i) => {
        e.totalUnrealeaseAmount = unReleaseData[i]?.find(x => x.currencyId == e.currencyId && x.index == e.index)?.total ?? null;
        return e;
      })
      return res;
    } catch (error) {
      window.send("log", error.toString())
    }
    return null;
  } else {
    return []
  }
}

/** fetch passed Icoe  list */
async function fetchpassedIcoes() {
  try {
    var list = await api.query.ico.passedIcoes();
    var res = await fetchIcoListByIdAndIndexList(list)
    return res;
  } catch (error) {
    window.send("log", error.toString())
  }
  return null;
}


/** Fetch user join ico amount */
async function fetchUserJoinIcoAmount(addr) {
  try {
    var myJoinIco = await api.query.ico.unReleaseAssets(addr)
    myJoinIco = myJoinIco.map(e => e.toJSON())
    var list = myJoinIco.map(e => [e.currencyId, e.index])
    var icoRes = await fetchIcoListByIdAndIndexList(list)
    return [myJoinIco, icoRes];
  } catch (error) {
    window.send("log", error.toString())
  }
  return null;
}


/** fetch token info */
async function fetchTokenInfo(currencyId, addr) {

  try {
    var [res, resTotal, resBalance] = await Promise.all([
      api.query.currencies.dicoAssetsInfo(currencyId),
      api.query.tokens.totalIssuance(currencyId),
      api.query.tokens.accounts(addr, currencyId)
    ]);
    res = res.toJSON()
    if (res != null && res.metadata != null) {
      res.metadata.name = hexToString(res.metadata.name)
      res.metadata.symbol = hexToString(res.metadata.symbol)
      if (resTotal) {
        res.totalIssuance = resTotal.toString() ?? 0;
      }
      if (resBalance) {
        res.tokenBalance = resBalance.toJSON();
      }
      res.currencyId = currencyId;
    }
    return res;
  } catch (error) {
    window.send("log", error.toString())
  }
  return null;
}

/** fetch all token info list */
async function fetchAllTokenInfoList(addr) {
  var keys = await api.query.currencies.dicoAssetsInfo.keys()
  if (keys.length) {
    var currencyIds = keys.map(e => e.args[0].toJSON());
    var sendList = currencyIds.map(e => [addr, e]);
    try {
      var [resList, resTotal, resBalance] = await Promise.all([
        api.query.currencies.dicoAssetsInfo.multi(currencyIds),
        api.query.tokens.totalIssuance.multi(currencyIds),
        api.query.tokens.accounts.multi(sendList)
      ]);
      resList = resList.map((res, i) => {
        res = res.toJSON()
        if (res != null && res.metadata != null) {
          res.metadata.name = hexToString(res.metadata.name)
          res.metadata.symbol = hexToString(res.metadata.symbol)
          if (resTotal[i]) {
            res.totalIssuance = resTotal[i].toString() ?? 0;
          }
          if (resBalance) {
            res.tokenBalance = resBalance[i].toJSON();
          }
          res.currencyId = currencyIds[i];
        }
        return res;
      });
      return resList.filter((x)=>x!=null&&x.metadata!=null);
    } catch (error) {
      window.send("log", error.toString())
    }
  }
  return [];
}

/** fetch token info list */
async function fetchTokenInfoList(currencyIds, addr) {
  var sendList = currencyIds.map(e => [addr, e]);
  try {
    var [resList, resTotal, resBalance] = await Promise.all([
      api.query.currencies.dicoAssetsInfo.multi(currencyIds),
      api.query.tokens.totalIssuance.multi(currencyIds),
      api.query.tokens.accounts.multi(sendList)
    ]);
    resList = resList.map((res, i) => {
      res = res.toJSON()
      if (res != null && res.metadata != null) {
        res.metadata.name = hexToString(res.metadata.name)
        res.metadata.symbol = hexToString(res.metadata.symbol)
        if (resTotal[i]) {
          res.totalIssuance = resTotal[i].toString() ?? 0;
        }
        if (resBalance) {
          res.tokenBalance = resBalance[i].toJSON();
        }
        res.currencyId = currencyIds[i];
      }
      return res;
    });
    return resList;
  } catch (error) {
    window.send("log", error.toString())
  }
  return null;
}

/** fetch token info */
async function fetchMinMaxUSDTAmount() {

  try {
    var [min, max] = await Promise.all([
      api.query.ico.icoMinUsdtAmount(),
      api.query.ico.icoMaxUsdtAmount(),
    ]);

    return [min.toString(), max.toString()];
  } catch (error) {
    window.send("log", error.toString())
  }
  return null;
}

/**Fetch ico get amount */
async function fetchIcoGetAmount(addr, currencyId, index) {
  try {
    var list = await Promise.all([
      api.query.ico.icoLocks(addr, currencyId,),
      api.rpc.ico.canReleaseAmount(addr, currencyId, index),
      api.rpc.ico.canUnlockAmount(addr, currencyId, index),
      api.rpc.ico.getRewardAmount(addr, currencyId, index),
      api.rpc.ico.canJoinAmount(addr, currencyId, index),
    ]);

    return list;
  } catch (error) {
    window.send("log", error.toString())
  }
  return null;
}

/**Fetch farm rule data */
async function fetchFarmRuleData() {
  try {
    var list = await Promise.all([
      api.query.farm.startBlock(),
      api.query.farm.halvingPeriod(),
      api.query.farm.dicoPerBlock(),
    ]);

    return list;
  } catch (error) {
    window.send("log", error.toString())
  }
  return null;
}

/** fetch Dao Propose List */
async function fetchDaoProposeList(list) {

  try {

    var res = await api.query.dao.proposals.multi(list);
    res = res.map(e => e.toJSON())

    var arr = []
    res.forEach((e, i) => {
      if (e.length) {
        e.forEach(y => {
          arr.push([list[i], y])
        })

      }
    })
    var [data, dataArgs] = await Promise.all([

      api.query.dao.voting.multi(arr),
      api.query.dao.proposalOf.multi(arr),
    ])

    dataArgs = dataArgs.map((e, i) => {
      var { method, section } = e.toHuman();
      e = e.toJSON()
      e.method = method;
      e.section = section;
      return e
    })

    data = data.map((e, i) => {
      e = e.toJSON()
      e.reason = e.reason != null && e.reason.length != 0 ? hexToString(e.reason) : null;
      e.args = dataArgs[i].args
      e.method = dataArgs[i].method
      e.section = dataArgs[i].section
      e.hash = arr[i][1]
      return e
    })

    return data

  } catch (error) {
    window.send("log", error.toString())
  }
  return null;
}

/** Fetch liquidity token balance List */
async function fetchLiquidityTokenBalance(list) {

  try {
    var res = await api.query.tokens.accounts.multi(list);
    res = res.map(e => e.toJSON())
    return res

  } catch (error) {
    window.send("log", error.toString())
  }
  return null;
}

/** Fetch Fetch lbp support fundraising assets List */
async function fetchLbpSupportFundraisingAssetsList(addr) {

  try {
    var res = await api.query.lbp.supportFundraisingAssets();
    var currencyIds = []
    res = res.toJSON()
    currencyIds = res.map(e => e[0])
    var tokenInfoList = await fetchTokenInfoList(currencyIds, addr)
    tokenInfoList = tokenInfoList.map((e, i) => {
      e.minFundraisingAmount = res[i][1];
      return e;
    });
    return tokenInfoList;
  } catch (error) {
    window.send("log", error.toString())
  }
  return null;
}

/** Fetch can claim nft list */
async function fetchCanClaimNftListAndMyIcoTotalUsd(addr) {

  try {
    var list = [];
    var keys = await api.query.nft.noOwnerTokensOf.keys()
    if (keys.length) {
      var classIds = keys.map(e => e.args[0].toJSON());

      var res = await api.query.nft.noOwnerTokensOf.multi(classIds);
      res = res.forEach((e, i) => {

        e = e.toJSON();

        if (e.length) {
          var tokenId = e[Math.ceil(Math.random()*e.length-1)];
          list.push([classIds[i], tokenId])
        }

      });

    }
    var total = await api.query.ico.totalPowerOf(addr);
    return [list, total];
  } catch (error) {
    window.send("log", error.toString())
  }
  return null;
}

/** Fetch nft on sale list */
async function fetchNftOnSaleList() {

  try {
    var keys = await api.query.nft.inSaleTokens.keys()
    if (keys.length) {
      var classIds = keys.map(e => e.args[0].toJSON());
      var sendList = [];
      var saleDataList = [];
      var res = await api.query.nft.inSaleTokens.multi(classIds);
      res = res.map((e, i) => {

        e = e.toJSON();

        e.forEach(x => {
          sendList.push([classIds[i], x.tokenId])
          saleDataList.push(x)
        })
        return e
      });
      if (sendList.length == 0) return []

      var resTokens = await api.query.nft.tokens.multi(sendList);

      resTokens = resTokens.map((e, i) => {
        e = e.toJSON()
        e.metadata = hexToString(e.metadata);
        e.data.classId = sendList[i][0]
        e.data.attribute = hexToString(e.data.attribute);
        e.data.imageHash = hexToString(e.data.imageHash);

        e.seller = saleDataList[i].seller;
        e.tokenId = saleDataList[i].tokenId;
        e.price = saleDataList[i].price;
        e.startBlock = saleDataList[i].startBlock;
        return e
      });

      return resTokens;
    }
  } catch (error) {
    window.send("log", error.toString())
  }
  return null;
}

/** Fetch my nft token list */
async function fetchMyNftTokenList(addr) {

  try {
    var sendList = await api.query.nft.tokensOf(addr);
    if (sendList.length == 0) return []
    sendList = sendList.map(e => e.toJSON());
    var resTokens = await api.query.nft.tokens.multi(sendList);
    resTokens = resTokens.map((e, i) => {
      e = e.toJSON()
      e.tokenId = sendList[i][1];
      e.metadata = hexToString(e.metadata);
      e.data.attribute = hexToString(e.data.attribute);
      e.data.classId = sendList[i][0]
      e.data.imageHash = hexToString(e.data.imageHash);
      return e;
    });

    return resTokens;

  } catch (error) {
    window.send("log", error.toString())
  }
  return null;
}

async function fetchFarmSupplyBalance(currencyId, pubKey, ss58) {

  await cryptoWaitReady();

  var addr = keyring.encodeAddress(hexToU8a(pubKey), ss58);
  var res;
  if (currencyId == 0) {
    res = await api.query.system.account(addr);
    if (res != null) {
      res = res.toJSON();
      return res.data.free;
    }
  } else {
    res = await api.query.tokens.accounts(addr, currencyId);
    if (res != null) {
      res = res.toJSON();
      return res.free;
    }
  }
  return null;
}

var unsubLiquidityListChange;
/** sub liquidity all List */
async function subLiquidityListChange(addr) {
  if (unsubLiquidityListChange != null) {
    window.send('cancel function:' + unsubLiquidityListChange.toString());
    await unsubLiquidityListChange()
  }
  try {
    var keys = await api.query.amm.liquidity.keys();
    if (keys.length) {
      var list = keys.map(e => e.args[0].toJSON());
      var currencyIds = []
      keys.forEach(e => {
        currencyIds = [...currencyIds, ...(e.args[0].toJSON())]
      });
      currencyIds = [...(new Set(currencyIds))];
      var res2 = await api.query.currencies.dicoAssetsInfo.multi(currencyIds);
      res2 = res2.map((e, i) => {
        e = e.toJSON()
       if (e == null) {
          e = {
            owner: "",
            metadata: {
              name: "NOT SET",
              symbol: "NOT SET",
              decimals: 14
            },
            currencyId: currencyIds[i],
          }
        } else {
          e.currencyId = currencyIds[i]
          if (e.metadata == null) {
            e.metadata = {
              name: "NOT SET",
              symbol: "NOT SET",
              decimals: 14
            };
          } else {
            e.metadata.name = hexToString(e.metadata.name)
            e.metadata.symbol = hexToString(e.metadata.symbol)
          }
        }
        return e
      })

      unsubLiquidityListChange = await api.query.amm.liquidity.multi(list, async (res) => {
        var liquidityIdList = []
        res = res.map(e => {
          e = e.toJSON()
          liquidityIdList.push(e[2])
          return e;
        });
        var totalIssuanceList = await api.query.tokens.totalIssuance.multi(liquidityIdList);

        res = res.map((e, i) => {
          var arr1 = list[i].map(x => res2.find(y => x == y.currencyId))
          e = [...arr1, ...e, totalIssuanceList[i]]
          return e
        });

        window.send("liquidityListChange", res);
      });
      await subTokensInLPBalanceChange(addr, res2, currencyIds)
    } else {
      window.send("liquidityListChange", []);
    }

  } catch (error) {
    window.send("log", error.toString())
  }
  return "ok";
}

async function makeDaoProposalSubmission(currencyId, index, threshold, reason) {

  const proposal = api.tx.ico.permitRelease(currencyId, index);
  return api.tx.dao.propose(currencyId, index, threshold, proposal, reason, proposal.length);
}

var unsubBalanceChange;
/** sub balance */
async function subBalanceChange(addr, pubKey) {
  if (unsubBalanceChange != null) {

    window.send('cancel function:' + unsubBalanceChange.toString());
    await unsubBalanceChange()
  }
  unsubBalanceChange = await api.derive.balances.all(addr, (all) => {
    const lockedBreakdown = all.lockedBreakdown.map((i) => {
      return {
        ...i,
        use: hexToString(i.id.toHex()),
      };
    });
    window.send("balanceChange", {
      ...all,
      pubKey,
      lockedBreakdown,
    });
  });

  return 'ok';
}

var unsubNewHeadsChange;
/** sub the new heads */
async function subNewHeadsChange() {
  if (unsubNewHeadsChange != null) {

    await unsubNewHeadsChange()
  }
  unsubNewHeadsChange = await api.rpc.chain.subscribeNewHeads(({
    parentHash,
    hash,
    number }) => {
    window.send("newHeadsChange", {
      parentHash: u8aToHex(parentHash),
      hash: u8aToHex(hash),
      number
    });
  });

  return "ok";
}

var unsubTokenBalance;
/** sub Tokens Balance */
async function subTokensBalanceChange(addr, tokens) {
  tokens = tokens.map(e => [addr, e])
  if (unsubTokenBalance != null) {

    await unsubTokenBalance()
  }
  unsubTokenBalance = await
    api.query.tokens.accounts.multi(tokens, (res) => {
      window.send("tokensBalanceChange", res);
    });

  return "ok"
}

var unsubTokensInLPBalance;
/** sub TokensInLP Balance */
async function subTokensInLPBalanceChange(addr, tokensList, tokensIdsInLP) {
  tokensList = tokensList.filter(e => e.currencyId != 0);
  tokensIdsInLP = tokensIdsInLP.filter(e => e != 0).map(e => [addr, e])
  if (unsubTokensInLPBalance != null) {

    await unsubTokensInLPBalance()
  }

  unsubTokensInLPBalance = await
    api.query.tokens.accounts.multi(tokensIdsInLP, (balanceList) => {
      tokensList = tokensList.map((res, i) => {

        if (res != null && res.metadata != null) {

          if (balanceList[i]) {
            res.tokenBalance = balanceList[i].toJSON();
          }
        }
        return res;
      })
      window.send("tokensInLPBalanceChange", tokensList);
    });

  return "ok"
}

var unsubFarmPools;
/** sub farm pools change */
async function subFarmPoolsChange(addr) {

  if (unsubFarmPools != null) {
    await unsubFarmPools()
  }
  var keys = await api.query.farm.pools.keys();
  if (keys.length) {
    var poolIds = keys.map(e => e.args[0].toJSON());

    unsubFarmPools = await api.query.farm.pools.multi(poolIds, async (res) => {
      var list = poolIds.map(e => [e, addr])
      var data = await api.query.farm.participants.multi(list)
      res = res.map((e, i) => {
        e = e.toJSON()
        data[i] = data[i].toJSON()
        e.myAmount = data[i]?.["amount"] ?? null;
        e.myRewardDebt = data[i]?.["rewardDebt"] ?? null;
        e.poolId = poolIds[i]
        return e;
      });
      window.send("farmPoolsChange", res);
    });

  } else {
    window.send("farmPoolsChange", []);
  }
  return "ok"
}

var unsubFarmPoolExtends;
/** Sub farm pool extends change */
async function subFarmPoolExtendsChange(addr) {

  if (unsubFarmPoolExtends != null) {
    await unsubFarmPoolExtends()
  }
  var keys = await api.query.farmExtend.poolExtends.keys();
  if (keys.length) {
    var poolIds = keys.map(e => e.args[0].toJSON());

    unsubFarmPoolExtends = await api.query.farmExtend.poolExtends.multi(poolIds, async (res) => {
      var list = poolIds.map(e => [e, addr])
      var data = await api.query.farmExtend.participantExtends.multi(list)
      res = res.map((e, i) => {
        e = e.toJSON()
        data[i] = data[i].toJSON()
        e.myAmount = data[i]?.["amount"] ?? null;
        e.myRewardDebt = data[i]?.["rewardDebt"] ?? null;
        e.poolId = poolIds[i]
        return e;
      });
      window.send("farmPoolExtendsChange", res);
    });

  } else {
    window.send("farmPoolExtendsChange", []);
  }
  return "ok"
}

var unsubLbpPools;
/** sub lbp pools change */
async function subLbpPoolsChange() {

  if (unsubLbpPools != null) {
    await unsubLbpPools()
  }
  var keys = await api.query.lbp.lbps.keys();
  if (keys.length) {
    var poolIds = keys.map(e => e.args[0].toJSON());

    unsubLbpPools = await api.query.lbp.lbps.multi(poolIds, async (res) => {
      res = res.map((e, i) => {
        e = e.toJSON()
        e.lbpId = poolIds[i]
        return e;
      });
      window.send("lbpPoolsChange", res);
    });

  } else {
    window.send("lbpPoolsChange", []);
  }
  return "ok"
}


/** Sub change together */
async function subChangeTogether(addr, publicKey) {
  await Promise.all([

    subBalanceChange(addr, publicKey),
    subNewHeadsChange(),
    subLiquidityListChange(addr),
    subLbpPoolsChange(),
  ]);

  return "ok"
}

/** Fetch init data */
async function fetchInitData(addr, fields) {
  var res = await Promise.all([

    fetchMyNftTokenList(addr),
    fetchpassedIcoes(),
    api.query.ico.requestReleaseInfo(),
    fetchFarmRuleData(),
    fetchKYCIasListAndSwordHolderList(fields),
  ]);

  return res
}




export default {
  subBalanceChange,
  subNewHeadsChange,
  fetchKYCMyCurvePublicKey,
  fetchKYCIasListAndSwordHolderList,
  fetchIasMessageList,
  fetchSwordHolderMessageList,
  encryptKYCMessage,
  decryptKYCMessage,
  fetchKYCRecommandFee,
  fetchMinMaxUSDTAmount,
  fetchInitiatedIcoesOf,
  fetchIcoListByIdAndIndexList,
  fetchIcoGetAmount,
  fetchpassedIcoes,
  fetchUserJoinIcoAmount,
  fetchDaoProposeList,
  makeDaoProposalSubmission,
  subTokensBalanceChange,
  subTokensInLPBalanceChange,
  fetchPendingIco,
  fetchLiquidityTokenBalance,
  subLiquidityListChange,
  subFarmPoolsChange,
  subFarmPoolExtendsChange,
  fetchFarmRuleData,
  fetchKYCInfo,
  fetchTokenInfo,
  fetchAllTokenInfoList,
  fetchTokenInfoList,
  fetchNftOnSaleList,
  fetchMyNftTokenList,
  fetchCanClaimNftListAndMyIcoTotalUsd,
  subLbpPoolsChange,
  subChangeTogether,
  fetchInitData,
  fetchLbpSupportFundraisingAssetsList,
  fetchFarmSupplyBalance,
};