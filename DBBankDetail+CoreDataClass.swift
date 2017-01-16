//
//  DBBankDetail+CoreDataClass.swift
//  MasterDetailTestProject
//
//  Created by Adel Khaziakhmetov on 15.01.17.
//  Copyright © 2017 Adel Khaziakhmetov. All rights reserved.
//

import Foundation
import CoreData

@objc(DBBankDetail)
public class DBBankDetail: NSManagedObject {

    static func setBankDetailManagedObject(object : NSManagedObject, bankModel : BankModel) throws{
        
        guard bankModel.adress != nil || bankModel.city != nil || bankModel.korrNumber != nil || bankModel.tel != nil else{
            throw BankModelConvertError.missingParameters
        }
        
        let dbBankDetail = NSEntityDescription.insertNewObject(forEntityName: "BankDetail", into: DataManager.sharedInstance.getContext())
        dbBankDetail.setValue(bankModel.adress, forKey: "adress")
        dbBankDetail.setValue(bankModel.city, forKey: "city")
        dbBankDetail.setValue(bankModel.korrNumber, forKey: "koressNumber")
        dbBankDetail.setValue(bankModel.tel, forKey: "tel")
        
        object.setValue(dbBankDetail, forKey: "toBankDetail")
        object.setValue(true, forKey: "isCached")
        
        let date = Date()
        
        object.setValue(date, forKey: "updateDate")
    }
    
    static func getBankDetailFromManagedObject(object : NSManagedObject) -> BankModel{
        let bankModel : BankModel = BankModel()
        
        bankModel.bankName = object.value(forKey: "name") as! String
        bankModel.bankBIK = object.value(forKey: "bic") as! String
        
       
        bankModel.korrNumber = (object as! DBBank).toBankDetail?.value(forKey: "koressNumber") as! String
        bankModel.adress = (object as! DBBank).toBankDetail?.value(forKey: "adress") as! String
        bankModel.city = (object as! DBBank).toBankDetail?.value(forKey: "city") as! String
        bankModel.tel = (object as! DBBank).toBankDetail?.value(forKey: "tel") as! String
        
        return bankModel
    }
}

enum BankModelConvertError : Error{
    case missingParameters
}
