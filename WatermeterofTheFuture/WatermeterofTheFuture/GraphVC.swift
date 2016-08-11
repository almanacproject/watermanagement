//
//  SecondViewController.swift
//  WatermeterofTheFuture
//
//  Created by Thomas Gilbert on 15/04/16.
//  Copyright © 2016 Thomas Gilbert. All rights reserved.
//

import UIKit
import JBChartView

class GraphVC: UIViewController, JBBarChartViewDataSource, JBBarChartViewDelegate {
    
    @IBOutlet weak var graphView: JBBarChartView!
    @IBOutlet weak var informationView: GraphView!

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    var leftLabelIdentifier = "Jan" {
        didSet {
            updateUI()
        }
    }
    
    var rightLabelIdentifier = "Dec" {
        didSet {
            updateUI()
        }
    }
    
    var barchartModel = [100,66,32,45,23,0,0,23,45,32,66,100] {
        didSet {
            graphView.reloadData()
        }
    }
    
    var informationViewModel = [100,66,32,45,23,0,0,23,45,32,66,100] {
        didSet {
            informationView.graphPoints = informationViewModel
        }
    }
    
    override func viewDidLoad() {
        graphView.dataSource = self
        graphView.delegate = self
        graphView.frame = CGRectMake(graphConsts.kJBBarChartViewControllerChartPadding,
                                     graphConsts.kJBBarChartViewControllerChartPadding,
                                     self.view.bounds.size.width - graphConsts.kJBBarChartViewControllerChartPadding * 2,
                                     230.0)

        graphView.minimumValue = CGFloat(0.0)
        graphView.setState(.Expanded, animated: true)
        
        informationView.startColor = UIColor(red: 0.0745098, green: 0.745098, blue: 0.831373, alpha: 0.55205)
        informationView.endColor = UIColor(red: 0.627451, green: 0.627451, blue: 0.627451, alpha: 1)

        super.viewDidLoad()
    }
    
    func updateUI() {
        leftLabel.text = leftLabelIdentifier
        leftLabel.adjustsFontSizeToFitWidth = true
        leftLabel.textAlignment = NSTextAlignment.Left
        leftLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        //leftLabel.shadowColor = UIColor.blackColor()
        //leftLabel.shadowOffset = CGSizeMake(0.0, 1.0)
        leftLabel.backgroundColor = UIColor.clearColor()
        
        rightLabel.text = rightLabelIdentifier
        rightLabel.adjustsFontSizeToFitWidth = true
        rightLabel.textAlignment = NSTextAlignment.Right
        rightLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        //rightLabel.shadowColor = UIColor.blackColor()
        //rightLabel.shadowOffset = CGSizeMake(0.0, -1.0)
        rightLabel.backgroundColor = UIColor.clearColor()

        graphView.reloadDataAnimated(true)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        graphView.reloadData()
        updateUI()
    }
    
    func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt) {
        debugPrint(index)
        animateInsideInformationView()
        
        loadInformationViewDetails(Int(index))
    }
    
    func loadInformationViewDetails(month: Int) {
        let synchronousUpdateVariable = dispatch_queue_create("forAvgCalculation", DISPATCH_QUEUE_CONCURRENT)
        var values = [Double]()
        
        let group = dispatch_group_create()
        
        let mNo = NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: NSDate()).month - 1
        
        let month = NSDate.addUnitToDate(.Month, number: ((mNo - month) * -1), date: NSDate.getMonth())
        debugPrint("Using this date: \(month.jsonDate()) as we are going \(month) back currentmonth is \(mNo)")
        
        for index in 0...30 {
            dispatch_group_enter(group)
            Consumption.getLatestConsumptionBefore("100149", date: NSDate.addUnitToDate(.Day, number: index, date: month)) { (consumption) in
                if let consumption = consumption {
                    // Update in seperate queue
                    dispatch_barrier_async(synchronousUpdateVariable) {
                        debugPrint("Found value: \(consumption)")
                        values.append(consumption)
                    }
                }
                dispatch_group_leave(group)
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            values = values.sort()
            debugPrint("Values downloaded for informationview: \(values) / \(values.count)")
            self.informationViewModel = values.map({ (number) -> Int in
                return Int(number)
            })
        }
    }
    
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        return UInt(barchartModel.count)
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        return CGFloat(barchartModel[Int(index)])
    }
    
    func barChartView(barChartView: JBBarChartView!, colorForBarViewAtIndex index: UInt) -> UIColor! {
        switch (index % 2) {
        case 0:
            return UIColor(red: 0.627451, green: 0.627451, blue: 0.627451, alpha: 1)
        default:
            return UIColor(red: 0.0745098, green: 0.745098, blue: 0.831373, alpha: 0.55205)
        }
    }
    
    func barSelectionColorForBarChartView(barChartView: JBBarChartView!) -> UIColor! {
        return UIColor.brownColor()
    }
    
    func shouldExtendSelectionViewIntoHeaderPaddingForChartView(chartView: JBChartView!) -> Bool {
        return true
    }
    
    func shouldExtendSelectionViewIntoFooterPaddingForChartView(chartView: JBChartView!) -> Bool {
        return true
    }
    
    func barPaddingForBarChartView(barChartView: JBBarChartView!) -> CGFloat {
        return CGFloat(1.0)
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func animateInsideInformationView() {
        let with = self.informationView?.bounds.width
        let path2 = UIBezierPath()
        path2.moveToPoint(CGPoint(x: 0.0, y: 5.0))
        path2.addLineToPoint(CGPoint(x: with!, y: 5.0))
        
        
        let square = UIView()
        square.frame = CGRect(x: 1000, y: 1000, width: 50, height: 5)
        square.backgroundColor = UIColor.redColor()
        
        // add the square to the screen
        self.informationView.addSubview(square)
        
        // create a new CAKeyframeAnimation that animates the objects position
        let anim = CAKeyframeAnimation(keyPath: "position")
        
        // set the animations path to our bezier curve
        anim.path = path2.CGPath
        
        // set some more parameters for the animation
        // this rotation mode means that our object will rotate so that it's parallel to whatever point it is currently on the curve
        // anim.rotationMode = kCAAnimationRotateAuto
        //anim.repeatCount = Float.infinity
        anim.duration = 1.0
        
        // we add the animation to the squares 'layer' property
        square.layer.addAnimation(anim, forKey: "animate position along path")
    }
}

struct graphConsts {
    static let kJBBarChartViewControllerChartPadding = CGFloat(20.0)
}
