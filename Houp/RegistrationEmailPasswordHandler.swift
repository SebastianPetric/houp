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
// hier wird erstens überprüft ob es das passwort schon gibt, und ob die passwörter übereinstimmen, und am schluss wird alles in die DB geschrieben

    
    if(hasAnyErrors()){
        let alert = UIAlertController(title: "Upps!", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }else{
        print("Registrierung erfolgreich")
    }
}
    
    func hasAnyErrors() -> Bool{
        if(self.emailTextField.text == "" || self.passwordTextField.text == "" || self.passwordRepeatTextField.text == ""){
        errorMessage = "Bitte alle Felder ausfüllen!"
        return true
        }else if(false){
            //Hier Prüfen ob Email bereits existiert
            errorMessage = "Email Adresse bereits vergeben!"
            return true
        }else if((self.passwordTextField.text! != self.passwordRepeatTextField.text!)){
            errorMessage = "Passwörter stimmen nicht überein!"
            return true
        }
        return false
    }
}
