//
//  Glass.swift
//  WatermeterofTheFuture
//
//  Created by Thomas Gilbert on 15/04/16.
//  Copyright © 2016 Thomas Gilbert. All rights reserved.
//

import UIKit

let π:CGFloat = CGFloat(M_PI)

@IBDesignable class Glass: UIView {
    
    @IBInspectable var fillLevel:CGFloat = 0.1
    @IBInspectable var fluidColour:UIColor = UIColor.blueColor()
    @IBInspectable var glassColour:UIColor = UIColor.darkGrayColor()
    @IBInspectable var glassThickness:CGFloat = 3.0
    
    override func drawRect(rect: CGRect) {
        
        let currFillLevel=(bounds.height-15)*fillLevel
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 5, y: 5))
        path.addLineToPoint(CGPoint(x: 5, y: bounds.height-5))
        path.addLineToPoint(CGPoint(x: bounds.width-5, y: bounds.height-5))
        path.addLineToPoint(CGPoint(x: bounds.width-5, y: 5))
        
        path.addLineToPoint(CGPoint(x: bounds.width-5, y: currFillLevel))
        
        //path.addCurveToPoint(CGPoint(x: bounds.width*0.5, y: currFillLevel), controlPoint1: CGPoint(x: bounds.width*0.8, y: 20), controlPoint2: CGPoint(x: bounds.width*0.9, y: 0))
        //path.addCurveToPoint(CGPoint(x: 5, y: currFillLevel), controlPoint1: CGPoint(x: bounds.width*0.3, y: 20), controlPoint2: CGPoint(x: bounds.width*0.2, y: 0))
        
        glassColour.setStroke()
        path.lineWidth = glassThickness
        path.stroke()

        path.addLineToPoint(CGPoint(x: 5, y: currFillLevel))
        
        fluidColour.setFill()
        path.fill()
        
        print("test")
    }
    
}