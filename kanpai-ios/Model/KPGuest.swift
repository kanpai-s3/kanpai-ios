//
//  KPGuest.swift
//  kanpai-ios
//
//  Copyright (c) 2015年 kanpai. All rights reserved.
//

import UIKit
import Realm

class KPGuest: RLMObject, Printable {
    
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var phoneNumber: String = ""
    dynamic var attendance = false
    
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
    
    init(name: String, phoneNumber: String) {
        super.init()
        
        self.name = name
        self.phoneNumber = phoneNumber
    }
    
    override var description: String {
        return "( name: \(self.name), phoneNumber: \(self.phoneNumber). attendance: \(self.attendance) )"
    }
}
