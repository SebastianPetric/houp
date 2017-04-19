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
        let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: errorMessage, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
        self.present(alert, animated: true, completion: nil)
    }else{
            User.shared.email = self.emailTextField.text
            User.shared.password = self.passwordTextField.text
        if let error = DBConnection.shared.addUserWithProperties(properties: User.shared.getPropertyPackageForRegistration()){
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }else{
        present(CustomTabBarController(), animated: true, completion: nil)
        }
    }
}
    
    func hasAnyErrors() -> Bool{
        
        do{
        if(self.emailTextField.text == "" || self.passwordTextField.text == "" || self.passwordRepeatTextField.text == ""){
        errorMessage = GetString.errorFillAllFields.rawValue
        return true
        }else if(DBConnection.shared.checkIfEmailAlreadyExists(email: self.emailTextField.text!)){
            errorMessage = GetString.errorEmailAlreadyExists.rawValue
            return true
        }else if((self.passwordTextField.text! != self.passwordRepeatTextField.text!)){
            errorMessage = GetString.errorDifferentPasswords.rawValue
            return true
        }
        return false
        }catch{
        errorMessage = GetString.errorWithConnection.rawValue
        return true
        }
    }
}
