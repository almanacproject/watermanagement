//
// Location.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public class Location: JSONEncodable {
    /** ID is the system-generated identifier of an entity. ID is unique among the entities of the same entity type. */
    public var iotId: String?
    /** Self-Link is the absolute URL of an entity which is unique among all other entities. */
    public var iotSelfLink: String?
    /** This is the description of the thing entity. The content is open to accommodate changes to SensorML and to support other description languages. */
    public var description: String?
    /** The encoding type of the location property. Its value is one of the ValueCode enumeration (see Table 8-6; currently only  application/vnd.geo+json  is supported). */
    public var encodingType: String?
    /** The location type is defined by encodingType. (only GeoJSON is supported) */
    public var location: AnyObject?
    /** Multiple Things MAY locate at the same Location . A Thing MAY not have a Location. */
    public var things: [Thing]?
    /** A Location can have zero-to-many HistoricalLocations . One HistoricalLocation SHALL have one or many Locations. */
    public var historicalLocations: [HistoricalLocation]?
    /** link to related entities */
    public var thingsiotNavigationLink: String?
    /** link to related entities */
    public var historicalLocationsiotNavigationLink: String?

    public init() {}

    // MARK: JSONEncodable
    func encodeToJSON() -> AnyObject {
        var nillableDictionary = [String:AnyObject?]()
        nillableDictionary["@iot.id"] = self.iotId
        nillableDictionary["@iot.selfLink"] = self.iotSelfLink
        nillableDictionary["description"] = self.description
        nillableDictionary["encodingType"] = self.encodingType
        nillableDictionary["location"] = self.location
        nillableDictionary["Things"] = self.things?.encodeToJSON()
        nillableDictionary["HistoricalLocations"] = self.historicalLocations?.encodeToJSON()
        nillableDictionary["Things@iot.navigationLink"] = self.thingsiotNavigationLink
        nillableDictionary["HistoricalLocations@iot.navigationLink"] = self.historicalLocationsiotNavigationLink
        let dictionary: [String:AnyObject] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}