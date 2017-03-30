//
//  RegistrationAgeGenderHandler.swift
//  Houp
//
//  Created by Sebastian on 21.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit


extension RegistrationAgeGenderController{

    func handleContinueButton(){
        User.shared.gender = self.gender.selectedSegmentIndex
        
      /*  let dateformatter = DateFormatter()
         dateformatter.dateFormat = "dd MM YYYY"
         print(dateformatter.string(from: self.agePicker.date))*/
        
        let picker = agePicker.subviews[1] as! UIDatePicker
        
        User.shared.birthday = picker.date
        self.navigationController?.pushViewController(RegistrationEmailPasswordController(), animated: true)
    }
}
