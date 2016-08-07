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

class TodaysConsumptionVC: UIViewController {
    
    @IBOutlet weak var consumptionWheel: Circle!
    @IBOutlet weak var consumptionLabel: UILabel!
    @IBOutlet weak var consumptionTitle: UILabel!
    
    @IBOutlet weak var facebookLike: UIButton!
    
    var dateTracker: Int = 0;
    
    var minWater: Double? = 0
    var maxWater: Double? = 0
    
    var waterConsumedToday: Double = 0.0 {
        didSet {
            debugPrint("Setting water consumed today: \(waterConsumedToday)")
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
        dateTracker = 0;
        updateUI()
        getLatest()
    }
    
    func getLatest() {
        print("Getting stuff")
        
        let group = dispatch_group_create()
        
        dispatch_group_enter(group)
        Consumption.getMidnightConsumptionLevel("100149", dateOffset: dateTracker) { (consumption) in
            if let consumption = consumption {
                self.minWater = consumption
            } else {
                self.minWater = nil
                debugPrint("getTodaysCurrentConsumptionLevel: nil")
            }
            dispatch_group_leave(group)
        }
        
        dispatch_group_enter(group)
        Consumption.getTodaysCurrentConsumptionLevel("100149", dateOffset: dateTracker) { (consumption) in
            if let consumption = consumption {
                self.maxWater = consumption
            } else {
                self.maxWater = nil
                debugPrint("getTodaysCurrentConsumptionLevel: nil")
            }
            dispatch_group_leave(group)
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            if let minWater = self.minWater, maxWater = self.maxWater {
                self.waterConsumedToday = maxWater - minWater
            } else {
                self.waterConsumedToday = 0
            }
        }
    }
    
    func updateUI() {
        switch dateTracker {
        case 0:
            self.consumptionTitle.text = "Consumption today"
        case -1:
            self.consumptionTitle.text = "Yesterday"
        case -2:
            self.consumptionTitle.text = "Day before yesterday"
        default:
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            
            let dateString = formatter.stringFromDate(NSDate.addUnitToDate(.Day, number: dateTracker, date: NSDate()))
            self.consumptionTitle.text = dateString
        }
        
        consumptionLabel.text = "\(waterConsumedToday)"
        consumptionWheel.fillLevel = waterConsumedToday / waterConsumptionAverage
    }
    
    @IBAction func pressWheel(sender: UITapGestureRecognizer) {
        // waterConsumedToday = round(Double.random(0, waterConsumptionAverage)*100)/100
    }
    
    @IBAction func swipeDates(sender: UISwipeGestureRecognizer) {
        
        if sender.direction == UISwipeGestureRecognizerDirection.Right {
            dateTracker = dateTracker - 1
            consumptionWheel.shake(-1.0)
            print("Right Swipe Detected \(dateTracker)")
        } else if dateTracker < 0{
            dateTracker = dateTracker + 1
            consumptionWheel.shake(1.0)
            print("Left Swipe Detected \(dateTracker)")
        }
        
        getLatest()
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

extension UIView {
    func shake(direction: Double) {
        let shake = [-10.0, 10.0, -10.0, 10.0, -5.0, 5.0, -2.5, 2.5, 0.0 ].map{$0 * direction}
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.4
        animation.values = shake
        layer.addAnimation(animation, forKey: "shake")
    }
}