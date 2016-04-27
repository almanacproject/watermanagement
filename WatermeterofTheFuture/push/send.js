var azure = require('azure');
//var notificationHubService = azure.createNotificationHubService('ALMANAC', 'Endpoint=sb://watermeterofthefuture.servicebus.windows.net/;SharedAccessKeyName=DefaultFullSharedAccessSignature;SharedAccessKey=uwiuZZXZP/A0SG/+iVmxQ/KqkiLCvjS/V4Hwgtch2js=');

var notificationHubService = azure.createNotificationHubService('ALMANAC', 'Endpoint=sb://watermeterofthefuture.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=I40zq3da5LFh3PAp2eEbvLkjTaRQUth3WgWEkUKkh1M=');

var notification = {
    'message': 'A leak has been detected!',
    'type': 'LEAK2',
    'count': 1 // set badge iOS badge to this value
};

var responseHandler = (function (n) {
    return function (e, r) {
        if (e) {
            console.log(e);
            return;
        } else {
            console.log(r.statusCode, n);
        }
    };
})(notification);

console.log('sending...');
notificationHubService.send('gitte', notification, responseHandler);
