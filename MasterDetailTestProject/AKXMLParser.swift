//
//  AKXMLParser.swift
//  MasterDetailTestProject
//
//  Created by Adel Khaziakhmetov on 14.01.17.
//  Copyright © 2017 Adel Khaziakhmetov. All rights reserved.
//

import UIKit

class AKXMLParser: NSObject, XMLParserDelegate {
    
    private var myXMLParser : XMLParser!
    private var insideItem : Bool = false
    private var currentParsedElement : String = ""
    private var bankModels : [BankModel]!
    
    private var bankName : String = ""
    private var bankBic : String = ""
    
    public func parseAsyncXML(data : Data) -> [BankModel]{
        bankModels = [BankModel]()
        
        myXMLParser = XMLParser(data : data)
        
        myXMLParser.delegate = self
        
        myXMLParser.parse()
        
        return bankModels
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "Record"{
            insideItem = true
            
        }
        if insideItem {
            switch elementName{
                case "ShortName":
                    currentParsedElement = elementName
                case "Bic":
                    currentParsedElement = elementName
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentParsedElement{
        case "ShortName":
            bankName = string
        case "Bic":
            bankBic = string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Record"{
            let bankModel : BankModel = BankModel()
            bankModel.bankName = bankName
            bankModel.bankBIK = bankBic
            
            bankModels.append(bankModel)
            insideItem = false
        }else if(elementName == "ShortName"){
            currentParsedElement = ""
        }else if (elementName == "Bic"){
            currentParsedElement = ""
        }
    }
}
