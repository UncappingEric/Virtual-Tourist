//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Eric Cajuste on 12/2/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import Foundation

class FlickrClient: NSObject {
    
    class func sharedInstance() -> FlickrClient {
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        return Singleton.sharedInstance
    }
    
    func fetchPhotosAt(_ latitude: Double, _ longitude: Double,_ page: Int, _ completion: @escaping (_ success: Bool, _ data: [[String: Any]]? ) -> Void) {
        
        let params = [ParameterKeys.APIKey  : Constants.APIKey,
                      ParameterKeys.Method  : Methods.SearchMethod,
                      ParameterKeys.Extras  : ParameterValues.MediumURL,
                      ParameterKeys.Format  : ParameterValues.ResponseFormat,
                      ParameterKeys.Lat     : String(describing: latitude),
                      ParameterKeys.Lon     : String(describing: longitude),
                      ParameterKeys.Page    : String(describing: page),
                      ParameterKeys.PerPage : "100",
                      ParameterKeys.NoJSONCallback : ParameterValues.DisableJSONCallback]
        
        var components = URLComponents()
        components.scheme = Constants.APIScheme
        components.host = Constants.APIHost
        components.path = Constants.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in params {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        let request = URLRequest(url: components.url!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            func displayError(_ errorString: String) {
                print(errorString)
                completion(false, nil)
                return
            }
            
            /* GUARD: Error-Checking for this request */
            guard (error == nil) else {
                displayError("There was an error with your request.")
                return
            }
            
            /* GUARD: Check for valid respone code for request */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode < 300 else {
                displayError("Unsuccessful request response retured.")
                return
            }
            
            // Deserial and parse the sent data
            let parsedData: [String: AnyObject]!
            do {
                parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
            } catch {
                displayError("Could not parse data")
                return
            }
            
            guard let photosDict = parsedData[ResponseKeys.Photos] as! [String: Any]?,
            let photoDict = photosDict[ResponseKeys.Photo] as! [[String: Any]]? else {
                displayError("Could not extract photos and/or photo dict")
                return
            }
            
            completion(true, photoDict)
        }
        
        task.resume()
    }
}
