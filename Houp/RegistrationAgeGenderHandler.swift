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
        UserRegistration.shared.gender = self.gender.selectedSegmentIndex
        
      /*  let dateformatter = DateFormatter()
         dateformatter.dateFormat = "dd MM YYYY"
         print(dateformatter.string(from: self.agePicker.date))*/
        
        UserRegistration.shared.birthday = self.agePicker.date
        self.navigationController?.pushViewController(RegistrationEmailPasswordController(), animated: true)
    }
}
