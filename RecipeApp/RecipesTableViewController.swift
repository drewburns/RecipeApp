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
    var recipes = [[Recipe]]()
    
    func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl!)
    }
    @IBAction func refresh(sender: AnyObject) {
        recipes.removeAll()
        let request = RestApiManager.sharedInstance
        request.getRecipes { (json) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let arrayOfRecipes = self.buildRecipes(json["recipes"])
                self.recipes.insert(arrayOfRecipes, atIndex: 0)
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
            let image = RestApiManager().getImage(imageUrl)
            let finalRecipe = Recipe(Name: name, Description: description, Ingredients: ingredients, Instructions: instructions, ImageUrl: imageUrl, Image: image)
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
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return recipes.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes[section].count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recipe", forIndexPath: indexPath) as! RecipeTableViewCell
        cell.recipe = recipes[indexPath.section][indexPath.row]
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


    
}
