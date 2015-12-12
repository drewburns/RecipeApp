//
//  LoginViewController.swift
//  RecipeApp
//
//  Created by Andrew Burns on 12/12/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        emailField.text = ""
        passwordField.text = ""
        let defaults = NSUserDefaults.standardUserDefaults()
        //                defaults.setObject(nil, forKey: "currentUserId")
        //                defaults.setObject(nil, forKey: "currentUserKey")
        //        print(defaults.stringForKey("currentUserId"))
        //        print(defaults.stringForKey("currentUserKey"))
        if defaults.stringForKey("currentUserId") != nil {
            print("already existed")
            self.performSegueWithIdentifier("userHasLoggedIn", sender: self)
        }
        
    }
    
    @IBAction func login(sender: AnyObject) {
        if emailField.text != "" && passwordField.text != ""{
            let defaults = NSUserDefaults.standardUserDefaults()
            print("made new")
            let request = NSMutableURLRequest(URL: NSURL(string: "https://givemerecipes.herokuapp.com/api/sessions")!)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let params = ["email": emailField.text!, "password": passwordField.text!]
            
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions(rawValue: 0))
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
                    //                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    let data = (JSON(data: data!))
                    if data != nil {
                        let id = Int(String(data["user"]["id"]))
                        let user = User(Email: String(data["user"]["email"]), Id: id! , Key: String(data["user"]["key"]))
                        defaults.setObject(user.id, forKey: "currentUserId")
                        defaults.setObject(user.key, forKey: "currentUserKey")
                    }
                })
                task.resume()
                self.performSegueWithIdentifier("userHasLoggedIn", sender: self)
                
            } catch {
                
            }
        } else {
            print("Try again")
        }

    }
    
    @IBAction func logOut(segue: UIStoryboardSegue) {

    }
}
