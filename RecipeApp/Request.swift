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
    
    let baseURL = "https://givemerecipes.herokuapp.com/api"
//       let baseURL = "http://localhost:3000/api"
    
    func getRecipes(search: String , onCompletion: (JSON) -> ()) -> () {
        print("Made it to get recipes")
        let route = baseURL + search
        print(route)
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
    
    func makeHTTPPostRequest(image: UIImage, name: String, description: String , ingredients: String, instructions: String) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://givemerecipes.herokuapp.com/recipes")!)
//        https://givemerecipes.herokuapp.com
//        http://localhost:3000
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let key = NSUserDefaults.standardUserDefaults().stringForKey("currentUserKey")
        request.setValue("Token token="+"\(key)", forHTTPHeaderField: "Authorization")
        
        let imageData = UIImageJPEGRepresentation(image, 0.9)
        let base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) // encode the image
        let userId = NSUserDefaults.standardUserDefaults().stringForKey("currentUserId")
        let params = ["file_data": base64String, "user_id": userId! , "name": name, "description": description, "ingredients": ingredients , "instructions": instructions]
        do {
           request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions(rawValue: 0))
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
                var strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(response)
                // process the response
            })
            
            task.resume()
        } catch {
            
        }
////        
//        let request = NSMutableURLRequest(URL: NSURL(string: "https://givemerecipes.herokuapp.com/api/recipes")!)
//        request.HTTPMethod = "POST"
//        let postString = "name=Chicken&description=there+is+lots+of+fun+stuff"
//        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//
//            if error != nil {
//                print("error=\(error)")
//                return
//            }
//
//            print("response = \(response)")
//
//            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//            print("responseString = \(responseString)")
//        }
//        task.resume()
    }

    
    func getImage(url: String) -> UIImage {
        if url != "null" {
            let data = NSData(contentsOfURL: NSURL(string: url)!)
            let image = UIImage(data: data!)
            return image!
        } else {
            let image = UIImage(named: "question")!
            return image
        }
    }
    
    
}

