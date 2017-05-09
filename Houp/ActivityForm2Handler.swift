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
        if(self.continueButton.layer.borderColor == UIColor().getSecondColor().cgColor){
            let controller = ActivityForm3()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func handlePublicSwitch(){
        if(self.isPublicSwitch.isOn){
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
                    button.backgroundColor = UIColor().getSecondColor()
                    self.continueButton.layer.borderColor = UIColor().getSecondColor().cgColor
                    self.continueButton.setTitleColor(UIColor().getSecondColor(), for: .normal)
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
