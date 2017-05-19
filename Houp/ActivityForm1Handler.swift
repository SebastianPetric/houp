//
//  ActivityForm1Handler.swift
//  Houp
//
//  Created by Sebastian on 09.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension ActivityForm1{

    func handleContinue(){
        if(self.continueButton.layer.borderColor == UIColor().getSecondColor().cgColor){
            var addictionState: Int = -1
            for button in container.subviews as! [UIButton] {
                if(button.backgroundColor == UIColor().getSecondColor()){
                addictionState = container.subviews.index(of: button)!
                }
            }
            
            var addictionText: String = ""
            if(self.extraCommentSwitch.isOn && self.reason.text != ""){
                addictionText = self.reason.text
            }
            
            let activity = Activity(rev: nil, aid: self.activityList[0].aid, authorID: UserDefaults.standard.string(forKey: GetString.userID.rawValue), authorUsername: nil, groupID: nil, activity: nil, activityText: nil, locationOfActivity: nil, isInProcess: nil, status: nil, wellBeingState: nil, wellBeingText: nil, addictionState: addictionState, addictionText: addictionText, dateObject: nil, timeObject: nil, dateString: nil, timeString: nil, commentIDs: nil, likeIDs: nil)
            
            let controller = ActivityForm2()
            controller.activityWeekCollection = self.activityWeekCollection
            controller.activity = activity
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func handleExtraCommentSwitch(){
        if(self.extraCommentSwitch.isOn){
            self.reason.isHidden = false
            self.heightOfTextView?.isActive = false
            self.heightOfTextView?.constant = 100
            self.heightOfTextView?.isActive = true
            
        }else{
            self.reason.isHidden = true
            self.heightOfTextView?.isActive = false
            self.heightOfTextView?.constant = 0
            self.heightOfTextView?.isActive = true
        }
    }
    
    func handleCancel(){
        self.activityWeekCollection?.tryLaterAgain = true
        self.activityWeekCollection?.timerReset = false
        dismiss(animated: true, completion: nil)
    }

    
    func handleSelectImage(sender: UIButton){
        for button in container.subviews as! [UIButton] {
            if(sender == self.veryBadImage || sender == self.badImage){
                self.reasonHeader.text = "Sehr gut! Willst du noch etwas dazu sagen?"
            }else if(sender == self.neutralImage || sender == self.goodImage || sender == self.veryGoodImage){
                self.reasonHeader.text = "Weißt du vielleicht woran es gelegen haben könnte?"
            }
            if(button == sender){
                if(button.backgroundColor == .white){
                    button.backgroundColor = UIColor().getSecondColor()
                    self.continueButton.layer.borderColor = UIColor().getSecondColor().cgColor
                    self.continueButton.setTitleColor(UIColor().getSecondColor(), for: .normal)
                }else{
                    button.backgroundColor = .white
                    self.continueButton.layer.borderColor = UIColor().getLightGreyColor().cgColor
                    self.continueButton.setTitleColor(UIColor().getLightGreyColor(), for: .normal)
                }
            }else{
                button.backgroundColor = .white
            }
        }
    }
}
