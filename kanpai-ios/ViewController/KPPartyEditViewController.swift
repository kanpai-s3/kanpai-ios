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
    
    var persons = [KPPerson]()
    
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
        let owner    = "noda"
        let location = self.locationField?.text ?? ""
        let beginAt  = self.dataPicker?.date ?? NSDate()
        let guests   = self.persons.map { (person) -> KPGuest in
            return KPGuest(name: person.name, phoneNumber: person.tel!)
        }
        let message  = self.messageField?.text ?? ""
        
        let party = KPParty(
            owner: owner,
            beginAt: beginAt,
            location: location,
            message: message
        )

        party.hold { [unowned self] (error) in
            if error != nil {
                self.presentViewController(UIAlertController(error: error!), animated: true, completion: nil)
                return
            }
            
            party.invite(guests) { [unowned self] (error) in
                if error != nil {
                    self.presentViewController(UIAlertController(error: error!), animated: true, completion: nil)
                    return
                }
                
            }
        }
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
            personPicker.selectedPersons = self.persons
            let navigationController = UINavigationController(rootViewController: personPicker)
            self.presentViewController(navigationController, animated: true, completion: nil)
        default:
            break
        }
    }
    
    // MARK: - Person picker view delegate
    
    func personPickerViewController(personPickerViewController: KPPersonPickerViewController, didSelectedPersons persons: [KPPerson]) {
        self.persons = persons
    }
    
    func personPickerViewControllerDidCancel(personPickerViewController: KPPersonPickerViewController) {
        // Notting to do
    }
}
