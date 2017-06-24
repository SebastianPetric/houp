//
//  ActivityWeekForm4Handler.swift
//  Houp
//
//  Created by Sebastian on 13.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension ActivityWeekForm4{
    
    func setActivity(){
        let timePicker = self.timeOfActivity.subviews[1] as! UIDatePicker
        let tomorrow = Calendar.current.date(byAdding: .day, value: 4, to: Date())
        
        self.activity = Activity(rev: nil, aid: nil, authorID: UserDefaults.standard.string(forKey: GetString.userID.rawValue), authorUsername: nil, groupID: nil, activity: self.activityText.text, activityText: nil, locationOfActivity: self.locationText.text, isInProcess: nil, status: nil, wellBeingState: nil, wellBeingText: nil, addictionState: nil, addictionText: nil, dateObject: tomorrow, timeObject: timePicker.date, dateString: nil, timeString: nil, commentIDs: nil, likeIDs: nil)
    }
    
    func getActivity() -> Activity{
    return self.activity!
    }
    
    func continueWeek(){
        if(self.continueButton.layer.borderColor == UIColor.black.cgColor){
                let tomorrow = Calendar.current.date(byAdding: .day, value: 5, to: Date())
                let controller = ActivityWeekForm5()
                controller.activityWeekCollection = self.activityWeekCollection
                controller.title = tomorrow?.getDatePartWithDay()
                setActivity()
            var tempList = self.activityList
            tempList.append(getActivity())
            controller.activityList = tempList
                self.navigationController?.pushViewController(controller, animated: true)
            }
    }
}
