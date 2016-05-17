//
//  SettingsVC.swift
//  WatermeterofTheFuture
//
//  Created by Thomas Gilbert on 27/04/16.
//  Copyright © 2016 Thomas Gilbert. All rights reserved.
//

import UIKit
import Alamofire
import OGCSensorThings

class SettingsVC: UIViewController {
    
    @IBOutlet private weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func pressButton(sender: UIButton, forEvent event: UIEvent) {
        //        let headers = [
        //            "Authorization": "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImF1ZCI6IkFMTUFOQUMtTEFCIn0.z9J5YkeW_SmSRUm1twQPar-RkVNfkxx4JxkPbjUsPkhcR7XEOHFnlnV2V9Vg6-UAonfcOiAGUq8u7kJh4U1in-RD7kCIBk9DEzsg65kF9zDG6emIfyg0kw7jMxh9mKQvc8VRMBYj5muObTG0ExLZwdp5Hg0BPf0ISh2fHYTgrtg"        ]
        
        //        Alamofire.request(.GET, "http://almanac-lab.alexandra.dk/internalStatus", headers:headers)
        //            .validate(statusCode: 200..<300)
        //            .responseJSON { response in
        //                if let JSON = response.result.value {
        //                    print("JSON: \(JSON)")
        //                } else {
        //                    print("Bobo: \(response.debugDescription)")
        //                    print("Time: \(response.timeline)")
        //                }
        //        }
        
        SwaggerClientAPI.basePath = "http://ogcpilot.sensorup.com:8080/OGCSensorThings/v1.0/"
        
        
        DefaultAPI.locationsGet(orderby: nil, top: 10, skip: nil, filter: nil) { (data, error) in
            if let response = data?.value {
                print("Aha, there be data: \(response.count)")
                print("Id of first location: \(response.first?.iotId)")
                
                if let thing = response.first?.iotId {
                    
                    switch thing {
                    case 0 as Int:
                        print("zero as an Int")
                    case 0 as Double:
                        print("zero as a Double")
                    case let someInt as Int:
                        print("an integer value of \(someInt)")
                    case let someDouble as Double where someDouble > 0:
                        print("a positive double value of \(someDouble)")
                    case is Double:
                        print("some other double value that I don't want to print")
                    case let someString as String:
                        print("a string value of \"\(someString)\"")
                    case let (x, y) as (Double, Double):
                        print("an (x, y) point at \(x), \(y)")
                    case let stringConverter as String -> String:
                        print(stringConverter("Michael"))
                    default:
                        print("something else")
                    }
                }
            }
        }
    }
    
}
