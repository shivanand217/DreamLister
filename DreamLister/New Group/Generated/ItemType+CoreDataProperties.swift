//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by apple on 20/06/18.
//  Copyright © 2018 shiv. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
