//
//  Car+CoreDataProperties.swift
//  MyCars
//
//  Created by Игорь Михайлович Ракитянский on 22.07.16.
//  Copyright © 2016 Ivan Akulov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Car {

    @NSManaged var mark: String?
    @NSManaged var model: String?
    @NSManaged var myChoice: NSNumber?
    @NSManaged var rating: NSNumber?
    @NSManaged var timesDriven: NSNumber?
    @NSManaged var lastStarted: NSDate?
    @NSManaged var imageData: NSData?
    @NSManaged var tintColor: NSObject?

}
