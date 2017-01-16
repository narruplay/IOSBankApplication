//
//  MainThreadExecuter.swift
//  MasterDetailTestProject
//
//  Created by Adel Khaziakhmetov on 16.01.17.
//  Copyright © 2017 Adel Khaziakhmetov. All rights reserved.
//

import UIKit

class MainThreadExecuter: NSObject {
    
    static func execute(function : @escaping (() ->())){
        if (Thread.isMainThread){
            function()
        }else{
            DispatchQueue.main.sync {
                function()
            }
        }
    }
    
}
