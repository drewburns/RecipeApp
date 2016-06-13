//
//  RecipesTableViewController.swift
//  RecipeApp
//
//  Created by Andrew Burns on 12/5/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import UIKit
import Foundation

class RecipesTableViewController: UITableViewController {
    var recipes = [Recipe]()
    var search = "/recipes"
    var userEmail: String?
    
    @IBOutlet weak var settingButtonItem: UIBarButtonItem!
    func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl!)
    }
    @IBAction func refresh(sender: AnyObject) {
        recipes.removeAll()
        let request = RestApiManager.sharedInstance
        request.getRecipes(search) { (json) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let arrayOfRecipes = self.buildRecipes(json["recipes"])
                self.recipes = arrayOfRecipes
                self.tableView.reloadData()
                sender.endRefreshing()
                
            })
        }
        
    }
    
    func buildRecipes(newrecipes: JSON) -> [Recipe] {
        var createdRecipes = [Recipe]()
        for var index = 0; index < newrecipes.count; ++index {
            let recipe = newrecipes[index]
            let name = String(recipe["recipe"]["name"]) ?? "None"
            let description = String(recipe["recipe"]["description"]) ?? "None"
            let ingredients = String(recipe["recipe"]["ingredients"]) ?? "None"
            let instructions = String(recipe["recipe"]["instructions"]) ?? "None"
            let imageUrl = String(recipe["recipe"]["picture"]["picture"]["url"]) ?? "None"
            let userId = String(recipe["recipe"]["user"]["id"])
            let userEmail = String(recipe["recipe"]["user"]["email"])
            let userAccessKey = String(recipe["recipe"]["user"]["api_keys"]["api_key"]["access_token"]) ?? "None"
            let createdUser = User(Email: userEmail, Id: Int(userId)!, Key: userAccessKey)
            print(name)
            let image = RestApiManager().getImage(imageUrl)
            let finalRecipe = Recipe(Name: name, Description: description, Ingredients: ingredients, Instructions: instructions, ImageUrl: imageUrl, Image: image, TheUser: createdUser)
            createdRecipes.append(finalRecipe)
        }

        return createdRecipes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 {
            tableView.estimatedRowHeight = tableView.rowHeight
            tableView.rowHeight = UITableViewAutomaticDimension
        }
        refresh()
        if search == "/recipes" {
            title = "Recipes"
        } else {
            title = userEmail
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return recipes.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recipe", forIndexPath: indexPath) as! RecipeTableViewCell
        cell.recipe = recipes[indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let rvc = segue.destinationViewController as? RecipeViewController {
            if let recipeCell = sender as? RecipeTableViewCell {
                rvc.recipe = recipeCell.recipe
            }
        }
    }
    @IBAction func goBack(segue: UIStoryboardSegue) {
        refresh()
    }
    
    
    @IBAction func userOptions(sender: AnyObject) {
        var alert = UIAlertController(
            title: "User Options",
            message: "Choose an option",
            preferredStyle: UIAlertControllerStyle.ActionSheet
        )
        
        alert.addAction(UIAlertAction(
            title: "See My Recipes",
            style: UIAlertActionStyle.Default,
            handler: { (UIAlertAction) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let id = String(NSUserDefaults.standardUserDefaults().stringForKey("currentUserId")!)
                self.search = "/users/\(id)"
                self.refresh()
                self.title = "My Recipes"
            })
            }
        ))
        alert.addAction(UIAlertAction(
            title: "See All Recipes",
            style: UIAlertActionStyle.Default,
            handler: { (UIAlertAction) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.search = "/recipes"
                    self.refresh()
                    self.title = "Recipes"
                })
            }
            ))
        alert.addAction(UIAlertAction(
            title: "Logout",
            style: UIAlertActionStyle.Destructive,
            handler: { (UIAlertAction) -> Void in
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(nil, forKey: "currentUserId")
                defaults.setObject(nil, forKey: "currentUserKey")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.performSegueWithIdentifier("logOut", sender: self)
                })
            }
        ))
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler: { (UIAlertAction) -> Void in
                
            }
        ))
        presentViewController(alert, animated: true, completion: nil)
        print(search)
    }


    
}
