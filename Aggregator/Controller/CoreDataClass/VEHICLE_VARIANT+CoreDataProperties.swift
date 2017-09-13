//
//  VEHICLE_VARIANT+CoreDataProperties.swift
//  Aggregator
//
//  Created by Mac Mini on 8/27/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import Foundation
import CoreData


extension VEHICLE_VARIANT {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VEHICLE_VARIANT> {
        return NSFetchRequest<VEHICLE_VARIANT>(entityName: "VEHICLE_VARIANT")
    }

    @NSManaged public var makeID: String?
    @NSManaged public var modelID: String?
    @NSManaged public var variantID: String?
    @NSManaged public var makeName: String?
    @NSManaged public var modelName: String?
    @NSManaged public var variantName: String?
    @NSManaged public var attribute: String?
    @NSManaged public var startYear: String?
    @NSManaged public var endYear: String?
    @NSManaged public var sc: String?
    @NSManaged public var vehicleType: String?
    @NSManaged public var numCycle: String?
    @NSManaged public var price: String?

}
