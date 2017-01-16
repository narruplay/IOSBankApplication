//
//  BankListProtocol.swift
//  MasterDetailTestProject
//
//  Created by Adel Khaziakhmetov on 14.01.17.
//  Copyright © 2017 Adel Khaziakhmetov. All rights reserved.
//

import UIKit

protocol BankListProtocol {
    
    func getBankList(callBack : @escaping ((CallbackResult<[BankModel]>)->()))
    
}
