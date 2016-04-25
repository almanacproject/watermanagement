//
//  SecondViewController.swift
//  WatermeterofTheFuture
//
//  Created by Thomas Gilbert on 15/04/16.
//  Copyright © 2016 Thomas Gilbert. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

