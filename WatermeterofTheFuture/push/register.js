var azure = require('azure');
var notificationHubService = azure.createNotificationHubService('ALMANAC', 'Endpoint=sb://watermeterofthefuture.servicebus.windows.net/;SharedAccessKeyName=DefaultListenSharedAccessSignature;SharedAccessKey=QnMgdYYGr03u8XBS0WbLQwr0cMMxqpJQILY12luSPNY=');

notificationHubService.apns.createTemplateRegistration(
		'1133AA56690832F871B3FC943CAE09066C2CFBFFCB6123759D65E7899EA87B60',
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
