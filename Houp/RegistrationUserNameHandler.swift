//
//  RegistrationUserNameHandler.swift
//  Houp
//
//  Created by Sebastian on 21.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

private var errorMessage: String = ""

extension RegistrationUserNameController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func handleContinueButton(){
        if(hasAnyErrors()){
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: errorMessage, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }else{
            User.shared.username = self.usernameTextField.text
            if(self.profileImage.image != UIImage(named: GetString.defaultProfileImage.rawValue)){
            User.shared.profileImage = UIImageJPEGRepresentation(self.profileImage.image!, 0.1)
            }
            presentNextViewController()
        }
    }
    
    func presentNextViewController(){
    self.navigationController?.pushViewController(RegistrationNamePrenameController(), animated: true)
    }
    
    func hasAnyErrors() -> Bool{
       
        if(self.usernameTextField.text == ""){
            errorMessage = GetString.errorFillAllFields.rawValue
            return true
        }else if(DBConnection.shared.checkIfUsernameAlreadyExists(username: self.usernameTextField.text!)){
        errorMessage = GetString.errorUsernameAlreadyInUse.rawValue
        return true
        }else if (self.profileImage.image == UIImage(named: GetString.defaultProfileImage.rawValue)){
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWantProfileImage.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: GetString.errorNoButton.rawValue, firstHandler: {action in self.handleGetProfileImage()}, secondHandler: {action in self.presentNextViewController()})
            self.present(alert, animated: true, completion: nil)
        }
        return false
    }
    
    
    func handleGetProfileImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        print(info)
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
        selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
        selectedImageFromPicker = originalImage
        }
        picker.dismiss(animated: true) { 
            if let selected = selectedImageFromPicker{
            self.profileImage.image = selected
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
