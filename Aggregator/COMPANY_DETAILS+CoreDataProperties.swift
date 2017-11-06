//
//  COMPANY_DETAILS+CoreDataProperties.swift
//  Aggregator
//
//  Created by Mac Mini on 10/17/17.
//  Copyright © 2017 Netsol. All rights reserved.
//
//

import Foundation
import CoreData


extension COMPANY_DETAILS {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<COMPANY_DETAILS> {
        return NSFetchRequest<COMPANY_DETAILS>(entityName: "COMPANY_DETAILS")
    }

    @NSManaged public var attribute: String?
    @NSManaged public var coverPremium: String?
    @NSManaged public var effectiveDate: String?
    @NSManaged public var endDate: String?
    @NSManaged public var fees: String?
    @NSManaged public var insurerID: String?
    @NSManaged public var insurerName: String?
    @NSManaged public var lob: String?
    @NSManaged public var premiumAmount: String?
    @NSManaged public var productID: String?
    @NSManaged public var productName: String?
    @NSManaged public var productType: String?
    @NSManaged public var scheme: String?
    @NSManaged public var tax: String?
    @NSManaged public var totalPremium: String?
    @NSManaged public var idv: String?
    @NSManaged public var covers: NSSet?

}

// MARK: Generated accessors for covers
extension COMPANY_DETAILS {

    @objc(addCoversObject:)
    @NSManaged public func addToCovers(_ value: COMPANY_COVER)

    @objc(removeCoversObject:)
    @NSManaged public func removeFromCovers(_ value: COMPANY_COVER)

    @objc(addCovers:)
    @NSManaged public func addToCovers(_ values: NSSet)

    @objc(removeCovers:)
    @NSManaged public func removeFromCovers(_ values: NSSet)

}
