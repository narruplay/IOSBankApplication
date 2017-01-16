//
//  ServiceProvider.swift
//  MasterDetailTestProject
//
//  Created by Adel Khaziakhmetov on 14.01.17.
//  Copyright © 2017 Adel Khaziakhmetov. All rights reserved.
//

import UIKit

class ServiceProvider: NSObject {
    
    static let sharedInstance = ServiceProvider()
    
    var bankListIndex : Int = 0
    var bankDetailIndex : Int = 0
    
    let bankListProviders : [BankListProtocol] = [DataManager.sharedInstance, CBRAPIManager()];
    let bankDetailProviders : [BankDataProtocol] = [DataManager.sharedInstance, HTMLWebAPIManager()];
    
    func getBankList(completion : @escaping ((CallbackResult<[BankModel]>) -> Void)){
        bankListProviders[bankListIndex].getBankList { (call) in
            if call.object == nil && self.bankListIndex < self.bankListProviders.count - 1{
                self.bankListIndex += 1
                self.getBankList(completion: completion)
            }else if call.object != nil{
                if self.bankListIndex != 0{
                    
                    MainThreadExecuter.execute {
                        DataManager.sharedInstance.saveBankListToDataBase(bankList: call.object!, callback: { (call) in
                            if call != nil{
                                MainThreadExecuter.execute {
                                    AlertController.sharedInstance.handleCallbackError(error: call!, retryAction: nil)
                                }
                            }
                            
                        })
                    }
                }
                
                if self.bankListIndex == 1{
                    self.bankListIndex = 0
                    self.getBankList(completion: completion)
                }else{
                    completion(CallbackResult(object: call.object!))
                }
            }else{
                self.bankListIndex = 0
                completion(CallbackResult(error : call.error!))
            }
        }
    }
    
    func updateBankList(completion : @escaping ((CallbackResult<[BankModel]>) -> Void)){
        bankListIndex += 1;
        getBankList { (call) in
            completion(call)
        }
    }
    
    func getBankDetailInfo(bankBic : String, completion : @escaping ((CallbackResult<BankModel>) -> Void)){
        bankDetailProviders[bankDetailIndex].getBankDetailInfo(bankBic: bankBic) { (call) in
            if call.object == nil && self.bankDetailIndex < self.bankDetailProviders.count - 1{
                self.bankDetailIndex += 1
                self.getBankDetailInfo(bankBic: bankBic, completion: completion)
            }else if call.object != nil{
                self.bankDetailIndex = 0
                completion(CallbackResult(object : call.object!))
            }else{
                self.bankDetailIndex = 0
                completion(CallbackResult(error : call.error!))
            }
        }
    }
    


}
