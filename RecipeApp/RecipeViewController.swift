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
    
    
    
    var recipe: Recipe!
    
    override func viewDidLoad() {
        nameLabel.text = recipe.name
        descriptionLabel.text = recipe.description
        recipeImage.image = recipe.image
        ingredientsLabel.text = recipe.ingredients
        instructionsLabel.text = recipe.instructions
    }
}
