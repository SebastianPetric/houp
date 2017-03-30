//
//  LogRegHandler.swift
//  Houp
//
//  Created by Sebastian on 20.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit
import CoreData

private var errorMessage: String = ""
extension LoginViewController{

    func handleLogin(){
        if(hasAnyErrors()){
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: errorMessage, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }else{
            UserDefaults.standard.set(self.usernameTextField.text, forKey: GetString.username.rawValue)
            present(CustomTabBarController(), animated: true, completion: nil)
        }
    }
    
    func handleRegistrationButton(){
        navigationController?.pushViewController(RegistrationUserNameController(), animated: true)
    }
    
    func hasAnyErrors() -> Bool{
        if(self.usernameTextField.text == "" || self.passwordTextField.text == ""){
            errorMessage = GetString.errorFillAllFields.rawValue
            return true
        }else{
            if (DBConnection.shared.checkUsernamePassword(username: self.usernameTextField.text!, password: self.passwordTextField.text!)){
                errorMessage = GetString.errorFalseUsernamePassword.rawValue
                return true
            }else{
                return false
            }
        }
    }
}
