//
//  TravelLocationsMapViewController.swift
//  Virtual Tourist
//
//  Created by Eric Cajuste on 11/29/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    // MARK: Lifecylce Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
        gesture.minimumPressDuration = 0.75
        mapView.addGestureRecognizer(gesture)
        
        setLastSavedRegion()
        displaySavedPins()
    }
    
    // MARK: Delegate functions
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        UserDefaults.standard.set(regionToArray(regionToConvert: mapView.region), forKey: "lastRegion")
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "PhotoAlbumController") as! PhotoAlbumController
        controller.annotation = view.annotation
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // MARK: Helper Functions
    
    @objc func addAnnotation(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coords = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coords
            
            mapView.addAnnotation(annotation)
            Location(lat: coords.latitude, lon: coords.longitude, context: fetchedResultsController.managedObjectContext)
            
            do {
                try (UIApplication.shared.delegate as! AppDelegate).stack.save()
            } catch {
                print("There was an issue saving context.")
            }
        }
    }
    
    func setLastSavedRegion() {
        if UserDefaults.standard.bool(forKey: "returning") {
            let regionData = UserDefaults.standard.array(forKey: "lastRegion") as! [Double]
            
            let center = CLLocationCoordinate2D(latitude: regionData[0], longitude: regionData[1])
            let span = MKCoordinateSpan(latitudeDelta: regionData[2], longitudeDelta: regionData[3])
            let region = MKCoordinateRegion(center: center, span: span)
            
            mapView.setRegion(region, animated: false)
        } else {
            UserDefaults.standard.set(regionToArray(regionToConvert: mapView.region), forKey: "lastRegion")
            UserDefaults.standard.set(true, forKey: "returning")
        }
    }
    
    func displaySavedPins() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        fr.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true),
                              NSSortDescriptor(key: "longitude", ascending: false)]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("error fetching")
        }
        
        if let objs = fetchedResultsController.fetchedObjects as! [Location]? {
            for location in objs {
                let coords = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coords
                mapView.addAnnotation(annotation)
            }
        } else {
            print("no items to fetch")
        }
    }
    
    func regionToArray(regionToConvert region: MKCoordinateRegion) -> [Double] {
        return [region.center.latitude, region.center.longitude, region.span.latitudeDelta, region.span.longitudeDelta]
    }
}

