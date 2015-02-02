//
//  UIAlertController-Error.swift
//  kanpai-ios
//
//  Copyright (c) 2015年 kanpai. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(error: NSError) {
        
        let reason = error.localizedFailureReason ?? ""
        let suggestion = error.localizedRecoverySuggestion ?? ""
        
        self.init(title: error.localizedDescription, message: "\(reason)\n\(suggestion)", preferredStyle: .Alert)
        self.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
    }
    
    convenience init(errorMsg: String) {
        self.init(title: "Error", message: errorMsg, preferredStyle: .Alert)
        self.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
    }
}