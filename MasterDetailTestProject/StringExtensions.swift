//
//  StringExtensions.swift
//  MasterDetailTestProject
//
//  Created by Adel Khaziakhmetov on 15.01.17.
//  Copyright © 2017 Adel Khaziakhmetov. All rights reserved.
//
import UIKit

extension String{
    func substringFromRange(range : NSRange) -> String{
        let start = self.index(self.startIndex, offsetBy: range.location)
        let end = self.index(self.startIndex, offsetBy: range.location + range.length)
        
        return self.substring(with: start..<end)
    }
}
