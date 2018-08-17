//
//  DetailViewController.swift
//  Homepwner
//
//  Created by CampusUser on 2/28/18.
//  Copyright © 2018 Diego Franchi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var takePicture: UIBarButtonItem!
    
    var flexibleSpaceBarButton: UIBarButtonItem!
    var removePictureBarButton: UIBarButtonItem!
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        
        // IF the device has a camera, take a picture; otherwise,
        // just pick from photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        
        // Place image picker on screen
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        // Get picked image from info dictionary
        // MARK: - Bronze Challenge: Editing an Image
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Store the image in the ImageStore for the item's key
        imageStore.setImage(image, forKey: item.itemKey)
        
        // Put that image on the screen in the image view
        imageView.image = image
        
        // Take image picker off the screen -
        // you must call this mismiss method
        dismiss(animated: true, completion: nil)
        
        //Silver Challenge: Removing an Image
        removePictureBarButton.isEnabled = true
    }
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    var imageStore: ImageStore!
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        // MARK: - Bronze Challenge: Displaying a Number Pad
        valueField.keyboardType = .numberPad
        // MARK: - Silver Challenge: Removing an Image
        flexibleSpaceBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        removePictureBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removePicture(_:)))
        //set bar button items
        for subView in self.view.subviews {
            if let toolbar = subView as? UIToolbar {
                var toolbarItems = toolbar.items
                toolbarItems?.append(flexibleSpaceBarButton)
                toolbarItems?.append(removePictureBarButton)
                toolbar.setItems(toolbarItems, animated: true)
                break
            }
        }
    }
    
    @IBAction func removePicture(_ sender: UIBarButtonItem) {
        imageStore.deleteImage(forKey: item.itemKey)
        imageView.image = nil
        removePictureBarButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = item.name
        serialField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        // Get the item key
        let key = item.itemKey
        
        // If there is an associated image with the item
        // display it on the image view
        let imageToDisplay = imageStore.image(forKey: key)
        imageView.image = imageToDisplay
        
        //Silver Challenge: Removing an Image
        removePictureBarButton.isEnabled = imageView.image != nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Clear first responder
        view.endEditing(true)
        // "Save" changes to item
        item.name = nameField.text ?? ""
        item.serialNumber = serialField.text
        if let valueText = valueField.text,
            let value = numberFormatter.number(from: valueText) {
            item.valueInDollars = value.intValue
        } else {
            item.valueInDollars = 0
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - Silver Challenge: A Custom UITextField
class CustomTextField: UITextField {
    override func becomeFirstResponder() -> Bool {
        borderStyle = .bezel
        return super.becomeFirstResponder()
    }
    override func resignFirstResponder() -> Bool {
        borderStyle = .roundedRect
        return super.resignFirstResponder()
    }
    
//MARK: - Gold Challenge: Pushing More View Controllers
    class DateCreatedViewController: UIViewController {
    }
}
