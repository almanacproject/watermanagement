
var CryptoJS = require("crypto-js");

var getSelfSignedToken = function(targetUri, sharedKey, ruleId,
expiresInMins) {
targetUri = encodeURIComponent(targetUri.toLowerCase()).toLowerCase();

// Set expiration in seconds
var expireOnDate = new Date();
expireOnDate.setMinutes(expireOnDate.getMinutes() + expiresInMins);
var expires = 1493298826; //= Date.UTC(expireOnDate.getUTCFullYear(), expireOnDate
//.getUTCMonth(), expireOnDate.getUTCDate(), expireOnDate
//.getUTCHours(), expireOnDate.getUTCMinutes(), expireOnDate
//.getUTCSeconds()) / 1000;
var tosign = targetUri + '\n' + expires;

// using CryptoJS
var signature = CryptoJS.HmacSHA256(tosign, sharedKey);
var base64signature = signature.toString(CryptoJS.enc.Base64);
var base64UriEncoded = encodeURIComponent(base64signature);

// construct autorization string
var token = "SharedAccessSignature sr=" + targetUri + "&sig="
+ base64UriEncoded + "&se=" + expires + "&skn=" + ruleId;
// console.log("signature:" + token);
return token;
};

console.log(getSelfSignedToken("https://watermeterofthefuture.servicebus.windows.net:443/almanac/messages",
                               "I40zq3da5LFh3PAp2eEbvLkjTaRQUth3WgWEkUKkh1M=","RootManageSharedAccessKey",1493298826));
