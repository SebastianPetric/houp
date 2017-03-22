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


    func handleContinueButton(){
        if(hasAnyErrors()){
            let alert = UIAlertController(title: "Upps!", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
           self.navigationController?.pushViewController(RegistrationAgeGenderController(), animated: true)
        }
       /* let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd MM YYYY"
        print(dateformatter.string(from: self.agePicker.date) )*/
    }
    
    func hasAnyErrors() -> Bool{
        if(self.nameTextField.text == "" || self.prenameTextField.text == ""){
            errorMessage = "Bitte alle Felder ausfüllen!"
            return true
        }
        return false
    }
}
