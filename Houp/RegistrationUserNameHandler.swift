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
            let alert = UIAlertController(title: "Upps!", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            UserRegistration.shared.username = self.usernameTextField.text
            
            if(self.profileImage.image == UIImage(named: "profile_default")){
            UserRegistration.shared.profileImage = UIImageJPEGRepresentation(self.profileImage.image!, 0.1)
            }
            
            
            
            presentNextViewController()
        }
    }
    
    func presentNextViewController(){
    self.navigationController?.pushViewController(RegistrationNamePrenameController(), animated: true)
    }
    
    func hasAnyErrors() -> Bool{
        if(self.usernameTextField.text == ""){
            errorMessage = "Bitte alle Felder ausfüllen!"
            return true
        }else if(DBConnection.shared.checkIfUsernameOrEmailAlreadyExists(view: DBConnection.shared.viewByUsername! ,usernameOrEmail: self.usernameTextField.text!)){
        errorMessage = "Suche dir bitte einen anderen Nutzernamen. Dieser wird bereits verwendet."
        return true
        }else if (self.profileImage.image == UIImage(named: "profile_default")){
            let alert = UIAlertController(title: "Upps!", message: "Willst du kein Profilbild machen?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ja", style: .default, handler: {action in self.handleGetProfileImage()}))
            alert.addAction(UIAlertAction.init(title: "Nein", style: .default, handler: {action in self.presentNextViewController()}))
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
