//
//  RegistrationPersonalDataHandler.swift
//  Houp
//
//  Created by Sebastian on 21.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

private var errorMessage: String = ""

extension RegistrationNamePrenameController{


    func handleSkip(){
            User.shared.name = ""
            User.shared.prename = ""
            self.navigationController?.pushViewController(RegistrationAgeGenderController(), animated: true)
    }
    
    func handleContinueButton(){
        if(hasAnyErrors()){
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: errorMessage, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }else{
            User.shared.name = self.nameTextField.text
            User.shared.prename = self.prenameTextField.text
            self.navigationController?.pushViewController(RegistrationAgeGenderController(), animated: true)
        }
    }
    
    func hasAnyErrors() -> Bool{
        if(self.nameTextField.text == "" || self.prenameTextField.text == ""){
            errorMessage = GetString.errorFillAllFields.rawValue
            return true
        }
        return false
    }
}
