//
//  CreatePrivateGroupCommentHandler.swift
//  Houp
//
//  Created by Sebastian on 05.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension CreateGroupThreadController{
    
    func handleCreate(){
        if let window = UIApplication.shared.keyWindow{
            self.positiveResponse = CustomViews.shared.getPositiveResponse(title: "Super!", message: "Thena erfolgreich erstelltdddwdw!")
            self.positiveResponse.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            self.positiveResponse.frame = window.frame
            window.addSubview(positiveResponse)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.positiveResponse.alpha = 1
            }, completion: nil)
        }
    }
    
    func handlePublicSwitch(){
        if(!self.isPublicSwitch.isOn){
            self.privateContainer.isHidden = false
            self.heightOfPrivateContainer?.isActive = false
            self.heightOfPrivateContainer?.constant = 100
            self.heightOfPrivateContainer?.isActive = true
            
        }else{
            self.privateContainer.isHidden = true
            self.heightOfPrivateContainer?.isActive = false
            self.heightOfPrivateContainer?.constant = 0
            self.heightOfPrivateContainer?.isActive = true
        }
    }
    
    func handleSendAllGroupsSwitch(){
        let picker = privateContainer.subviews[0] as! UIPickerView
        let sendToAllGroupsSwitch = privateContainer.subviews[2] as! UISwitch
        if(sendToAllGroupsSwitch.isOn){
            picker.isUserInteractionEnabled = false
            picker.alpha = 0.4
        }else{
            picker.isUserInteractionEnabled = true
            picker.alpha = 1
        }
    }
    
    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func handleDismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.positiveResponse.alpha = 0
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
        self.view.endEditing(true)
            return false
        }
        return true
    }
    
    func hideKeyboard(){
        self.view.endEditing(true)
    }
}
