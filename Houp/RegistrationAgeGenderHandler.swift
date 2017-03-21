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
        self.navigationController?.pushViewController(RegistrationEmailPasswordController(), animated: true)
    }
}
