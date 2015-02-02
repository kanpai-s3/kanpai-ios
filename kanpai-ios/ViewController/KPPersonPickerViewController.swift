//
//  KPPersonPickerViewController.swift
//  kanpai-ios
//
//  Created by Noda Shimpei on 2015/02/01.
//  Copyright (c) 2015年 kanpai. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI

protocol KPPersonPickerViewControllerDelegate {
    func personPickerViewControllerDidCancel(personPickerViewController: KPPersonPickerViewController)
    func personPickerViewController(personPickerViewController: KPPersonPickerViewController, didSelectedPersons persons: [KPPerson])
}

class KPPersonPickerViewController: UITableViewController, ABPersonViewControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate {

    private var doneButton = UIBarButtonItem()
    
    private var allPersons = [KPPerson]()
    private var filteredPersons = [KPPerson]()
    
    private var searchDisplay: UISearchDisplayController?
    
    var selectedPersons = [KPPerson]()
    var addressBook = KPAddressBook()
    var personPickerDelegate: KPPersonPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = UISearchBar()
        searchBar.autoresizingMask = .FlexibleWidth
        searchBar.sizeToFit()

        self.tableView.tableHeaderView = searchBar
        
        self.searchDisplay = UISearchDisplayController(searchBar: searchBar, contentsController: self)
        self.searchDisplay?.searchResultsDataSource = self
        self.searchDisplay?.searchResultsDelegate = self
        self.searchDisplay?.delegate = self

        self.doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneToSelectPerson:")
        self.doneButton.enabled = !self.selectedPersons.isEmpty
        self.navigationItem.rightBarButtonItem = self.doneButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelToSelectPerson:")
        self.navigationItem.leftBarButtonItem = cancelButton
        
        self.addressBook?.filter { (person) -> Bool in
            return !person.tels.isEmpty
        }.load { [unowned self] (persons, error) in
            if let error = error {
                let alert = UIAlertController(title: error.localizedDescription, message: "\(error.localizedFailureReason)\n\(error.localizedRecoverySuggestion)", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            self.allPersons = persons
            self.tableView.reloadData()
        }
        
        self.tableView.registerNib(UINib(nibName: "KPPersonViewCell", bundle: nil), forCellReuseIdentifier: "KPPersonViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func personsIn(tableView: UITableView) -> [KPPerson] {
        if tableView == self.searchDisplayController?.searchResultsTableView {
            return self.filteredPersons
        } else {
            return self.allPersons
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.personsIn(tableView).count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func doneToSelectPerson(sender: AnyObject?) {
        self.personPickerDelegate?.personPickerViewController(self, didSelectedPersons: self.selectedPersons)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelToSelectPerson(sender: AnyObject?) {
        self.personPickerDelegate?.personPickerViewControllerDidCancel(self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("KPPersonViewCell") as KPPersonViewCell
        
        let person = self.personsIn(tableView)[indexPath.row]
        cell.nameLabel?.text = person.name
        cell.setThumbnail(person.thumbnail)
        
        if contains(self.selectedPersons, person) {
            cell.setCheckBok(true)
        } else {
            cell.setCheckBok(false)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as KPPersonViewCell
        
        let person = self.personsIn(tableView)[indexPath.row]
        if let index = find(self.selectedPersons, person) {
            self.selectedPersons.removeAtIndex(index)
            cell.setCheckBok(false)
        } else if person.tels.count > 1 {
            let personViewController = ABPersonViewController()
            personViewController.displayedPerson = person.record
            personViewController.displayedProperties = [Int(kABPersonPhoneProperty)]
            personViewController.allowsActions = false
            personViewController.allowsEditing = false
            personViewController.personViewDelegate = self
            self.navigationController?.pushViewController(personViewController, animated: true)
        } else {
            self.selectedPersons.append(person)
            cell.setCheckBok(true)
        }
        
        self.doneButton.enabled = !self.selectedPersons.isEmpty
    }
    
    func personViewController(personViewController: ABPersonViewController!, shouldPerformDefaultActionForPerson person: ABRecord!, property: ABPropertyID, identifier: ABMultiValueIdentifier) -> Bool {
        if property != kABPersonPhoneProperty {
            return false
        }
        
        let personContactId = String(ABRecordGetRecordID(person))
        var selectedPerson: KPPerson?
        
        for (idx, person) in enumerate(self.allPersons) {
            if person.contactId == personContactId {
                selectedPerson = person
            }
        }
        
        if selectedPerson == nil {
            return false
        }
        
        let multiVal: AnyObject = ABRecordCopyValue(person, property).takeRetainedValue()
        let index = Int(ABMultiValueGetIndexForIdentifier(multiVal, identifier))
        selectedPerson!.tel = ABMultiValueCopyValueAtIndex(multiVal, index)?.takeRetainedValue() as? String
        
        self.selectedPersons.append(selectedPerson!)
        
        self.tableView.reloadData()
        self.searchDisplayController?.searchResultsTableView.reloadData()
        
        self.doneButton.enabled = !self.selectedPersons.isEmpty
        
        self.navigationController?.popToViewController(self, animated: true)

        return false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filteredPersons.removeAll(keepCapacity: false)
        for person in self.allPersons {
            if person.name.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) != nil {
                self.filteredPersons.append(person)
            }
        }
        return true
    }
}
