import "@babel/polyfill";
import {
  WsProvider,
  ApiPromise
} from "@polkadot/api";
import account from "./service/account";
import gov from "./service/gov";
import dico from "./service/dico";
import {
  genLinks
} from "./utils/config/config";
import rpc from './utils/rpc'
import {
  POLKADOT_GENESIS
} from "./constants/networkSpect";

// send message to app
function send(path, data) {
  console.log(JSON.stringify({ path, data }));
}
send("log", "main js loaded");
window.send = send;


function connect(endpoint,  newTypes) {
  return new Promise(async (resolve, reject) => {
    const wsProvider = new WsProvider(endpoint);

    try {
      var api = new ApiPromise({
        provider: wsProvider,
        types:  newTypes || null,
        rpc: rpc
      });
      api.on('connected', () => {
        send("disconnected", false);
      });
      api.on('disconnected', () => {
        send("disconnected", true);

      });
      await api.isReady
      window.api = api;
      send("log", `${endpoint} wss ready`);
      resolve(endpoint);
    } catch (error) {
      send("log", `connect ${endpoint} failed`);

      resolve(null);
    }

   
  });
}

const test = async (address) => {
  // const props = await api.rpc.system.properties();
  // send("log", props);
};

async function getNetworkConst() {
  return api.consts;
}

function changeEndpoint(endpoint) {
  try {
    send("log", "disconnect");
    window.api.disconnect();
  } catch (err) {
    send("log", err.message);
  }
  return connect(endpoint);
}

async function subscribeMessage(section, method, params, msgChannel) {
  return api.derive[section][method](...params, (res) => {
    send(msgChannel, res);
  }).then((unsub) => {
    const unsubFuncName = `unsub${msgChannel}`;
    window[unsubFuncName] = unsub;
    return {};
  });
}

async function getNetworkPropoerties() {
  var chainProperties = await api.rpc.system.properties();

  return api.genesisHash.toHuman() == POLKADOT_GENESIS ?
    api.registry.createType("ChainProperties", {
      ...chainProperties,
      tokenDecimals: [10],
      tokenSymbol: ["DOT"],
    }) :
    chainProperties;
}

async function fetchNetworkInfo() {
  var res = await Promise.all([
    getNetworkConst(),
    getNetworkPropoerties(),
    api.rpc.system.chain()
  ])
  return res;
}

window.settings = {
  test,
  connect,
  fetchNetworkInfo,
  getNetworkConst,
  getNetworkPropoerties,
  changeEndpoint,
  subscribeMessage,
  genLinks,
};

window.account = account;
window.gov = gov;
window.dico = dico;