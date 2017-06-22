//
//  ActivityForm3Handler.swift
//  Houp
//
//  Created by Sebastian on 09.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

extension ActivityForm3{
    
    func handleContinue(){
        if(self.continueButton.layer.borderColor == UIColor().getSecondColor().cgColor){
            if (hasAnyErrors()){
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithDB.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                self.present(alert, animated: true, completion: nil)
            }else{
                
                //Hier noch den Timer zurücksetzen
                TimerObject.shared.deinitialiseTimer()
//                self.activityWeekCollection?.liveQuery?.removeObserver(self.activityWeekCollection.self!, forKeyPath: "rows")
//                self.activityWeekCollection?.activityList.removeAll()
//                self.activityWeekCollection?.getTopicActivities(userID: UserDefaults.standard.string(forKey: GetString.userID.rawValue)!)
                TempStorageAndCompare.shared.deleteFirstItemOfCurrentWeek()
                self.activityWeekCollection?.activityCollectionView.reloadData()
                
                if((TempStorageAndCompare.shared.getActiveActivitiesOfCurrentWeek().count) > 0){
                    if(Date().checkIfActivityAlreadyOver(activityDate: (TempStorageAndCompare.shared.getActiveActivitiesOfCurrentWeek().first?.dateObject)!)){
                    TimerObject.shared.setUpTimerImmediately()
                    }else{
                    TimerObject.shared.setUpTimer(date: (TempStorageAndCompare.shared.getActiveActivitiesOfCurrentWeek().first?.dateObject)!)
                    }
                }
                
                self.activityWeekCollection?.handleNavBarItem()
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
    }
    
    func hasAnyErrors() -> Bool{
        var wellBeState: Int = -1
        for button in container.subviews as! [UIButton] {
            if(button.backgroundColor == UIColor().getSecondColor()){
                wellBeState = container.subviews.index(of: button)!
            }
        }
        var wellBeText: String = ""
        if(self.extraCommentSwitch.isOn && self.reason.text != ""){
            wellBeText = self.reason.text
        }
        self.activity?.wellBeingState = wellBeState
        self.activity?.wellBeingText = wellBeText

        if DBConnection.shared.updateActivityAfterForm(properties: self.activity!) != nil{
        return true
        }else if(wantToShare){
            if DBConnection.shared.shareActivityWithGroups(properties: self.activity!) != nil{
            return true
            }else{
            return false
            }
        }else{
            return false
        }
    }
    
    func handleSelectImage(sender: UIButton){
        if(sender == self.veryBadImage || sender == self.badImage || sender == self.neutralImage ){
            self.reasonHeader.text = "Kopf hoch! Weißt du woran es gelegen haben könnte?"
        }else if(sender == self.goodImage || sender == self.veryGoodImage){
            self.reasonHeader.text = "Freut uns sehr zuhören! Willst du sagen was dich so happy macht?"
        }
        
        for button in container.subviews as! [UIButton] {
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
    
    func handleDismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.positiveResponse.alpha = 0
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }
}
