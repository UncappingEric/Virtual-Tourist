//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Eric Cajuste on 11/30/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var data: NSData?
    @NSManaged public var location: Location?

}
