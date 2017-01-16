//
//  DBBank+CoreDataClass.swift
//  MasterDetailTestProject
//
//  Created by Adel Khaziakhmetov on 15.01.17.
//  Copyright © 2017 Adel Khaziakhmetov. All rights reserved.
//

import Foundation
import CoreData

@objc(DBBank)
public class DBBank: NSManagedObject {

    static func setBankManagedObject(bankModel : BankModel){
        let dbBank = NSEntityDescription.insertNewObject(forEntityName: "Bank", into: DataManager.sharedInstance.getContext())
        dbBank.setValue(bankModel.bankName, forKey: "name")
        dbBank.setValue(bankModel.bankBIK, forKey: "bic")
    }
    
 
    
    static func getBankFromManagedObject(object : NSManagedObject) -> BankModel{
        let bankModel : BankModel = BankModel()
        
        bankModel.bankName = object.value(forKey: "name") as! String
        bankModel.bankBIK = object.value(forKey: "bic") as! String
        
        return bankModel
    }
    
    static func getBankDetailFromManagedObject(object : NSManagedObject) -> BankModel?{
        return BankModel()
    }
    
}
