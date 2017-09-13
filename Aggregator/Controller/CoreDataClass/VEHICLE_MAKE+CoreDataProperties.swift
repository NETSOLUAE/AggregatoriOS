//
//  VEHICLE_MAKE+CoreDataProperties.swift
//  Aggregator
//
//  Created by Mac Mini on 8/27/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import Foundation
import CoreData


extension VEHICLE_MAKE {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VEHICLE_MAKE> {
        return NSFetchRequest<VEHICLE_MAKE>(entityName: "VEHICLE_MAKE")
    }

    @NSManaged public var makeID: String?
    @NSManaged public var makeName: String?

}
