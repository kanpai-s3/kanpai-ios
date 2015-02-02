//
//  KPParty.swift
//  kanpai-ios
//
//  Copyright (c) 2015年 kanpai. All rights reserved.
//

import UIKit
import Realm

class KPParty: RLMObject {
    
    dynamic var id: String = ""
    dynamic var owner: String = ""
    dynamic var beginAt: NSDate = NSDate()
    dynamic var location: String = ""
    dynamic var message: String = ""
    
    dynamic var guests = RLMArray(objectClassName: KPGuest.className())
    
    private var guestsWaitingInvite = [KPGuest]()
    
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
    
    convenience init(owner: String, beginAt: NSDate) {
        self.init(owner: owner, beginAt: beginAt, location: "", message: "")
    }
    
    init(owner: String, beginAt: NSDate, location: String, message: String) {
        self.owner    = owner
        self.beginAt  = beginAt
        self.location = location
        self.message  = message
        
        super.init()
    }
    
    func ISO8601StringForBeginAt() -> String {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.stringFromDate(self.beginAt)
    }
    
    func hold(callback: (NSError?) -> Void) {
        if !self.id.isEmpty {
            callback(nil)
            return
        }
        
        let client = KPClient(baseURL: Constans.BaseURL)
        client.postParty(self) { (error, p) in
            if error != nil {
                callback(error)
                return
            }
            
            self.id = p.id
            
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            realm.addObject(self)
            realm.commitWriteTransaction()
            callback(nil)
        }
    }
    
    func invite(inviteGuests: [KPGuest], callback: (NSError?) -> Void) {
        self.guestsWaitingInvite += inviteGuests
        
        if self.id.isEmpty {
            return
        }
        
        self.p_invite(callback)
    }
    
    private func p_invite(callback: (NSError?) -> Void) {
        if self.guestsWaitingInvite.isEmpty {
            callback(nil)
            return
        }
        
        let inviteGuest = self.guestsWaitingInvite.removeLast()
        
        let client = KPClient(baseURL: Constans.BaseURL)
        client.addGuest(inviteGuest, to: self) { (error, g) in
            if error != nil {
                callback(error)
                return
            }
            
            inviteGuest.id = g.id
            
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            realm.addObject(inviteGuest)
            self.guests.addObject(inviteGuest)
            realm.commitWriteTransaction()
            self.p_invite(callback)
        }
    }    
}
