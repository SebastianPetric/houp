//
//  RegistrationPersonalDataHandler.swift
//  Houp
//
//  Created by Sebastian on 21.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit


extension RegistrationNamePrenameController{


    func handleContinueButton(){
    self.navigationController?.pushViewController(RegistrationAgeGenderController(), animated: true)
       /* let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd MM YYYY"
        print(dateformatter.string(from: self.agePicker.date) )*/
    }
    
}
