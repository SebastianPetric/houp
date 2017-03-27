//
//  LogRegHandler.swift
//  Houp
//
//  Created by Sebastian on 20.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

private var errorMessage: String = ""

extension LoginViewController{

    func handleLogin(){
        //Bei erfolgreichem Login, soll der Startbildschirm gezeigt werden
        if(hasAnyErrors()){
            let alert = UIAlertController(title: "Upps!", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            print("Login erfolgreich")
        }
    }
    
    func handleRegistrationButton(){
        navigationController?.pushViewController(RegistrationUserNameController(), animated: true)
    }
    
    func hasAnyErrors() -> Bool{
        if(self.usernameTextField.text == "" || self.passwordTextField.text == ""){
            errorMessage = "Bitte alle Felder ausfüllen!"
            return true
        }else{
            if (DBConnection.shared.checkUsernamePassword(username: self.usernameTextField.text!, password: self.passwordTextField.text!)){
                errorMessage = "Benutzername oder Passwort stimmt nicht! Bitte versuche es nochmal!"
                return true
            }else{
                return false
            }
        }
    }
}
