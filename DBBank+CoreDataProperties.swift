//
//  DBBank+CoreDataProperties.swift
//  MasterDetailTestProject
//
//  Created by Adel Khaziakhmetov on 15.01.17.
//  Copyright © 2017 Adel Khaziakhmetov. All rights reserved.
//

import Foundation
import CoreData


extension DBBank {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBBank> {
        return NSFetchRequest<DBBank>(entityName: "Bank");
    }

    @NSManaged public var bic: String?
    @NSManaged public var isCached: Bool
    @NSManaged public var name: String?
    @NSManaged public var updateDate: NSDate?
    @NSManaged public var toBankDetail: DBBankDetail?

}
