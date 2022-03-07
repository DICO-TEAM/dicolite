
var CryptoJS = require("crypto-js");

var curve = require("curve25519-js")

// var bip39 = require("@polkadot/util-crypto")
import { mnemonicToLegacySeed } from "@polkadot/util-crypto";


const getMyCurveKey = (seed) => {
    seed = seed.trim();

    if (seed.startsWith("0x")) {
        seed = seed.substring(2);
    }

    /// mnemonic
    if (seed.includes(" ")) {
        seed = Buffer.from(mnemonicToLegacySeed(seed)).toString('hex');

    }
    const seed_array = Uint8Array.from(Buffer.from(seed, 'hex'));

    var alice_pair = curve.generateKeyPair(seed_array);

    return {
        private: Buffer.from(alice_pair.private).toString('hex'),
        public: Buffer.from(alice_pair.public).toString('hex'),
    };
}


//  other's public key -> public secret
const getSecret = (otherPublic, mySeed) => {
    var myPrivate = getMyCurveKey(mySeed).private;
    if (myPrivate.startsWith("0x")) {
        myPrivate = myPrivate.substring(2);
    }
    if (otherPublic.startsWith("0x")) {
        otherPublic = otherPublic.substring(2);
    }
    const myPriv = Uint8Array.from(Buffer.from(myPrivate, 'hex'));
    const otherPub = Uint8Array.from(Buffer.from(otherPublic, 'hex'));
    const secret1 = curve.sharedKey(myPriv, otherPub);
    return Buffer.from(secret1).toString('hex');
}


// curvePubicKey save on chain
const getCurvePublicKey = (seed) => {
    return getMyCurveKey(seed).public;
}


const encryptMessage = (message, otherPublic, seed) => {
    var secret = getSecret(otherPublic, seed);
    // Encrypt
    var ciphertext = CryptoJS.AES.encrypt(message, secret).toString();
    return ciphertext;
}

const decryptMessage = (ciphertext, otherPublic, seed) => {
    var secret = getSecret(otherPublic, seed);
    // Decrypt
    var bytes = CryptoJS.AES.decrypt(ciphertext, secret);
    var originalText = bytes.toString(CryptoJS.enc.Utf8);
    return originalText;
}

export default { getCurvePublicKey, encryptMessage, decryptMessage };
