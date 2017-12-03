//
//  CoreDataViewController.swift
//  Virtual Tourist
//
//  Created by Eric Cajuste on 12/2/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: Properties
    
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            // Whenever the frc changes, we execute the search and
            // reload the table
            fetchedResultsController?.delegate = self
            executeSearch()
            updateViewAfterChange()
        }
    }
    
    // MARK: Fetch Function
    
    func executeSearch() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController!)")
            }
        }
    }
    
    // MARK: Abstract Methods
    func updateViewAfterChange() {
        fatalError("This method MUST be implemented by a subclass of CoreDataViewController")
    }
    
    // MARK: Delegate Functions
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateViewAfterChange()
    }
}
