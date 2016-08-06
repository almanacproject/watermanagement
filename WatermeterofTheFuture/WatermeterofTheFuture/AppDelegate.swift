//
//  AppDelegate.swift
//  WatermeterofTheFuture
//
//  Created by Thomas Gilbert on 15/04/16.
//  Copyright © 2016 Thomas Gilbert. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import AeroGearOAuth2
import OGCSensorThings

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var usercontext: UserProfile?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Facebook tracking
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        print("didFinishLaunchingWithOptions")
        initializeNotificationServices()
        
        SwaggerClientAPI.basePath = "http://scratchpad.sensorup.com/OGCSensorThings/v1.0"
        SwaggerClientAPI.customHeaders["Accept"] = "application/json"
        SwaggerClientAPI.customHeaders["Content-type"] = "application/json"
        
        return true
    }
    
    //func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
    //    print("Started")
    //    return true
    //}
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        print("Application: \(application)")
        print("Source: \(sourceApplication)")
        print("URL: \(url)")
        
        if let myName = url.absoluteString as String! where myName.containsString("dk.alexandra.almanac.watermeterofthefuture://oauth2Callback") {
            let notification = NSNotification(name: AGAppLaunchedWithURLNotification, object:nil, userInfo:[UIApplicationLaunchOptionsURLKey:url])
            NSNotificationCenter.defaultCenter().postNotification(notification)
            print("Notofication posted")
            return true
        } else {
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        }
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Reset counter for notification badges
        application.applicationIconBadgeNumber = 0
        
        FBSDKAppEvents.activateApp()
    }
    
    func initializeNotificationServices() -> Void {
        print("initializeNotificationServices")
        let settings = UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        // This is an asynchronous method to retrieve a Device Token
        // Callbacks are in AppDelegate.swift
        // Success = didRegisterForRemoteNotificationsWithDeviceToken
        // Fail = didFailToRegisterForRemoteNotificationsWithError
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("User Registered!!!! \(deviceToken)")
        
        let HUBLISTENACCESS = "Endpoint=sb://watermeterofthefuture.servicebus.windows.net/;SharedAccessKeyName=DefaultListenSharedAccessSignature;SharedAccessKey=QnMgdYYGr03u8XBS0WbLQwr0cMMxqpJQILY12luSPNY="
        let HUBNAME = "ALMANAC"
        
        let hub = SBNotificationHub(connectionString:HUBLISTENACCESS, notificationHubPath:HUBNAME)
        
        let tagArray: [AnyObject] = ["ALMANAC", "pub", "watermeterid","joao"]
        let deviceTags: NSSet = NSSet(array: tagArray);
        
        let templateBodyAPNS = "{\"aps\": { \"alert\": \"$(message)\", \"badge\": \"#(count)\"}, \"eventtype\" : \"$(type)\" }"
        
        hub.registerTemplateWithDeviceToken(deviceToken, name: "ALMANAC", jsonBodyTemplate: templateBodyAPNS, expiryTemplate: "0", tags: deviceTags as Set<NSObject>) { (error) in
            if (error != nil) {
                print("Error registering for notification with AZURE: \(error)")
            } else {
                print("Registration success")
            }
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("User failed to register: \(error)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // display the userInfo
        print("Notified: \(userInfo)")
        if let notification = userInfo["aps"] as? NSDictionary,
            let alert = notification["alert"] as? String {
            let alertCtrl = UIAlertController(title: "Water Event", message: alert as String, preferredStyle: UIAlertControllerStyle.Alert)
            alertCtrl.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            // Find the presented VC...
            var presentedVC = self.window?.rootViewController
            while (presentedVC!.presentedViewController != nil)  {
                presentedVC = presentedVC!.presentedViewController
            }
            presentedVC!.presentViewController(alertCtrl, animated: true, completion: nil)
            
            // call the completion handler
            // -- pass in NoData, since no new data was fetched from the server.
            completionHandler(UIBackgroundFetchResult.NoData)
        }
    }
}

extension NSURLRequest {
    static func allowsAnyHTTPSCertificateForHost(host: String) -> Bool {
        print("Allowing illegal stuff for: \(host)")
        return true
    }
}

extension NSURLConnection {
    
}