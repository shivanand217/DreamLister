//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by shiv on 20/06/18.
//  Copyright © 2018 shiv. All rights reserved.

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,
        UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumbImg: UIImageView!
    
    // Hold our stores
    var stores = [Store]()
    // For editing existing item
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
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
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        /** Uncomment this to generate intial test data. **/
        //generateStores()
        getStores()
        
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    func generateStores() {
        
        // Create entity for Store
        let store1 = Store(context: context)
        store1.name = "Mac Stores"
        let store2 = Store(context: context)
        store2.name = "Tesla Dealership"
        let store3 = Store(context: context)
        store3.name = "Toyota Dealers"
        let store4 = Store(context: context)
        store4.name = "California Dealers"
        let store5 = Store(context: context)
        store5.name = "Amazon"
        let store6 = Store(context: context)
        store6.name = "Wallmart"
        let store7 = Store(context: context)
        store7.name = "Flipkart"
        let store8 = Store(context: context)
        store8.name = "Dream buy stores"
        
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
        // update when selected
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
        
        var item: Item!
        // have to create image entity first because it is an entity in our database
        let picture = Image(context: context)
        picture.image = thumbImg.image
        
        if itemToEdit == nil {
            // this is a new item
            item = Item(context: context)
        } else {
            // this is an existing item
            item = itemToEdit
        }
        
        item.toImage = picture
        
        if let title = titleField.text {
            item.title = title
        }
        if let price = priceField.text {
            // item.price = Double(price)!
            item.price = (price as NSString).doubleValue
        }
        if let details = detailsField.text {
            item.details = details
        }
        
        // Which store has been selected
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        appDelegate.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
    
    // item exists already
    func loadItemData() {
        
        // Autofill the previous details
        if let item = itemToEdit {
            
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            thumbImg.image = item.toImage?.image as? UIImage
            
            // We also have to SetUp existing store
            if let store = item.toStore {
                
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        
                        storePicker.selectRow(index, inComponent: 0, animated: true)
                        break
                    } else {
                        index+=1
                    }
                    
                } while (index < stores.count)
            }
        }
    }
    
    @IBAction func deleteItemPressed(_ sender: UIBarButtonItem) {
        
        // If this is an existing item in our datastore
        if itemToEdit != nil {
            
            let refreshAlert = UIAlertController(title: "Alert!!", message: "Item data will be deleted, Do you want to delete it? 😰", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                context.delete(self.itemToEdit!)
                appDelegate.saveContext()
                self.navigationController?.popViewController(animated: true)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                // do nothing
                self.navigationController?.popViewController(animated: true)
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
            
        } else {
            
            let alert = UIAlertController(title: "Sorry", message: "The item you want to delete is not is in the datastore 🙁.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        // loads the image
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImg.image = img
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

}
