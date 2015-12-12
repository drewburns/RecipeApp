//
//  RecipeViewController.swift
//  RecipeApp
//
//  Created by Andrew Burns on 12/5/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!


    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var userButton: UIButton!
    
    
    
    var recipe: Recipe!
    
    override func viewDidLoad() {
        title = recipe.name
        nameLabel.text = recipe.name
        descriptionLabel.text = recipe.description
        recipeImage.image = recipe.image
        ingredientsLabel.text = recipe.ingredients
        instructionsLabel.text = recipe.instructions
        instructionsLabel.sizeToFit()
        userButton.setTitle(recipe.user.email, forState: .Normal)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Made it to prepare")
        if let rtvc = segue.destinationViewController as? RecipesTableViewController {
                rtvc.search = "/users/\(String(recipe.user.id))"
                rtvc.userEmail = recipe.user.email
        }
    }
    
}
