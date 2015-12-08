//
//  NewRecipeViewController.swift
//  RecipeApp
//
//  Created by Andrew Burns on 12/6/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import Foundation
import UIKit

class NewRecipeViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var descText: UITextField!
    @IBOutlet weak var ingredText: UITextField!
    @IBOutlet weak var instructText: UITextField!
    @IBOutlet weak var chooseButton: UIButton!
   
    @IBOutlet weak var selectedImage: UIImageView!
    
    var selected_image: UIImage!
    
    
    @IBAction func getImage(sender: UIButton) {
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .PhotoLibrary
        self.presentViewController(photoPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        selectedImage.image = image as UIImage!
        selected_image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        chooseButton.hidden = true
        selectedImage.hidden = false
        
        
    }
    
    @IBAction func Submit(sender: UIButton) {
        if nameText.text != "" && descText.text != "" && ingredText.text != "" && instructText.text != "" && selected_image != nil {
            
        RestApiManager().makeHTTPPostRequest(selected_image, name: nameText.text!, description: descText.text!, ingredients: ingredText.text!,  instructions: instructText.text!)       
        }
    }
}
