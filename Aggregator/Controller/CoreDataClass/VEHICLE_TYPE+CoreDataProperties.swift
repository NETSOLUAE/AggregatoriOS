//
//  VEHICLE_TYPE+CoreDataProperties.swift
//  Aggregator
//
//  Created by Mac Mini on 8/27/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import Foundation
import CoreData


extension VEHICLE_TYPE {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VEHICLE_TYPE> {
        return NSFetchRequest<VEHICLE_TYPE>(entityName: "VEHICLE_TYPE")
    }

    @NSManaged public var usageID: String?
    @NSManaged public var usageName: String?
    @NSManaged public var typeID: String?
    @NSManaged public var typeName: String?
    @NSManaged public var gvw: String?

}
