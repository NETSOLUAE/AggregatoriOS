//
//  VEHICLE_RTO+CoreDataProperties.swift
//  Aggregator
//
//  Created by Mac Mini on 8/27/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import Foundation
import CoreData


extension VEHICLE_RTO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VEHICLE_RTO> {
        return NSFetchRequest<VEHICLE_RTO>(entityName: "VEHICLE_RTO")
    }

    @NSManaged public var rtoID: String?
    @NSManaged public var rtoName: String?

}
