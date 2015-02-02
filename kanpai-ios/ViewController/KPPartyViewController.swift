//
//  KPPartyViewController.swift
//  kanpai-ios
//
//  Copyright (c) 2015年 kanpai. All rights reserved.
//

import UIKit

class KPPartyViewController: UITableViewController {

    let LocationCell   = 0
    let BeginAtCell    = 1
    let GuestCell      = 2
    let MessageCell    = 3
    
    @IBOutlet var locationLabel: UILabel?
    @IBOutlet var beginAtLabel: UILabel?
    @IBOutlet var messageField: UITextView?
    
    private var party = KPParty()

    override func viewDidAppear(animated: Bool) {
        if let party = KPParty.allObjects().firstObject() as? KPParty {
            self.locationLabel?.text = party.location
            self.beginAtLabel?.text = dateStringFor(party.beginAt)
            
            // MEMO: why is error??
            // self.messageField?.text = party.message
            
            self.party = party
        } else {
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("KPPartyViewController") as UIViewController
            viewController.modalTransitionStyle = .FlipHorizontal
            self.navigationController?.presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    private func dateStringFor(date: NSDate) -> String {
        return NSDateFormatter.localizedStringFromDate(date, dateStyle: .NoStyle, timeStyle: .ShortStyle)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? KPGuestListViewController {
            viewController.party = self.party
        }
    }
}
