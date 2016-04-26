var azure = require('azure');
var notificationHubService = azure.createNotificationHubService('ALMANAC', 'Endpoint=sb://watermeterofthefuture.servicebus.windows.net/;SharedAccessKeyName=DefaultListenSharedAccessSignature;SharedAccessKey=QnMgdYYGr03u8XBS0WbLQwr0cMMxqpJQILY12luSPNY=');

notificationHubService.apns.createTemplateRegistration(
		'E409B71FCAF1506800A66E0DBDEC0EA38C60CB53B98B1CBA22AA7940D4777569',
		'ALMANAC', {
			     'aps': {
				              'alert': '$(message)',
         'badge': '#(count)',
         'sound': 'default'
	     }
		},
		function (e, r) {
			     if (e) {
				              console.log(e);
					           } else {
							            console.log({
									                 id: r.RegistrationId,
									                 deviceToken: r.DeviceToken,
									                 expires: r.ExpirationTime
									             });
								         }
		}
		);
