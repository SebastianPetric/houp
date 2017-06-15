//
//  EditActivityHandler.swift
//  Houp
//
//  Created by Sebastian on 15.06.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension EditActivity{

    func checkIfFieldsAreFilled(){
        if(self.activityText.text! != ""){
            self.continueButton.layer.borderColor = UIColor().getSecondColor().cgColor
            self.continueButton.setTitleColor(UIColor().getSecondColor(), for: .normal)
        }else{
            self.continueButton.layer.borderColor = UIColor().getLightGreyColor().cgColor
            self.continueButton.setTitleColor(UIColor().getLightGreyColor(), for: .normal)
        }
    }
    
    func editActivity(){
        if(self.continueButton.layer.borderColor == UIColor().getSecondColor().cgColor){
            if (hasAnyErrors()){
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithDB.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                self.present(alert, animated: true, completion: nil)
            }else{
//                TimerObject.shared.invalidateTimer()
//                TimerObject.shared.invalidateDelayTimer()
//                TimerObject.shared.setUpTimer(date: getEditedActivity().dateObject!)
//                TimerObject.shared.tryLaterAgain = false
                if let window = UIApplication.shared.keyWindow{
                    self.positiveResponse = CustomViews.shared.getPositiveResponse(title: "Super!", message: "Du hast die Aktivität erfolgreich bearbeitet!")
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
    
    func getEditedActivity() -> Activity{
        let timePicker = self.timeOfActivity.subviews[1] as! UIDatePicker
        
        let tempActivity = Activity(rev: nil, aid: self.activity?.aid, authorID: nil, authorUsername: nil, groupID: nil, activity: self.activityText.text, activityText: nil, locationOfActivity: self.locationText.text, isInProcess: nil, status: nil, wellBeingState: nil, wellBeingText: nil, addictionState: nil, addictionText: nil, dateObject: self.activity?.dateObject, timeObject: timePicker.date, dateString: nil, timeString: nil, commentIDs: nil, likeIDs: nil)
        
        return tempActivity
    }
    
    
    func hasAnyErrors() -> Bool{
        
        if DBConnection.shared.editActivity(activity: getEditedActivity()) != nil{
            return true
        }else{
            let dateOfActivity = Date().getDateAndTimeForActity(date: getEditedActivity().dateObject!, time: getEditedActivity().timeObject!)
            CalendarObject.shared.setUpEventInCalendar(activity: getEditedActivity().activity!, locationOfActivity: getEditedActivity().locationOfActivity, dateOfActivity: dateOfActivity)
        }
        return false
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
}
