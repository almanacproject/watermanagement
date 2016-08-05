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
    public static func getMidnightConsumptionLevel(datastreamId: String, andDoStuff: (Double?) -> Void) -> Void {
        let today = NSDate.getMidnight()
        let todayJson = NSDate.jsonDate(today)
        
        DefaultAPI.datastreamsDatastreamIdObservationsGet(datastreamId: datastreamId, orderby: "phenomenonTime asc", top: 1, skip: nil, filter: "phenomenonTime gt '\(todayJson)'") { (data, error) in
            print(error.debugDescription)
            print(data?.iotCount)
            print(data?.value?.count)
            print(data?.value?.first?.result)
            print(data?.value?.first?.phenomenonTime)
            
            if let result = data?.value?.first?.result {
                andDoStuff(Double(result))
            } else {
                andDoStuff(nil)
            }
        }
    }
    
    public static func getTodaysCurrentConsumptionLevel(datastreamId: String, andDoStuff: (Double?) -> Void) -> Void {
        DefaultAPI.datastreamsDatastreamIdObservationsGet(datastreamId: datastreamId, orderby: "phenomenonTime desc", top: 1, skip: nil, filter: "phenomenonTime lt '\(NSDate.jsonDate(NSDate()))'") { (data, error) in
            print(error.debugDescription)
            print(data?.iotCount)
            print(data?.value?.count)
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
}