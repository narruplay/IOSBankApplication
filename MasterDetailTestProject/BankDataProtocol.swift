//
//  BankDataProtocol.swift
//  MasterDetailTestProject
//
//  Created by Adel Khaziakhmetov on 14.01.17.
//  Copyright © 2017 Adel Khaziakhmetov. All rights reserved.
//

import UIKit

protocol BankDataProtocol{
    
    func getBankDetailInfo(bankBic : String, callBack : @escaping ((CallbackResult<BankModel>) -> Void))
    
}
