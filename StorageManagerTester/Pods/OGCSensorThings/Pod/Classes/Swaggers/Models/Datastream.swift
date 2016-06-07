//
// Datastream.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


/** A datastream groups a collection of observations that are related in some way. The one constraint is that the observations in a datastream must measure the same observed property (i.e., one phenomenon). */
public class Datastream: JSONEncodable {

    /** ID is the system-generated identifier of an entity. ID is unique among the entities of the same entity type. */
    public var iotId: AnyObject?
    /** Self-Link is the absolute URL of an entity which is unique among all other entities. */
    public var iotSelfLink: String?
    /** This is the description of the datastream entity. The content is open to support other description languages. */
    public var description: String?
    /**  A JSON Object containing three key- value pairs. The name property presents the full name of the unitOfMeasurement; the symbol property shows the textual form of the unit symbol; and the definition contains the IRI defining the unitOfMeasurement. The values of these properties SHOULD follow the Unified Code for Unit of Measure (UCUM). */
    public var unitOfMeasure: AnyObject?
    /** The type of Observation (with  unique result type), which is used by  the service to encode observations. E.g.  http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement */
    public var observationType: String?
    /** The spatial bounding box of the spatial  extent of all FeaturesOfInterest  that belong to the Observations  associated with this Datastream. Typically a GeoJSON Polygon */
    public var observedArea: AnyObject?
    /** The temporal bounding box of the phenomenon times of all observations  belonging to this Datastream.  TM_Period(ISO 8601 Time Interval) */
    public var phenomenonTime: String?
    /** The temporal bounding box of the result times of all observations belonging to this Datastream. TM_Period (ISO 8601 Time Interval) */
    public var resultTime: String?
    /** A Thing has zero-to-many Datastreams. A Datastream entity SHALL only link to a Thing as a collection of Observations . */
    public var thing: Thing?
    /** The Observations in a Datastream are performed by one-and-only-one Sensor. One Sensor MAY produce zero-to-many Observations in different Datastreams. */
    public var sensor: Sensor?
    /** The observations of a datastream SHALL observe the same observedProperty. The observations of different datastreams MAY observe the same observedProperty. */
    public var observedProperty: ObservedProperty?
    /** A datastream has zero-to-many observations. One observation SHALL occur in one and only one Datastream. */
    public var observations: [Observation]?
    /** link to related entities */
    public var thingiotNavigationLink: String?
    /** link to related entities */
    public var sensoriotNavigationLink: String?
    /** link to related entities */
    public var observedPropertyiotNavigationLink: String?
    /** link to related entities */
    public var observationsiotNavigationLink: String?
    

    public init() {}

    // MARK: JSONEncodable
    func encodeToJSON() -> AnyObject {
        var nillableDictionary = [String:AnyObject?]()
        nillableDictionary["@iot.id"] = self.iotId
        nillableDictionary["@iot.selfLink"] = self.iotSelfLink
        nillableDictionary["description"] = self.description
        nillableDictionary["unitOfMeasure"] = self.unitOfMeasure
        nillableDictionary["observationType"] = self.observationType
        nillableDictionary["observedArea"] = self.observedArea
        nillableDictionary["phenomenonTime"] = self.phenomenonTime
        nillableDictionary["resultTime"] = self.resultTime
        nillableDictionary["Thing"] = self.thing?.encodeToJSON()
        nillableDictionary["Sensor"] = self.sensor?.encodeToJSON()
        nillableDictionary["ObservedProperty"] = self.observedProperty?.encodeToJSON()
        nillableDictionary["Observations"] = self.observations?.encodeToJSON()
        nillableDictionary["Thing@iot.navigationLink"] = self.thingiotNavigationLink
        nillableDictionary["Sensor@iot.navigationLink"] = self.sensoriotNavigationLink
        nillableDictionary["ObservedProperty@iot.navigationLink"] = self.observedPropertyiotNavigationLink
        nillableDictionary["Observations@iot.navigationLink"] = self.observationsiotNavigationLink
        let dictionary: [String:AnyObject] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
