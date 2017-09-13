//
//  USER_INFO+CoreDataProperties.swift
//  Aggregator
//
//  Created by Mac Mini on 9/9/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import Foundation
import CoreData


extension USER_INFO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<USER_INFO> {
        return NSFetchRequest<USER_INFO>(entityName: "USER_INFO")
    }

    @NSManaged public var age: String?
    @NSManaged public var companyID: String?
    @NSManaged public var email: String?
    @NSManaged public var id: String?
    @NSManaged public var mobile: String?
    @NSManaged public var name: String?
    @NSManaged public var nationalID: String?
    @NSManaged public var price: String?
    @NSManaged public var regidtrationDate: String?
    @NSManaged public var rto: String?
    @NSManaged public var status: String?
    @NSManaged public var vehicleMake: String?
    @NSManaged public var vehicleModel: String?
    @NSManaged public var vehicleType: String?
    @NSManaged public var vehicleUsage: String?
    @NSManaged public var vehicleVariant: String?
    @NSManaged public var yom: String?

}
