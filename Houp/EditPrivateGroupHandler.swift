//
//  EditPrivateGroupHandler.swift
//  Houp
//
//  Created by Sebastian on 23.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension EditPrivateGroup{

    func handleRequest(){
        if let window = UIApplication.shared.keyWindow{
            let timePicker = self.timeOfMeeting.subviews[1] as! UIDatePicker
            
            if (self.nameOfGroup.text != ""){
                self.privateGroup?.nameOfGroup = self.nameOfGroup.text
            }
            if (self.dayOfMeeting.text != ""){
                self.privateGroup?.dayOfMeeting = self.dayOfMeeting.text
            }
            if (self.locationOfMeeting.text != ""){
                self.privateGroup?.location = self.locationOfMeeting.text
            }
            self.privateGroup?.timeOfMeeting = timePicker.date
            
            
            if let error = DBConnection().updatePrivateGroup(properties: self.privateGroup!){
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: GetString.errorNoButton.rawValue, firstHandler: nil, secondHandler: {(alert: UIAlertAction!) in  self.dismiss(animated: true, completion: nil)})
                self.present(alert, animated: true, completion: nil)
            }else{
                self.positiveResponse = CustomViews.shared.getPositiveResponse(title: GetString.successCreatePrivateGroup.rawValue, message: "Gruppe erfolgreich geupdated!")
                self.positiveResponse.frame = window.frame
                self.positiveResponse.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
                window.addSubview(positiveResponse)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.positiveResponse.alpha = 1
                }, completion: nil)
            }
        }
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
}
