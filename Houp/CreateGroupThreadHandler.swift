//
//  CreatePrivateGroupCommentHandler.swift
//  Houp
//
//  Created by Sebastian on 05.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit
 private var message: String = ""
 var groupID: String?
extension CreateGroupThreadController{
    
    func handleCreate(){
        if(hasAnyErrors()){
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: message, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }else{
            var threadsList: [Thread] = [Thread]()
            if let uID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
            if(self.isPublicSwitch.isOn){
            groupID = "0"
                let thread = Thread(rev: nil, tid: nil,originalID: nil, authorID: uID, authorUsername: nil, groupID: groupID, title: self.titleThread.text!, message: self.messageThread.text!, date: Date(), dateString: nil ,commentIDs: nil)
            threadsList.append(thread)
            }else if(self.sendToAllGroupsSwitch?.isOn)!{
                if let groupsList = self.privateGroupsList{
                    for group in groupsList{
                        let thread = Thread(rev: nil, tid: nil,originalID: nil, authorID: uID, authorUsername: nil, groupID: group.pgid, title: self.titleThread.text!, message: self.messageThread.text!, date: Date(), dateString: nil , commentIDs: nil)
                        threadsList.append(thread)
                    }
                }
            }else{
                if let groupsList = self.privateGroupsList{
                groupID = groupsList[(self.groupPicker?.selectedRow(inComponent: 0))!].pgid
                    let thread = Thread(rev: nil, tid: nil,originalID: nil, authorID: uID, authorUsername: nil, groupID: groupID, title: self.titleThread.text!, message: self.messageThread.text!, date: Date(), dateString: nil ,commentIDs: nil)
                threadsList.append(thread)
                }
            }
        }
            
            if let error = DBConnection.shared.createThreadWithProperties(properties: threadsList){
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                self.present(alert, animated: true, completion: nil)
            }else{
            if let window = UIApplication.shared.keyWindow{
                self.positiveResponse = CustomViews.shared.getPositiveResponse(title: "Super!", message: "Du hast dein Thema erfolgreich erstellt!")
                self.positiveResponse.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
                self.positiveResponse.frame = window.frame
                window.addSubview(positiveResponse)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.positiveResponse.alpha = 1
                }, completion: nil)
            }
        }
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
    
    func hasAnyErrors() -> Bool{
        if(self.titleThread.text! == "" || self.messageThread.text! == ""){
        message = GetString.errorFillAllFields.rawValue
        return true
        }else{
        return false
        }
    }
    
    func handleSendAllGroupsSwitch(){
        if(self.sendToAllGroupsSwitch?.isOn)!{
            self.groupPicker?.isUserInteractionEnabled = false
            self.groupPicker?.alpha = 0.4
        }else{
            self.groupPicker?.isUserInteractionEnabled = true
            self.groupPicker?.alpha = 1
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
