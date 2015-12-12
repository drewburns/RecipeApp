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
    
    @IBOutlet weak var descText: UITextView!
    
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    @IBOutlet weak var ingredText: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var instructText: UITextView!
    
    @IBOutlet weak var chooseButton: UIButton!
   
    @IBOutlet weak var selectedImage: UIImageView!
    
    var selected_image: UIImage!
    var keyboardHasShown = false
    
    
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
            self.performSegueWithIdentifier("goBack", sender: self)
        } else {
            let alert = UIAlertController(
                title: "Did not save",
                message: "Enter all fields" ,
                preferredStyle: UIAlertControllerStyle.Alert
            )
            alert.addAction(UIAlertAction(
                title: "Okay",
                style: UIAlertActionStyle.Default,
                handler: nil
            ))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if keyboardHasShown == false {
            if let userInfo = sender.userInfo {
                if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
                    scrollView.contentSize.height += keyboardHeight
                    keyboardHasShown = true
                    UIView.animateWithDuration(0.25, animations: { () -> Void in
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
    }
    
//    func keyboardWillHide(sender: NSNotification) {
//        if let userInfo = sender.userInfo {
//            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
//                scrollView.contentSize.height -= keyboardHeight
//                UIView.animateWithDuration(0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
//            }
//        }
//    }

    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        descText.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        descText.layer.borderWidth = 1.0
        descText.layer.cornerRadius = 5
        ingredText.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        ingredText.layer.borderWidth = 1.0
        ingredText.layer.cornerRadius = 5
        instructText.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        instructText.layer.borderWidth = 1.0
        instructText.layer.cornerRadius = 5
        
    }
}
