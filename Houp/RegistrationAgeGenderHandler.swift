//
//  RegistrationAgeGenderHandler.swift
//  Houp
//
//  Created by Sebastian on 21.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit


extension RegistrationAgeGenderController{
    
    func handleSkip(){
        User.shared.gender = -1
        User.shared.birthday = nil
        self.navigationController?.pushViewController(RegistrationEmailPasswordController(), animated: true)
    }

    func handleContinueButton(){
        User.shared.gender = self.gender.selectedSegmentIndex
        let picker = birthdayPicker.subviews[1] as! UIDatePicker
        
        User.shared.birthday = picker.date
        self.navigationController?.pushViewController(RegistrationEmailPasswordController(), animated: true)
    }
}
