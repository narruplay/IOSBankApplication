//
//  DetailViewController.swift
//  MasterDetailTestProject
//
//  Created by Adel Khaziakhmetov on 13.12.16.
//  Copyright © 2016 Adel Khaziakhmetov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var isShown : Bool = false
    var bankModel : BankModel!
    var phoneNumbers : [PhoneNumber] = [PhoneNumber]()
    

    @IBOutlet weak var activityView: UIView!
    
    @IBOutlet weak var phoneLabelTap: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if phoneLabelTap != nil{
            phoneLabelTap.isUserInteractionEnabled = true
            phoneLabelTap.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callNumber)))
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (isShown){
            getDetailInfo()
        }else{
            self.title = "Информация о банке"
            endActivity()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        isShown = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    func updateLabels(){
        for label in self.view.subviews[0].subviews{

            switch label.tag {
                case 1:
                    (label as! UILabel).text = bankModel.bankName
                case 2:
                    (label as! UILabel).text = bankModel.bankBIK
                case 3:
                    (label as! UILabel).text = bankModel.korrNumber
                case 4:
                    (label as! UILabel).text = bankModel.city
                case 5:
                    (label as! UILabel).text = bankModel.adress
                case 6:
                    let phoneNumbers = regex(phoneString: bankModel.tel!)
                    for number in phoneNumbers{
                        (label as! UILabel).text = (label as! UILabel).text! + number.getNumber() + "  "
                    }
                default:
                    break
            }
        }
        endActivity()
    }
    
    func getDetailInfo(){
        startActivity()
        ServiceProvider.sharedInstance.getBankDetailInfo(bankBic: bankModel.bankBIK) { (call) in
            if call.object == nil{
                AlertController.sharedInstance.handleCallbackError(error: call.error!, retryAction: nil)
            }else{
                    MainThreadExecuter.execute {
                        self.bankModel.adress = call.object?.adress!
                        self.bankModel.city = call.object?.city!
                        self.bankModel.korrNumber = call.object?.korrNumber!
                        self.bankModel.tel = call.object?.tel!
                        self.updateLabels()
                }
                
            }
        }
    }
    
    func startActivity(){
        if activityView != nil{
            activityView.isHidden = false
            
            (activityView.subviews[0] as! UIActivityIndicatorView).startAnimating()
        }
    }
    
    func endActivity(){
        if activityView != nil{
            (activityView.subviews[0] as! UIActivityIndicatorView).stopAnimating()
            activityView.isHidden = true
        }
    }
    
    func regex(phoneString: String)-> [PhoneNumber]{
        
        var code = "+7"
        var phone = ""
        var phoneNumbers : [PhoneNumber] = [PhoneNumber]()
        
        do{
            let reg = try NSRegularExpression(pattern: "(\\((\\d+)\\))\\s*(\\d+)", options: [])
     
            
            for match in reg.matches(in: phoneString, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: phoneString.characters.count)){

                    code = phoneString.substringFromRange(range: match.rangeAt(2))
                    phone = phoneString.substringFromRange(range: match.rangeAt(3))
                    
                    phoneNumbers.append(PhoneNumber(appendix : "+7", code: code, phone: phone))
                
                
            }
        }catch{
            print("Ошибка разбора телефонного номера")
        }
        
        return phoneNumbers
    }
    
    func callNumber() {
        
        guard let number = URL(string: "telprompt://" + "+74534534534") else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }

}

struct PhoneNumber{
    var appendix : String
    var code : String
    var phone : String
    
    func getNumber()-> String{
        return appendix + " (" + code + ") " + phone
    }
    
    func getCallNumber() -> String{
        return appendix + code + phone
    }
}


