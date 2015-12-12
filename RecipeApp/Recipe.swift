//
//  Recipe.swift
//  RecipeApp
//
//  Created by Andrew Burns on 12/5/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import Foundation
import UIKit

class Recipe {
    
    var name: String?
    var description: String?
    var ingredients: String?
    var instructions: String?
    var imageUrl: String?
    var image: UIImage?
    var user: User
    
    init(Name: String, Description: String, Ingredients: String, Instructions: String, ImageUrl: String , Image: UIImage, TheUser: User) {
        name = Name
        description = Description
        ingredients = Ingredients
        instructions = Instructions
        imageUrl = ImageUrl
        image = Image
        user = TheUser
    }
}