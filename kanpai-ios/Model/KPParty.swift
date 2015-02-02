//
//  KPParty.swift
//  kanpai-ios
//
//  Copyright (c) 2015年 kanpai. All rights reserved.
//

import UIKit
import Realm

class KPParty: RLMObject {
   
    dynamic var id: String?
    dynamic let owner: String = ""
    dynamic let beginAt: NSDate = NSDate()
    dynamic var location: String?
    dynamic var message: String?
    
    override init!() {
        super.init()
    }
    
    override init!(object value: AnyObject!, schema: RLMSchema!) {
        super.init(object: value, schema: schema)
    }
    
    override init!(object: AnyObject!) {
        super.init(object: object)
    }
    
    override init!(objectSchema schema: RLMObjectSchema!) {
        super.init(objectSchema: schema)
    }
    
    init(owner: String, beginAt: NSDate) {
        self.owner = owner
        self.beginAt = beginAt

        super.init()
    }
    
    func ISO8601StringForBeginAt() -> String {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.stringFromDate(self.beginAt)
    }
    
}
