//
//  UserProfile.swift
//  Almanac
//
//  Created by Thomas Gilbert on 24/09/15.
//  Copyright © 2015 Alexandra Institute. All rights reserved.
//

import Foundation
import AeroGearOAuth2
import AeroGearHttp

class UserProfile
{
    var userName: String?
    var password: String?
    
    class func validateUser(andDoStuff: (UserProfile?, NSError?) -> Void) -> Void {
        // let http = Http()
        let keycloakConfig = KeycloakConfig(
            clientId: "vlc",
            host: "https://almanac-showcase.ismb.it:8543",
            realm: "ALMANAC-ISMB-SHOWCASE",
            isOpenIDConnect: true)
        let oauth2Module = AccountManager.addKeycloakAccount(keycloakConfig)
        // http.authzModule = oauth2Module
        oauth2Module.login {(accessToken: AnyObject?, claims: OpenIDClaim?, error: NSError?) in // [1]
            // Do your own stuff here
            if let error = error {
                print("Failed")
                print("\(error)")
            }
            //print("Success or fail: \(error)")
            print("Claim: \(claims)")
            print("Tokens: \(accessToken)")
        }
    }
}