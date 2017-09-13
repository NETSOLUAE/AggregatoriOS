//
//  COMPANY_COVER+CoreDataProperties.swift
//  Aggregator
//
//  Created by Mac Mini on 8/27/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import Foundation
import CoreData


extension COMPANY_COVER {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<COMPANY_COVER> {
        return NSFetchRequest<COMPANY_COVER>(entityName: "COMPANY_COVER")
    }

    @NSManaged public var productID: String?
    @NSManaged public var insuredObject: String?
    @NSManaged public var coverID: String?
    @NSManaged public var coverType: String?
    @NSManaged public var coverName: String?
    @NSManaged public var company: COMPANY_DETAILS?

}
