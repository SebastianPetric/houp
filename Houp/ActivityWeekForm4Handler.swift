//
//  ActivityWeekForm4Handler.swift
//  Houp
//
//  Created by Sebastian on 13.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension ActivityWeekForm4{
    
    func hasAnyErrors() -> Bool{
        let timePicker = self.timeOfActivity.subviews[1] as! UIDatePicker
        let tomorrow = Calendar.current.date(byAdding: .day, value: 4, to: Date())
        
        let activity = Activity(rev: nil, aid: nil, authorID: UserDefaults.standard.string(forKey: GetString.userID.rawValue), authorUsername: nil, groupID: nil, activity: self.activityText.text, activityText: nil, locationOfActivity: self.locationText.text, isInProcess: nil, status: nil, wellBeingState: nil, wellBeingText: nil, addictionState: nil, addictionText: nil, dateObject: tomorrow, timeObject: timePicker.date, commentIDs: nil, likeIDs: nil)
        if let error = DBConnection.shared.createActivityWithProperties(properties: activity){
            return true
        }else{
            return false
        }
    }
    
    func continueWeek(){
        if(self.continueButton.layer.borderColor == UIColor().getSecondColor().cgColor){
            if (hasAnyErrors()){
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithDB.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: {action in self.dismiss(animated: true, completion: nil)}, secondHandler: nil)
                self.present(alert, animated: true, completion: nil)
            }else{
                let tomorrow = Calendar.current.date(byAdding: .day, value: 5, to: Date())
                let controller = ActivityWeekForm5()
                controller.title = tomorrow?.getDatePart()
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}
