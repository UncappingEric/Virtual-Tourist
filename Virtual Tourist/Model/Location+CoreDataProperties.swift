//
//  Location+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Eric Cajuste on 11/30/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var searched: Bool
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for photos
extension Location {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}
