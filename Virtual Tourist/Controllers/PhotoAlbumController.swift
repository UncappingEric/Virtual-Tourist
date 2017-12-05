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
import CoreData

class PhotoAlbumController: CoreDataViewController, UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate {
    
    @IBOutlet weak var collectionButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collection: UICollectionView!
    
    var annotation: MKAnnotation!
    var location: Location!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.addAnnotation(annotation)
        let center = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
        
        if location.photos?.count == 0 {
            getNewCollection()
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = location.photos?.allObjects[indexPath.row] as! Photo
        location.removeFromPhotos(photo)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (location.photos?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = location.photos?.allObjects[indexPath.row] as! Photo
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        DispatchQueue.main.async {
            cell.image.image = UIImage(data: photo.data! as Data)
            cell.image.contentMode = .scaleToFill
        }
        return cell
    }
    
    func getNewCollection() {
        enableUI(false)
        
        //fetch photos at coordinates
        let coord = annotation.coordinate
        FlickrClient.sharedInstance().fetchPhotosAt(coord.latitude, coord.longitude, { (success, photos) in
            func showAlert(_ errorString: String = "Error with network request."){
                let alert = UIAlertController(title: "Data Error", message:
                    errorString, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            guard success else {
                showAlert()
                return
            }
            
            if photos?.count == 0 {
                showAlert("No photos available.")
                return
            }
            
            self.storePhotos(photos!)
            DispatchQueue.main.async {
                self.enableUI(true)
            }
        })
    }
    
    @IBAction func addNewCollection(_ sender: Any) {
        location.removeFromPhotos(location.photos!)
        collection.reloadData()
        getNewCollection()
    }
    
    func storePhotos(_ photosDictionary: [[String: Any?]]) {
        for photo in photosDictionary {
            let urlString = photo[FlickrClient.ParameterValues.MediumURL] as! String?
            
            let url = URL(string: urlString!)
            
            if let imageData = try? Data(contentsOf: url!) {
                let p = Photo(data: imageData as NSData, location: location, context: (fetchedResultsController?.managedObjectContext)!)
                location.addToPhotos(p)
            } else {
                print("Image does not exist at \(urlString!)")
            }
        }
        
        DispatchQueue.main.async {
            (UIApplication.shared.delegate as! AppDelegate).stack.save()
            self.collection.reloadData()
        }
    }
    
    override func updateViewAfterChange() {
        if let col = collection {
            col.reloadData()
        }
    }
    
    func enableUI(_ enable: Bool) {
        collectionButton.isEnabled = enable
    }
}
