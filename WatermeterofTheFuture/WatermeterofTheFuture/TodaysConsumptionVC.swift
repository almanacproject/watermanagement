//
//  FirstViewController.swift
//  WatermeterofTheFuture
//
//  Created by Thomas Gilbert on 15/04/16.
//  Copyright © 2016 Thomas Gilbert. All rights reserved.
//

import UIKit
import Social
import FBSDKShareKit
import FBSDKCoreKit
import OGCSensorThings

class TodaysConsumptionVC: UIViewController {
    
    @IBOutlet weak var consumptionWheel: Circle!
    @IBOutlet weak var consumptionLabel: UILabel!
    
    @IBOutlet weak var facebookLike: UIButton!
    
    var minWater: Double? {
        didSet {
            if let maxWater = maxWater, minWater = minWater {
                waterConsumedToday = maxWater - minWater
            }
        }
    }
    
    var maxWater: Double?  {
        didSet {
            if let maxWater = maxWater, minWater = minWater {
                waterConsumedToday = maxWater - minWater
            }
        }
    }
    
    var waterConsumedToday: Double = 0.0 {
        didSet {
            updateUI()
        }
    }
    
    var waterConsumptionAverage: Double = 143.0 {
        didSet {
            updateUI()
        }
    }
    
    var comparisonType = ConsumptionComparison.Week
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getLatest()
    }
    
    func getLatest() {
        print("Getting stuff")
        
        SwaggerClientAPI.basePath = "http://scratchpad.sensorup.com/OGCSensorThings/v1.0"
        SwaggerClientAPI.customHeaders["Accept"] = "application/json"
        SwaggerClientAPI.customHeaders["Content-type"] = "application/json"
        
        Consumption.getMidnightConsumptionLevel("100149") { (consumption) in
            if let consumption = consumption {
                self.minWater = consumption
            } else {
                debugPrint("getTodaysCurrentConsumptionLevel: nil")
            }
        }
        
        Consumption.getTodaysCurrentConsumptionLevel("100149") { (consumption) in
            if let consumption = consumption {
                self.maxWater = consumption
            } else {
                debugPrint("getTodaysCurrentConsumptionLevel: nil")
            }
        }
    }
    
    func updateUI() {
        consumptionLabel.text = "\(waterConsumedToday)"
        consumptionWheel.fillLevel = waterConsumedToday / waterConsumptionAverage
    }
    
    @IBAction func pressWheel(sender: UITapGestureRecognizer) {
        waterConsumedToday = round(Double.random(0, waterConsumptionAverage)*100)/100
    }
    
    @IBAction func shareConsumption(sender: UIButton) {
        facebookLike.hidden = true
        
        UIGraphicsBeginImageContextWithOptions(consumptionWheel.bounds.size, false, 0)
        
        self.consumptionWheel.drawViewHierarchyInRect(consumptionWheel.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        
        let photo = FBSDKSharePhoto()
        photo.image = image
        photo.caption = "I only used XXX water today"
        photo.userGenerated = false
        let content = FBSDKSharePhotoContent()
        content.photos = [photo]
        
        FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil)
        
        facebookLike.hidden = false
    }
}

enum ConsumptionComparison {
    case Week
    case Month
    case Year
}

extension UIColor {
    static func randomColor() -> UIColor {
        let r = CGFloat.random()
        let g = CGFloat.random()
        let b = CGFloat.random()
        
        // If you wanted a random alpha, just create another
        // random number for that too.
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}

public extension Int {
    /// SwiftRandom extension
    public static func random(lower: Int = 0, _ upper: Int = 100) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}

public extension Double {
    /// SwiftRandom extension
    public static func random(lower: Double = 0, _ upper: Double = 100) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
}

public extension Float {
    /// SwiftRandom extension
    public static func random(lower: Float = 0, _ upper: Float = 100) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
}

public extension CGFloat {
    /// SwiftRandom extension
    public static func random(lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
}