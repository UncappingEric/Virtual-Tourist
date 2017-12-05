//
//  FlickrConstants.swift
//  Virtual Tourist
//
//  Created by Eric Cajuste on 12/2/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import Foundation

extension FlickrClient {
    
    struct Constants {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
        
        static let APIKey = "64c19143afce46219b87cdd6233769ac"
        static let SearchBBoxHalfWidth = 1.0
        static let SearchBBoxHalfHeight = 1.0
    }
    
    struct Methods {
        static let SearchMethod = "flickr.photos.search"
    }
    
    struct ParameterKeys {
        static let APIKey = "api_key"
        static let Method = "method"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let BoundingBox = "bbox"
        static let Lat = "lat"
        static let Lon = "lon"
        static let PerPage = "per_page"
        static let Page = "page"
    }
    
    struct ParameterValues {
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1"
        static let MediumURL = "url_m"
    }
    
    struct ResponseKeys {
        static let Photos = "photos"
        static let Photo = "photo"
    }
}
