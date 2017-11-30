//
//  TravelLocationsMapViewController.swift
//  Virtual Tourist
//
//  Created by Eric Cajuste on 11/29/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationsMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Lifecylce Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
        gesture.minimumPressDuration = 0.75
        mapView.addGestureRecognizer(gesture)
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
            print("adding annotation")
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coords = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coords
            
            mapView.addAnnotation(annotation)
        }
    }
    
    func regionToArray(regionToConvert region: MKCoordinateRegion) -> [Double] {
        return [region.center.latitude, region.center.longitude, region.span.latitudeDelta, region.span.longitudeDelta]
    }
}

