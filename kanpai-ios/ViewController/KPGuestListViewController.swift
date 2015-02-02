//
//  KPGuestListViewController.swift
//  kanpai-ios
//
//  Created by Noda Shimpei on 2015/02/03.
//  Copyright (c) 2015年 kanpai. All rights reserved.
//

import UIKit
import Realm

class KPGuestListViewController: UITableViewController, KPPersonPickerViewControllerDelegate {

    var party = KPParty()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "KPGuestViewCell", bundle: nil), forCellReuseIdentifier: "KPGuestViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(self.party.guests.count)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.tableView.dequeueReusableCellWithIdentifier("KPAddGuestCell") as UITableViewCell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("KPGuestViewCell") as KPGuestViewCell
        
        let guest = self.party.guests[UInt(indexPath.row)] as KPGuest
        cell.nameLabel?.text = guest.name
        
        return cell
    }
    
    @IBAction func addGuest(sender: AnyObject) {
        let personPicker = KPPersonPickerViewController()
        personPicker.personPickerDelegate = self
        let navigationController = UINavigationController(rootViewController: personPicker)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Person picker view delegate
    
    func personPickerViewController(personPickerViewController: KPPersonPickerViewController, didSelectedPersons persons: [KPPerson]) {
        let realm = RLMRealm.defaultRealm()
        for person in persons {
            let guest = KPGuest(name: person.name, phoneNumber: person.tel!)
            realm.beginWriteTransaction()
            realm.addObject(guest)
            self.party.guests.addObject(guest)
            realm.commitWriteTransaction()
        }
        self.tableView.reloadData()
    }
    
    func personPickerViewControllerDidCancel(personPickerViewController: KPPersonPickerViewController) {
    }
}
