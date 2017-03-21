//
//  LogRegHandler.swift
//  Houp
//
//  Created by Sebastian on 20.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension LoginViewController{

    func handleLogin(){
        //Bei erfolgreichem Login, soll der Startbildschirm gezeigt werden
    }
    
    func handleRegistrationButton(){
        navigationController?.pushViewController(RegistrationUserNameController(), animated: true)
    }

    
    func setUpSubViews(){
        logoImage.addConstraintsWithConstants(top: view.topAnchor, right: nil, bottom: nil, left: nil, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: self.logoImageWidthHeight, height: self.logoImageWidthHeight)
        
        usernameTextField.addConstraintsWithConstants(top: logoImage.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 50, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        passwordTextField.addConstraintsWithConstants(top: usernameTextField.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        loginButton.addConstraintsWithConstants(top: passwordTextField.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        registrationButton.addConstraintsWithConstants(top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 0, rightConstant: 50, bottomConstant: 25, leftConstant: 50, width: 0, height: 40)
    }
}
