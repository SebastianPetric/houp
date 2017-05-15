//
//  CreateNewPrivateGroupHandler.swift
//  Houp
//
//  Created by Sebastian on 30.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

private var errorMessage: String = ""
extension CreatePrivateGroupViewController{
    
    func handleRequest(){
        
        if let window = UIApplication.shared.keyWindow{
            if(!hasAnyErrors()){
                let timePicker = self.timeOfMeeting.subviews[1] as! UIDatePicker
                let privateGroup: PrivateGroup = PrivateGroup(pgid: nil, adminID: UserDefaults.standard.string(forKey: GetString.userID.rawValue), nameOfGroup: self.nameOfGroup.text!, location: self.locationOfMeeting.text!, dayOfMeeting: self.dayOfMeeting.text!, timeOfMeeting: timePicker.date, timeOfMeetingString: nil,secretID: Validation.shared.generateSecretGroupID(), threadIDs: nil, memberIDs: nil, dailyActivityIDs: nil, groupRequestIDs: nil, createdAt: nil, createdAtString: nil)
                
                if let error = DBConnection().createPrivateGroup(properties: privateGroup.getPropertyPackageCreatePrivateGroup()){
                        let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: GetString.errorNoButton.rawValue, firstHandler: nil, secondHandler: {(alert: UIAlertAction!) in  self.dismiss(animated: true, completion: nil)})
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        self.positiveResponse = CustomViews.shared.getPositiveResponse(title: GetString.successCreatePrivateGroup.rawValue, message: "GeheimID: \(privateGroup.secretID!)")
                        self.positiveResponse.frame = window.frame
                        self.positiveResponse.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
                        window.addSubview(positiveResponse)
                        
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                            self.positiveResponse.alpha = 1
                        }, completion: nil)
                    }
            }else{
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: errorMessage, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: GetString.errorNoButton.rawValue, firstHandler: nil, secondHandler: {(alert: UIAlertAction!) in  self.dismiss(animated: true, completion: nil)})
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func hasAnyErrors() -> Bool{
        if(self.nameOfGroup.text == "" || self.locationOfMeeting.text == "" || self.dayOfMeeting.text == ""){
            errorMessage = GetString.errorFillAllFields.rawValue
            return true
        }
        return false
    }
    
    
    func handleDismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.positiveResponse.alpha = 0
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }
    
    func handleErrorOccured(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.positiveResponse.alpha = 0
        }, completion: nil)
    }

    
    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }

    func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .UIKeyboardDidHide , object: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameOfGroup.endEditing(true)
        self.locationOfMeeting.endEditing(true)
        return false
    }
    func hideKeyboard(){
        self.nameOfGroup.endEditing(true)
        self.locationOfMeeting.endEditing(true)
    }
}
