//
//  Circle.swift
//  WatermeterofTheFuture
//
//  Created by Thomas Gilbert on 20/04/16.
//  Copyright © 2016 Thomas Gilbert. All rights reserved.
//

import UIKit

let NoOfGlasses = 10

@IBDesignable class Circle: UIView {
    
    let counter: Int = 10
    @IBInspectable var fillLevel: Double = 0.4 {
        didSet {
            if fillLevel < 0 || fillLevel > 1 {
                //fillLevel = 0.5
            }
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var outlineColor: UIColor = UIColor.blueColor()
    @IBInspectable var counterColor: UIColor = UIColor.orangeColor()

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // 1
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        // 2
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        // 3
        let arcWidth: CGFloat = radius / 4
        
        // 4
        
        let minAngle: CGFloat = 3 * π / 4
        let maxAngle: CGFloat = π / 4
        
        let startAngle: CGFloat = minAngle
        let angleDiff: CGFloat = 2 * π - minAngle + maxAngle
        
        let endPosition = angleDiff * CGFloat(fillLevel) + startAngle
        
        
        // 5
        let path = UIBezierPath(arcCenter: center,
                                radius: radius/2 - arcWidth/2,
                                startAngle: startAngle,
                                endAngle: endPosition,
                                clockwise: true)
        
        // 6
        path.lineWidth = arcWidth
        counterColor.setStroke()
        path.stroke()
        
        let angleDifference: CGFloat = 2 * π - minAngle + maxAngle
        
        //then calculate the arc for each single glass
        let arcLengthPerGlass = angleDifference / CGFloat(NoOfGlasses)
        
        //then multiply out by the actual glasses drunk
        let outlineEndAngle = arcLengthPerGlass * CGFloat(counter) + minAngle
        
        //2 - draw the outer arc
        let outlinePath = UIBezierPath(arcCenter: center,
                                       radius: bounds.width/2 - 2.5,
                                       startAngle: minAngle,
                                       endAngle: outlineEndAngle,
                                       clockwise: true)
        
        //3 - draw the inner arc
        outlinePath.addArcWithCenter(center,
                                     radius: bounds.width/2 - arcWidth + 2.5,
                                     startAngle: outlineEndAngle,
                                     endAngle: minAngle,
                                     clockwise: false)
        
        //4 - close the path
        outlinePath.closePath()
        
        outlineColor.setStroke()
        outlinePath.lineWidth = 5.0
        outlinePath.stroke()
        
        // Markers
        //Counter View markers
        
        let context = UIGraphicsGetCurrentContext()
        
        //1 - save original state
        CGContextSaveGState(context)
        outlineColor.setFill()
        
        let markerWidth:CGFloat = 5.0
        let markerSize:CGFloat = 10.0
        
        //2 - the marker rectangle positioned at the top left
        let markerPath = UIBezierPath(rect:
            CGRect(x: -markerWidth/2,
                y: 0,
                width: markerWidth,
                height: markerSize))
        
        //3 - move top left of context to the previous center position
        CGContextTranslateCTM(context,
                              rect.width/2,
                              rect.height/2)
        
        for i in 1...NoOfGlasses {
            //4 - save the centred context
            CGContextSaveGState(context)
            
            //5 - calculate the rotation angle
            let angle = arcLengthPerGlass * CGFloat(i) + minAngle - π/2
            
            //rotate and translate
            CGContextRotateCTM(context, angle)
            CGContextTranslateCTM(context,
                                  0,
                                  rect.height/2 - markerSize)
            
            //6 - fill the marker rectangle
            markerPath.fill()
            
            //7 - restore the centred context for the next rotate
            CGContextRestoreGState(context)
        }
        
        //8 - restore the original state in case of more painting
        CGContextRestoreGState(context)
    }
}
