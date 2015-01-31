//
//  KPGuest.swift
//  kanpai-ios
//
//  Copyright (c) 2015年 kanpai. All rights reserved.
//

import UIKit

class KPGuest: NSObject {
   
    var id: String?
    let name: String
    let phoneNumber: String
    var attendance = false
    
    init(name: String, phoneNumber: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        
        super.init()
    }
}
