//
//  KPPartyEditViewController.swift
//  kanpai-ios
//
//  Copyright (c) 2015年 kanpai. All rights reserved.
//

import UIKit

class KPPartyEditViewController: UITableViewController, KPPersonPickerViewControllerDelegate {
    
    let LocationCell   = 0
    let BeginAtCell    = 1
    let DataPickerCell = 2
    let GuestCell      = 3
    let MessageCell    = 4
    
    @IBOutlet var locationField: UITextField?
    @IBOutlet var beginAtLabel: UILabel?
    @IBOutlet var dataPicker: UIDatePicker?
    @IBOutlet var messageField: UITextView?
    
    var guests = [KPPerson]()
    
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
    
    @IBAction func doneEdit(sender: AnyObject) {
        let owner    = ""
        let location = self.locationField?.text
        let beginAt  = self.dataPicker?.date
        let guests   = self.guests
        let message  = self.messageField?.text

        // let party = KPParty(name: <#String#>, beginAt: <#NSDate#>)
        // TODO: post party to server
    }
    
    private func dateStringFor(date: NSDate) -> String {
        return NSDateFormatter.localizedStringFromDate(date, dateStyle: .NoStyle, timeStyle: .ShortStyle)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch tableView.cellForRowAtIndexPath(indexPath)!.tag {
        case GuestCell:
            let personPicker = KPPersonPickerViewController()
            personPicker.personPickerDelegate = self
            personPicker.selectedPersons = self.guests
            let navigationController = UINavigationController(rootViewController: personPicker)
            self.presentViewController(navigationController, animated: true, completion: nil)
        default:
            break
        }
    }
    
    // MARK: - Person picker view delegate
    
    func personPickerViewController(personPickerViewController: KPPersonPickerViewController, didSelectedPersons persons: [KPPerson]) {
        self.guests = persons
    }
    
    func personPickerViewControllerDidCancel(personPickerViewController: KPPersonPickerViewController) {
        // Notting to do
    }
}
