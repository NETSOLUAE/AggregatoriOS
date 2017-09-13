//
//  VEHICLE_USAGE+CoreDataProperties.swift
//  Aggregator
//
//  Created by Mac Mini on 8/27/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import Foundation
import CoreData


extension VEHICLE_USAGE {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VEHICLE_USAGE> {
        return NSFetchRequest<VEHICLE_USAGE>(entityName: "VEHICLE_USAGE")
    }

    @NSManaged public var usageID: String?
    @NSManaged public var usageName: String?

}
