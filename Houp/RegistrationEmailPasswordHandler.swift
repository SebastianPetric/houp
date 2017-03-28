//
//  RegistrationEmailPasswordHandler.swift
//  Houp
//
//  Created by Sebastian on 21.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

private var errorMessage: String = ""

extension RegistrationEmailPasswordController{

func handleRegsitration(){
    if(hasAnyErrors()){
        let alert = UIAlertController(title: GetString.errorTitle.rawValue, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: GetString.errorOKButton.rawValue, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }else{
        do{
            User.shared.email = self.emailTextField.text
            User.shared.password = self.passwordTextField.text
            try DBConnection.shared.addUserWithProperties(properties: User.shared.getPropertyPackageForRegistration())
        }catch{
        print("Fehler beim registrieren")
        }
        print("Registrierung erfolgreich")
    }
}
    
    func hasAnyErrors() -> Bool{
        if(self.emailTextField.text == "" || self.passwordTextField.text == "" || self.passwordRepeatTextField.text == ""){
        errorMessage = GetString.errorFillAllFields.rawValue
        return true
        }else if(DBConnection.shared.checkIfUsernameOrEmailAlreadyExists(view: DBConnection.shared.viewByEmail! ,usernameOrEmail: self.emailTextField.text!)){
            errorMessage = GetString.errorEmailAlreadyExists.rawValue
            return true
        }else if((self.passwordTextField.text! != self.passwordRepeatTextField.text!)){
            errorMessage = GetString.errorDifferentPasswords.rawValue
            return true
        }
        return false
    }
}
