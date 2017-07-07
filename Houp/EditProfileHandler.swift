//
//  EditProfileHandler.swift
//  Houp
//
//  Created by Sebastian on 07.07.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension EditProfile: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func handleGetProfileImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func handleEdit(){
        checkWhichFieldsShouldBeUpdated()
        
        if let error = DBConnection.shared.editUser(user: User.shared){
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }else{
            if let window = UIApplication.shared.keyWindow{
                self.positiveResponse = CustomViews.shared.getPositiveResponse(title: "Super!", message: "Du hast dein Profil erfolgreich bearbeitet!")
                self.positiveResponse.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
                self.positiveResponse.frame = window.frame
                window.addSubview(positiveResponse)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.positiveResponse.alpha = 1
                }, completion: nil)
            }
        }
    }
    
    func checkWhichFieldsShouldBeUpdated(){
        if(self.nameTextField.text != ""){
            User.shared.name = self.nameTextField.text
        }
        if(self.prenameTextField.text != ""){
            User.shared.prename = self.prenameTextField.text
        }
        if(self.gender.selectedSegmentIndex != -1){
            User.shared.gender = self.gender.selectedSegmentIndex
        }
        let picker = self.birthdayPicker.subviews[1] as! UIDatePicker
        
        if(picker.date.getDatePart() != Date().getDatePart()){
            User.shared.birthday = picker.date
        }else{
            User.shared.birthday = nil
        }
        if(self.profileImage.image != UIImage(named: GetString.defaultProfileImage.rawValue)){
            User.shared.profileImage = UIImageJPEGRepresentation(self.profileImage.image!, 0.1)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
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

    
    func handleDismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.positiveResponse.alpha = 0
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }
    
    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
