//
//  ActivityForm2Handler.swift
//  Houp
//
//  Created by Sebastian on 09.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension ActivityForm2{

    func handleContinue(){
            if(self.continueButton.layer.borderColor == UIColor.black.cgColor){
                var success: Int = -1
                for button in container.subviews as! [UIButton] {
                    if(button.backgroundColor == UIColor().getFourthColor()){
                        success = container.subviews.index(of: button)!
                    }
                }
                
                var successText: String = ""
                if(self.extraCommentSwitch.isOn && self.reason.text != ""){
                    successText = self.reason.text
                }
                
                let controller = ActivityForm3()
                controller.activityWeekCollection = self.activityWeekCollection
                self.activity?.status = success
                self.activity?.activityText = successText
                self.activity?.isInProcess = false
                controller.activity = self.activity
                controller.wantToShare = shareSwitch.isOn
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
    
    func handleSelectImage(sender: UIButton){
        if(sender == self.badImage || sender == self.neutralImage){
            self.reasonHeader.text = "Schade! Weißt du woran es gelegen haben könnte?"
        }else if(sender == self.goodImage){
            self.reasonHeader.text = "Willst du noch etwas dazu sagen?"
        }
        
        for button in container.subviews as! [UIButton] {
            if(button == sender){
                if(sender == self.goodImage){
                    self.shareContainer.isHidden = false
                    self.heightOfShareContainer?.isActive = false
                    self.heightOfShareContainer?.constant = 40
                    self.heightOfShareContainer?.isActive = true
                }else{
                    self.shareContainer.isHidden = true
                    self.heightOfShareContainer?.isActive = false
                    self.heightOfShareContainer?.constant = 0
                    self.heightOfShareContainer?.isActive = true
                }
                if(button.backgroundColor == .white){
                    button.backgroundColor = UIColor().getFourthColor()
                    self.continueButton.layer.borderColor = UIColor.black.cgColor
                    self.continueButton.setTitleColor(.black, for: .normal)
                }else{
                    button.backgroundColor = .white
                    self.continueButton.layer.borderColor = UIColor().getLightGreyColor().cgColor
                    self.continueButton.setTitleColor(UIColor().getLightGreyColor(), for: .normal)
                    self.shareContainer.isHidden = true
                    self.heightOfShareContainer?.isActive = false
                    self.heightOfShareContainer?.constant = 0
                    self.heightOfShareContainer?.isActive = true
                }
            }else{
                button.backgroundColor = .white
            }
        }
    }

}
