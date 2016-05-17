//
// SensorsResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public class SensorsResponse: JSONEncodable {

    public var iotCount: Double?
    public var value: [Sensor]?
    public var iotNextLink: String?
    

    public init() {}

    // MARK: JSONEncodable
    func encodeToJSON() -> AnyObject {
        var nillableDictionary = [String:AnyObject?]()
        nillableDictionary["@iot.count"] = self.iotCount
        nillableDictionary["value"] = self.value?.encodeToJSON()
        nillableDictionary["@iot.nextLink"] = self.iotNextLink
        let dictionary: [String:AnyObject] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
