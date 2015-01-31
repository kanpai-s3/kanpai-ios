//
//  KPParty.swift
//  kanpai-ios
//
//  Copyright (c) 2015年 kanpai. All rights reserved.
//

import UIKit

class KPParty: NSObject {
   
    dynamic var id: String?
    dynamic let name: String
    dynamic let beginAt: NSDate
    dynamic var location: String?
    dynamic var message: String?
    
    init(name: String, beginAt: NSDate) {
        self.name = name
        self.beginAt = beginAt

        super.init()
    }
    
    func ISO8601StringForBeginAt() -> String {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.stringFromDate(self.beginAt)
    }
    
}
