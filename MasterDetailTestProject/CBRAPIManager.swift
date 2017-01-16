//
//  CBRAPIManager.swift
//  MasterDetailTestProject
//
//  Created by Adel Khaziakhmetov on 14.01.17.
//  Copyright © 2017 Adel Khaziakhmetov. All rights reserved.
//

import UIKit

let urlString : String = "http://www.cbr.ru/scripts/XML_bic.asp"

class CBRAPIManager: NSObject, BankListProtocol {
    
    func getBankList(callBack : @escaping ((CallbackResult<[BankModel]>)->())) {
        
        let parser : AKXMLParser = AKXMLParser()
        
        let url : URL = URL(string: urlString)!
        let urlRequest : URLRequest = URLRequest(url: url);
        
        let urlSession : URLSession = URLSession(configuration : URLSessionConfiguration.default)
        
        let task = urlSession.dataTask(with: urlRequest) {(data, response, error) in
            if data != nil{
                callBack(CallbackResult(object : parser.parseAsyncXML(data: data!)))
            }else{
                callBack(CallbackResult(error : CallbackError.BankListAPILoadError))
            }
        }
        
        task.resume()
    }
    
}
