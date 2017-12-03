//
//  PhotoAlbumController.swift
//  Virtual Tourist
//
//  Created by Eric Cajuste on 11/30/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PhotoAlbumController: CoreDataViewController, UICollectionViewDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var annotation: MKAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.addAnnotation(annotation)
        let center = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
        
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
    
    @IBAction func addNewCollection(_ sender: Any) {
        
    }
}
