//
//  BankModel.swift
//  MasterDetailTestProject
//
//  Created by Adel Khaziakhmetov on 14.01.17.
//  Copyright © 2017 Adel Khaziakhmetov. All rights reserved.
//

import UIKit

class BankModel: NSObject {

    
    var bankBIK : String = String()
    
    var bankName : String = String()
    
    
    var isDetailLoaded : Bool = false {
        didSet{
            if isDetailLoaded{
                detailDataUpdateDate = Date.init(timeIntervalSinceNow: 0)
            }
        }
    }
    
    
    convenience init(name : String, bic : String){
        self.init()
    
        bankBIK = bic
        bankName = name
    }
    
    var detailDataUpdateDate : Date?
    
    var city : String?
    
    var adress : String?
    
    var korrNumber : String?
    
    var tel : String?
    
}
