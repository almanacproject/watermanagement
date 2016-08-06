//
//  Consumption.swift
//  WatermeterofTheFuture
//
//  Created by Thomas Gilbert on 05/08/2016.
//  Copyright © 2016 Thomas Gilbert. All rights reserved.
//

import Foundation
import OGCSensorThings

public class Consumption {
    public static func getMidnightConsumptionLevel(datastreamId: String, dateOffset: Int, andDoStuff: (Double?) -> Void) -> Void {
        let dayInQuestion = NSDate.addUnitToDate(.Day, number: dateOffset, date: NSDate.getMidnight())
        let dayInQuestionJson = NSDate.jsonDate(dayInQuestion)
        
        let upperBoundaryDay = NSDate.addUnitToDate(.Day, number: 1, date: dayInQuestion)
        let upperBoundaryDayJson = NSDate.jsonDate(upperBoundaryDay)
        
        DefaultAPI.datastreamsDatastreamIdObservationsGet(datastreamId: datastreamId, orderby: "phenomenonTime asc", top: 1, skip: nil, filter: "phenomenonTime gt '\(dayInQuestionJson)' and phenomenonTime lt '\(upperBoundaryDayJson)'") { (data, error) in
            print(data?.value?.first?.result)
            print(data?.value?.first?.phenomenonTime)
            
            if let result = data?.value?.first?.result {
                andDoStuff(Double(result))
            } else {
                andDoStuff(nil)
            }
        }
    }
    
    public static func getTodaysCurrentConsumptionLevel(datastreamId: String, dateOffset: Int, andDoStuff: (Double?) -> Void) -> Void {
        
        let dayInQuestion = NSDate.addUnitToDate(.Day, number: dateOffset, date: NSDate.getMidnight())
        let dayInQuestionJson = NSDate.jsonDate(dayInQuestion)
        
        let upperBoundaryDay = NSDate.addUnitToDate(.Day, number: 1, date: dayInQuestion)
        let upperBoundaryDayJson = NSDate.jsonDate(upperBoundaryDay)
        
        DefaultAPI.datastreamsDatastreamIdObservationsGet(datastreamId: datastreamId, orderby: "phenomenonTime desc", top: 1, skip: nil, filter: "phenomenonTime lt '\(upperBoundaryDayJson)' and phenomenonTime gt '\(dayInQuestionJson)'") { (data, error) in
            print(data?.value?.first?.result)
            print(data?.value?.first?.phenomenonTime)
            
            if let result = data?.value?.first?.result {
                andDoStuff(Double(result))
            } else {
                andDoStuff(nil)
            }
        }
    }
}

public extension NSDate {
    public static func getMidnight() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        // Only extract YMD and TZ
        let components = calendar.components([.Year, .Month, .Day, .TimeZone], fromDate: NSDate())
        
        return calendar.dateFromComponents(components)!
    }
    
    public static func jsonDate(date: NSDate) -> String {
        let dateFor = NSDateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFor.stringFromDate(date)
    }
    
    public static func addUnitToDate(unitType: NSCalendarUnit, number: Int, date:NSDate) -> NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(
            unitType,
            value: number,
            toDate: date,
            options: NSCalendarOptions(rawValue: 0))!
    }
}