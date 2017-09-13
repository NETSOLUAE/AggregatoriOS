//
//  VEHICLE_MODEL+CoreDataProperties.swift
//  Aggregator
//
//  Created by Mac Mini on 8/27/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import Foundation
import CoreData


extension VEHICLE_MODEL {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VEHICLE_MODEL> {
        return NSFetchRequest<VEHICLE_MODEL>(entityName: "VEHICLE_MODEL")
    }

    @NSManaged public var makeID: String?
    @NSManaged public var makeName: String?
    @NSManaged public var modelID: String?
    @NSManaged public var modelName: String?

}
