//
//  RegistrationUserNameHandler.swift
//  Houp
//
//  Created by Sebastian on 21.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension RegistrationUserNameController{


    func handleContinueButton(){
        
        self.navigationController?.pushViewController(RegistrationNamePrenameController(), animated: true)
    
    }
}
