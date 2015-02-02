//
//  KPPerson.swift
//  kanpai-ios
//
//  Copyright (c) 2015年 kanpai. All rights reserved.
//

import UIKit
import AddressBook

func == <T: KPPerson>(a: T, b: T) -> Bool {
    return a.contactId == b.contactId
}

class KPPerson: Equatable, Printable {
    
    let contactId: String

    let firstName: String
    let lastName: String
    let name: String

    var tel: String?
    let tels: [String]

    let thumbnail: UIImage?
    let record: ABRecordRef
    
    var description: String {
        return "[ name: \(self.name), phone: \(self.name) ]"
    }
    
    init(recordRef: ABRecordRef) {
        func stringProperty(property: ABPropertyID, recordRef: ABRecordRef) -> String {
            if let string = ABRecordCopyValue(recordRef, property)?.takeRetainedValue() as? String {
                return string
            } else {
                return ""
            }
        }
        
        func imageProperty(isFullSize: Bool, recoardRef: ABRecordRef) -> UIImage? {
            let format = isFullSize ? kABPersonImageFormatOriginalSize : kABPersonImageFormatThumbnail
            if let dataRef = ABPersonCopyImageDataWithFormat(recordRef, format)?.takeRetainedValue() {
                return UIImage(data: dataRef as NSData)
            } else {
                return nil
            }
        }
        
        func arrayProperty(property: ABPropertyID, recoardRef: ABRecordRef) -> [String] {
            var array = [String]()
            let multiVal: ABMultiValueRef = ABRecordCopyValue(recordRef, property).takeRetainedValue()
            let count = ABMultiValueGetCount(multiVal)
            for var i = 0; i < count; i++ {
                let row = ABMultiValueCopyValueAtIndex(multiVal, i).takeRetainedValue() as String
                array.append(row)
            }
            return array
        }

        self.contactId = String(ABRecordGetRecordID(recordRef))

        self.firstName = stringProperty(kABPersonFirstNameProperty, recordRef)
        self.lastName  = stringProperty(kABPersonLastNameProperty, recordRef)
        self.name      = "\(self.firstName) \(self.lastName)"

        self.tels = arrayProperty(kABPersonPhoneProperty, recordRef)
        self.tel  = self.tels.first

        self.thumbnail = imageProperty(false, recordRef)
        self.record    = recordRef
    }
}