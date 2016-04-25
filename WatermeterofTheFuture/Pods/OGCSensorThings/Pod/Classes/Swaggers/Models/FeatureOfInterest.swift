//
// FeatureOfInterest.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public class FeatureOfInterest: JSONEncodable {

    /** The absolute geographical position of the feature of interest. This is generally the GeoJSON geometry object. In the case of the thing itself being the feature of interest, this geometry property is inherited from the thing entity by interpolating the geometries in the location entities. */
    public var geometry: String?
    /** Navigation-Link is the relative URL that retrives content of related entities. */
    public var navigationLink: String?
    /** Association-Link is the relative URL showing the related entities in other entity types. Only the Self-Links of related entities are returned when resolving Association-Links. */
    public var associationLink: String?
    /** This is the description of the feature of interest entity. The content is open to accommodate changes to SensorML and to support other description languages. In the case of the thing itself being the feature of interest, this description property is inherited from the thing entity. */
    public var description: String?
    /** Self-Link is the absolute URL of an entity which is unique among all other entities. */
    public var selfLink: String?
    /** ID is the system-generated identifier of an entity. ID is unique among the entities of the same entity type. */
    public var ID: String?
    public var observations: [Observation]?
    

    public init() {}

    // MARK: JSONEncodable
    func encodeToJSON() -> AnyObject {
        var nillableDictionary = [String:AnyObject?]()
        nillableDictionary["geometry"] = self.geometry
        nillableDictionary["navigationLink"] = self.navigationLink
        nillableDictionary["associationLink"] = self.associationLink
        nillableDictionary["description"] = self.description
        nillableDictionary["selfLink"] = self.selfLink
        nillableDictionary["ID"] = self.ID
        nillableDictionary["observations"] = self.observations?.encodeToJSON()
        let dictionary: [String:AnyObject] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
