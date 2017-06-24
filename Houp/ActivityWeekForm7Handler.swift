//
//  ActivityWeekForm7Handler.swift
//  Houp
//
//  Created by Sebastian on 13.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension ActivityWeekForm7{
    
    
    func continueWeek(){
        if(self.continueButton.layer.borderColor == UIColor.black.cgColor){
            if (hasAnyErrors()){
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithDB.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                self.present(alert, animated: true, completion: nil)
            }else{
                TimerObject.shared.invalidateTimer()
                TimerObject.shared.invalidateDelayTimer()
                TimerObject.shared.setUpTimer(date: self.activityList[0].dateObject!)
                TimerObject.shared.tryLaterAgain = false
                if let window = UIApplication.shared.keyWindow{
                    self.positiveResponse = CustomViews.shared.getPositiveResponse(title: "Super!", message: "Viel Spaß bei deiner neuen Woche!")
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
    
    func setActivity(){
        let timePicker = self.timeOfActivity.subviews[1] as! UIDatePicker
        let tomorrow = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        
        self.activity = Activity(rev: nil, aid: nil, authorID: UserDefaults.standard.string(forKey: GetString.userID.rawValue), authorUsername: nil, groupID: nil, activity: self.activityText.text, activityText: nil, locationOfActivity: self.locationText.text, isInProcess: nil, status: nil, wellBeingState: nil, wellBeingText: nil, addictionState: nil, addictionText: nil, dateObject: tomorrow, timeObject: timePicker.date, dateString: nil, timeString: nil, commentIDs: nil, likeIDs: nil)
    }
    
    func getActivity() -> Activity{
        return self.activity!
    }
    
    func hasAnyErrors() -> Bool{
        
        setActivity()
        var tempList = self.activityList
        tempList.append(getActivity())
        
        for activity in tempList {
            if DBConnection.shared.createActivityWithProperties(properties: activity) != nil{
                return true
            }else{
                let dateOfActivity = Date().getDateAndTimeForActity(date: activity.dateObject!, time: activity.timeObject!)
                CalendarObject.shared.setUpEventInCalendar(activity: activity.activity!, locationOfActivity: activity.locationOfActivity, dateOfActivity: dateOfActivity)
            }
        }
        return false
    }
    
    func handleDismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.positiveResponse.alpha = 0
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }
}
