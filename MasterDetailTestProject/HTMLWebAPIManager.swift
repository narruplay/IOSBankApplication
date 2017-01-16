//
//  APIManager.swift
//  MasterDetailTestProject
//
//  Created by Adel Khaziakhmetov on 14.01.17.
//  Copyright © 2017 Adel Khaziakhmetov. All rights reserved.
//

import UIKit

class HTMLWebAPIManager: NSObject, BankDataProtocol {

    var urlString : String = "http://htmlweb.ru/service/api.php?bic="
    
    func getBankDetailInfo(bankBic : String, callBack : @escaping ((CallbackResult<BankModel>) -> Void)){
        
        urlString = "http://htmlweb.ru/service/api.php?bic=" + bankBic + "&json&charset=utf-8"
        
        let url : URL = URL(string: urlString)!
        
        let urlRequest : URLRequest = URLRequest(url: url);
        
        let urlSession : URLSession = URLSession(configuration : URLSessionConfiguration.default)
        
        let task = urlSession.dataTask(with: urlRequest) {(data, response, error) in
            
            if data != nil{
                let call = self.JSONParse(jsonData: data!)
                if call.error == nil{
                    DataManager.sharedInstance.saveBankDetailToDataBase(bankDetailModel: call.object!)
                    callBack(CallbackResult(object : call.object!))
                }else{
                    callBack(CallbackResult(error : call.error!))
                }
            }else{
                callBack(CallbackResult(error : CallbackError.ConnectionError))
            }
            
        }
        
        task.resume()
    }
    
    private func JSONParse(jsonData : Data)-> CallbackResult<BankModel>{
        var jsonarray : [String : AnyObject]? = nil
        do{
            jsonarray = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : AnyObject]
            print(jsonarray)
            if jsonarray != nil && (jsonarray?.count)! > 2{
                return CallbackResult(object : JSONToBankModel(jsonDictionary: jsonarray!))
            }else if jsonarray != nil && (jsonarray?.count)! == 2{
                print("API request limit error")
                return CallbackResult(error : CallbackError.BankDetailAPILoadError)
            }else{
                return CallbackResult(error : CallbackError.BankDetailAPILoadError)
            }
        }catch{
            print(error)
            return CallbackResult(error : CallbackError.JSONParseError)
        }
    }
    
    private func JSONToBankModel(jsonDictionary : [String : AnyObject])->BankModel{
        let bankModel = BankModel()
        
        bankModel.bankName = jsonDictionary["name"] as! String
        bankModel.bankBIK = jsonDictionary["bic"] as! String
        bankModel.city = jsonDictionary["city"] as? String
        bankModel.adress = jsonDictionary["adress"] as? String
        bankModel.korrNumber = jsonDictionary["ks"] as? String
        bankModel.tel = jsonDictionary["tel"] as? String
        
        return bankModel
    }
    
}
