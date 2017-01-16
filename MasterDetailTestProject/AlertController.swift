//
//  AlertController.swift
//  MasterDetailTestProject
//
//  Created by Adel Khaziakhmetov on 16.01.17.
//  Copyright © 2017 Adel Khaziakhmetov. All rights reserved.
//

import UIKit

class AlertController: NSObject {

    static let sharedInstance = AlertController()
    
    func handleCallbackError(error : CallbackError, retryAction : (()->())?){
        let alert : UIAlertController = UIAlertController()
        alert.message = error.message()
        alert.title = error.title()
        
        let alertActionOK : UIAlertAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: { action in
            
        })
         alert.addAction(alertActionOK)
        
        if retryAction != nil{
            let alertActionRetry : UIAlertAction = UIAlertAction(title: "Повторить", style: .default, handler: { action in
                MainThreadExecuter.execute {
                    retryAction!()
                }
            })
            alert.addAction(alertActionRetry)
        }
        
        MainThreadExecuter.execute {
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: false, completion: nil)
        }
    }
}
