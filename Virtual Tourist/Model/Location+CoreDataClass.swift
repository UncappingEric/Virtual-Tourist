//
//  Location+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Eric Cajuste on 11/30/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Location)
public class Location: NSManagedObject {

    convenience init(lat: Double, lon: Double, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Location", in: context) {
            self.init(entity: ent, insertInto: context)
            self.latitude = lat
            self.longitude = lon
            self.searched = false
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
