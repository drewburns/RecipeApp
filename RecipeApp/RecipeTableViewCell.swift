//
//  RecipeTableViewCell.swift
//  RecipeApp
//
//  Created by Andrew Burns on 12/5/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import Foundation
import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeDescription: UILabel!
    
    var recipe: Recipe! {
        didSet{
            nameLabel.text = recipe.name
            recipeImage.image = recipe.image
            recipeDescription.text = recipe.description
        }
    }
    

    

    
}
