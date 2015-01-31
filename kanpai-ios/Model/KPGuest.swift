//
//  KPGuest.swift
//  kanpai-ios
//
//  Copyright (c) 2015年 kanpai. All rights reserved.
//

import UIKit
import Realm

class KPGuest: RLMObject {
   
    var id: String?
    let name: String = ""
    let phoneNumber: String = ""
    var attendance = false
    
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
        self.name = name
        self.phoneNumber = phoneNumber
        
        super.init()
    }
}
