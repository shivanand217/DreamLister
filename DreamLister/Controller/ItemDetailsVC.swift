//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by apple on 20/06/18.
//  Copyright © 2018 shiv. All rights reserved.

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    // hold our stores
    var stores = [Store]()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.done, target: nil, action: nil)
        }
        
        // Delegates and data source
        storePicker.delegate = self
        storePicker.dataSource = self
        
        // generateStores()
        // stores.removeAll()
        getStores()
    }
    
    func generateStores() {
        
        // create entity for Store
        let store1 = Store(context: context)
        store1.name = "Best Store"
        let store2 = Store(context: context)
        store2.name = "Tesla Dealership"
        let store3 = Store(context: context)
        store3.name = "Shri Dealers"
        let store4 = Store(context: context)
        store4.name = "California Dealers"
        let store5 = Store(context: context)
        store5.name = "Jindal Stores"
        let store6 = Store(context: context)
        store6.name = "Tata Stores"
        
        // Save to context
        appDelegate.saveContext()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func getStores() {
        // create fetchRequest for stores
        let fetchRequest : NSFetchRequest<Store> = Store.fetchRequest()
        // some sort descriptor
        let nameSort = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [nameSort]
        
        _ = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
            
        } catch {
            
            let error = error as NSError
            print("\(error)")
        }
    }
    
    // save the new item details
    @IBAction func saveItemPressed(_ sender: UIButton) {
        
        //print("save item")
        let item = Item(context: context)
        
        if let title = titleField.text {
            item.title = title
        }
        if let price = priceField.text {
            //item.price = Double(price)!
            item.price = (price as NSString).doubleValue
        }
        if let details = detailsField.text {
            item.details = details
        }
        
        // which store has been selected
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        appDelegate.saveContext()
        
        navigationController?.popViewController(animated: true)
    }

}
