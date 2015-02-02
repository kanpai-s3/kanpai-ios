//
//  KPAddressBook.swift
//  kanpai-ios
//
//  Copyright (c) 2015年 kanpai. All rights reserved.
//

import AddressBook

class KPAddressBook {
    
    private let addressBook: ABAddressBook
    private var filterBlock: ((KPPerson) -> Bool)?
    
    init?() {
        var errorRef: Unmanaged<CFErrorRef>?
        self.addressBook = ABAddressBookCreateWithOptions(nil, &errorRef).takeRetainedValue()
        
        if let errorRef = errorRef {
            debugPrint(errorRef.takeRetainedValue())
            return nil
        }
    }
    
    func filter(filterBlock: (KPPerson) -> Bool) -> Self {
        self.filterBlock = filterBlock
        return self
    }
    
    func load(callback: (([KPPerson]!, NSError!) -> Void)) {
        
        switch ABAddressBookGetAuthorizationStatus() {
        case .Denied, .Restricted:
            let error = NSError(
                domain: ABAddressBookErrorDomain,
                code: kABOperationNotPermittedByUserError,
                userInfo: [
                    NSLocalizedDescriptionKey : "Unauthorized to access AddressBook",
                    NSLocalizedRecoverySuggestionErrorKey: "Please allow it to access in settings app"
                ])
            callback(nil, error)
        case .Authorized, .NotDetermined:
            ABAddressBookRequestAccessWithCompletion(self.addressBook, { (granted, errorRef) in
                if let errorRef = errorRef {
                    let error = errorRef as AnyObject as NSError
                    callback(nil, error)
                    return
                }
                
                if granted {
                    var persons = [KPPerson]()
                    
                    let peopleArrayRef = ABAddressBookCopyArrayOfAllPeople(self.addressBook).takeRetainedValue()
                    let count = Int(CFArrayGetCount(peopleArrayRef))
                    for var i = 0; i < count; i++ {
                        let recordRef: ABRecordRef = unsafeBitCast(CFArrayGetValueAtIndex(peopleArrayRef, i), ABRecordRef.self) as ABRecordRef
                        let person = KPPerson(recordRef: recordRef)
                        
                        if (self.filterBlock != nil) && self.filterBlock!(person) {
                            persons.append(person)
                        }
                    }
                    
                    callback(persons, nil)
                }
            })
        }
    }
}