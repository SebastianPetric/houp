//
//  CreateActivityWeekControllerHandler.swift
//  Houp
//
//  Created by Sebastian on 13.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension CreateActivityWeekController{

    func handlePublicSwitch(){
        if(self.isOnlyNextDaySwitch.isOn){
            self.continueButton.setTitle("Aktivität erstellen", for: .normal)
        }else{
            self.continueButton.setTitle("Weiter", for: .normal)
        }
    }
    func continBut(){
        if(self.activityText.text! != ""){
            if(self.isOnlyNextDaySwitch.isOn){
                finishDay()
            }else{
                continueWeek()
            }
        }
    }
    
    func finishDay(){
        if (hasAnyErrors()){
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithDB.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }else{
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
//            TimerObject.shared.invalidateTimer()
//            TimerObject.shared.invalidateDelayTimer()
            TimerObject.shared.tryLaterAgain = false
            TimerObject.shared.setUpTimer(date: tomorrow!)
            
            if let window = UIApplication.shared.keyWindow{
                self.positiveResponse = CustomViews.shared.getPositiveResponse(title: "Super!", message: "Morgen wird ein guter Tag!")
                self.positiveResponse.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
                self.positiveResponse.frame = window.frame
                window.addSubview(positiveResponse)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.positiveResponse.alpha = 1
                }, completion: nil)
            }
        }
    }
    
    func handleCancel(){
        TimerObject.shared.tryLaterAgain = true
        dismiss(animated: true, completion: nil)
    }
    
    func setActivity(){
        let timePicker = self.timeOfActivity.subviews[1] as! UIDatePicker
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        
        self.activity = Activity(rev: nil, aid: nil, authorID: UserDefaults.standard.string(forKey: GetString.userID.rawValue), authorUsername: nil, groupID: nil, activity: self.activityText.text, activityText: nil, locationOfActivity: self.locationText.text, isInProcess: nil, status: nil, wellBeingState: nil, wellBeingText: nil, addictionState: nil, addictionText: nil, dateObject: tomorrow, timeObject: timePicker.date, dateString: nil, timeString: nil, commentIDs: nil, likeIDs: nil)
    }
    
    func getActivity() -> Activity{
    return self.activity!
    }
    
    func hasAnyErrors() -> Bool{
        setActivity()
        if DBConnection.shared.createActivityWithProperties(properties: getActivity()) != nil{
            return true
        }else{
            let dateOfActivity = Date().getDateAndTimeForActity(date: (getActivity().dateObject)!, time: (getActivity().timeObject)!)
            CalendarObject.shared.setUpEventInCalendar(activity: (getActivity().activity)!, locationOfActivity: (getActivity().locationOfActivity), dateOfActivity: dateOfActivity)
            return false
        }
        
    }
    
    func continueWeek(){
        if(self.continueButton.layer.borderColor == UIColor().getSecondColor().cgColor){
                let tomorrow = Calendar.current.date(byAdding: .day, value: 2, to: Date())
                let controller = ActivityWeekForm2()
                controller.activityWeekCollection = self.activityWeekCollection
                controller.title = tomorrow?.getDatePartWithDay()
                setActivity()
                var tempList = self.activityList
                tempList.append(getActivity())
                controller.activityList = tempList
                self.navigationController?.pushViewController(controller, animated: true)
            }
    }
    
    func handleDismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.positiveResponse.alpha = 0
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }
}
