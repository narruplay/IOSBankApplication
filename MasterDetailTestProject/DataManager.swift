//
//  DataManager.swift
//  MasterDetailTestProject
//
//  Created by Adel Khaziakhmetov on 14.01.17.
//  Copyright © 2017 Adel Khaziakhmetov. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject, BankListProtocol, BankDataProtocol{
    
    static let sharedInstance = DataManager()
    var isUpdatable : Bool = true
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "BankListModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func saveContext () -> CallbackError? {
        isUpdatable = false
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                return CallbackError.DataBaseSaveError
            }
        }
        return nil
    }
    
    func getContext() -> NSManagedObjectContext{
        NotificationCenter.default.addObserver(self, selector: #selector(setUpdatable), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
        return persistentContainer.viewContext
    }
    
    func setUpdatable(){
        isUpdatable = true
        
    }
    
    func clearDataBase(callback : (CallbackError?) -> ()){
        
        let fetchRequest : NSFetchRequest<DBBank> = DBBank.fetchRequest()
        var searchResult : [NSManagedObject] = [NSManagedObject]()
        
        do{
            searchResult = try getContext().fetch(fetchRequest)
            
            for object in searchResult{
                self.getContext().delete(object)
            }
            
            callback(saveContext())
            
        }catch{
            callback(CallbackError.DataBaseReadError)
        }
    }
    
    func saveBankListToDataBase(bankList : [BankModel], callback : ((CallbackError?) -> ())){
        
        var updateCounter  : Int = 0
        for bank in bankList{
            if (getDBBankFor(bankBic: bank.bankBIK)).object == nil{
                DBBank.setBankManagedObject(bankModel: bank)
                updateCounter += 1;
            }
        }
        
        if(updateCounter > 0){
            callback(saveContext())
        }else{
            callback(nil)
        }
    }
    
    func saveBankDetailToDataBase(bankDetailModel : BankModel)->CallbackError?{
        
        
        let fetchRequest : NSFetchRequest<DBBank> = DBBank.fetchRequest()
        
        let predicate : NSPredicate = NSPredicate.init(format: "bic CONTAINS[cd] %@", bankDetailModel.bankBIK)
        
        fetchRequest.predicate = predicate
        
        var searchResult : [NSManagedObject] = [NSManagedObject]()
        
        do{
            searchResult = try getContext().fetch(fetchRequest)
            
        }catch{
            return CallbackError.DataBaseReadError
        }
        
        if searchResult.count > 0{
            
            do {
                try DBBankDetail.setBankDetailManagedObject(object: searchResult[0], bankModel: bankDetailModel)
                return saveContext()
            } catch  {
                return CallbackError.DataBaseReadError
            }
        
        }
        
        return CallbackError.DataBaseNoDataError
    }

    func getBankFor(searchString : String) -> CallbackResult<[BankModel]>{
        let fetchRequest : NSFetchRequest<DBBank> = DBBank.fetchRequest()
        
        let predicate : NSPredicate = NSPredicate.init(format: "bic CONTAINS[c] %@ OR name CONTAINS[c] %@", searchString, searchString)
        
        fetchRequest.predicate = predicate
        
        var searchResult : [NSManagedObject] = [NSManagedObject]()
        
        do{
            searchResult = try getContext().fetch(fetchRequest)
            
        }catch{
            return CallbackResult(error: CallbackError.DataBaseReadError)
        }
        
        if searchResult.count > 0{
            
            var resultArray : [BankModel] = [BankModel]()
            
            for object in searchResult{
                resultArray.append(DBBank.getBankFromManagedObject(object: object))
            }
            
            return CallbackResult(object : resultArray)
        }else{
            return CallbackResult(error: CallbackError.DataBaseNoDataError)
        }
    }
    
    func getDBBankFor(bankBic : String)-> CallbackResult<NSManagedObject>{
        let fetchRequest : NSFetchRequest<DBBank> = DBBank.fetchRequest()
        
        var searchResult : [NSManagedObject] = [NSManagedObject]()
        
        let predicate : NSPredicate = NSPredicate.init(format: "bic CONTAINS[c] %@", bankBic)
        
        fetchRequest.predicate = predicate
        fetchRequest.includesPropertyValues = true
        
        do{
            searchResult = try getContext().fetch(fetchRequest)
            
        }catch{
            return CallbackResult(error: CallbackError.DataBaseReadError)
        }
        
        if searchResult.count > 0{
            
            return CallbackResult(object : searchResult[0])
        }else{
            return CallbackResult(error: CallbackError.DataBaseNoDataError)
        }
    }
    
    func getBankDetailInfo(bankBic : String, callBack : @escaping ((CallbackResult<BankModel>) -> Void)){

        let call = getDBBankFor(bankBic: bankBic)
        if !call.isError{
            if (call.object as! DBBank).toBankDetail != nil{
                let model = DBBankDetail.getBankDetailFromManagedObject(object: call.object!)
                callBack(CallbackResult(object: model))
            }else{
                callBack(CallbackResult(error: CallbackError.DataBaseNoDataError))
            }
        }
        else{
            callBack(CallbackResult(error: call.error!))
        }
    }
    
    func getBankList(callBack : @escaping ((CallbackResult<[BankModel]>)->())){
        
        let fetchRequest : NSFetchRequest<DBBank> = DBBank.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var searchResult : [NSManagedObject] = [NSManagedObject]()
        
        do{
            searchResult = try getContext().fetch(fetchRequest)
            
        }catch{
            callBack(CallbackResult(error : CallbackError.DataBaseReadError))
        }
        
        if searchResult.count > 0{
            
            var resultArray : [BankModel] = [BankModel]()
            
            for object in searchResult{
                resultArray.append(DBBank.getBankFromManagedObject(object: object))
            }
            
            callBack(CallbackResult(object : resultArray))
        }else{
            callBack(CallbackResult(error : CallbackError.DataBaseNoDataError))
        }
        
    }
    
}
