//
//  Request.swift
//  RecipeApp
//
//  Created by Andrew Burns on 12/5/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import Foundation
import UIKit
typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
    let baseURL = "https://givemerecipes.herokuapp.com/recipes.json"
    
    
    
    func getRecipes(onCompletion: (JSON) -> ()) -> () {
        let route = baseURL
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json:JSON = JSON(data: data!)
            onCompletion(json, error)
        })
        task.resume()
    }
    
//    func makeHTTPPostRequest() {
//        
//    }

    
    func getImage(url: String) -> UIImage {
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        let image = UIImage(data: data!)
        return image!
    }
    
    
}

