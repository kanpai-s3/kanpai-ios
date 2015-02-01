//
//  KPPartyEditViewController.swift
//  kanpai-ios
//
//  Copyright (c) 2015年 kanpai. All rights reserved.
//

import UIKit

class KPPartyEditViewController: UITableViewController {
    
    @IBOutlet var beginAtLabel: UILabel?
    
    override func viewDidLoad() {
        let now = NSDate()
        self.beginAtLabel?.text = self.dateStringFor(now)
    }
    
    @IBAction func didChnagedDatePickerValue(sender: AnyObject) {
        if !(sender is UIDatePicker) {
            return
        }
        
        let dp = sender as UIDatePicker
        self.beginAtLabel?.text = self.dateStringFor(dp.date)
    }
    
    private func dateStringFor(date: NSDate) -> String {
        return NSDateFormatter.localizedStringFromDate(date, dateStyle: .NoStyle, timeStyle: .ShortStyle)
    }

}
