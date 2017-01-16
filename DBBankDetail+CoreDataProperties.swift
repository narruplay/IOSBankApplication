//
//  DBBankDetail+CoreDataProperties.swift
//  MasterDetailTestProject
//
//  Created by Adel Khaziakhmetov on 15.01.17.
//  Copyright © 2017 Adel Khaziakhmetov. All rights reserved.
//

import Foundation
import CoreData


extension DBBankDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBBankDetail> {
        return NSFetchRequest<DBBankDetail>(entityName: "BankDetail");
    }

    @NSManaged public var adress: String?
    @NSManaged public var city: String?
    @NSManaged public var koressNumber: String?
    @NSManaged public var tel: String?
    @NSManaged public var toBank: DBBank?

}
