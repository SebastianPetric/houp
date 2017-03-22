//
//  RegistrationUserNameHandler.swift
//  Houp
//
//  Created by Sebastian on 21.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

private var errorMessage: String = ""

extension RegistrationUserNameController{

    func handleContinueButton(){
        if(hasAnyErrors()){
            let alert = UIAlertController(title: "Upps!", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            self.navigationController?.pushViewController(RegistrationNamePrenameController(), animated: true)
        }

        
    }
    
    func hasAnyErrors() -> Bool{
        if(self.usernameTextField.text == ""){
            errorMessage = "Bitte alle Felder ausfüllen!"
            return true
        }
        return false
    }
}
