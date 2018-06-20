//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by apple on 20/06/18.
//  Copyright © 2018 shiv. All rights reserved.
//
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        // assign the created timestamp when an object is created
        self.created = NSDate()
    }
}
