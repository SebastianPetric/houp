//
//  LoginCell.swift
//  Houp
//
//  Created by Sebastian on 20.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit


class LoginCell: UICollectionViewCell{
    
    let usernameTextField: CustomTextField = {
    let username = CustomTextField()
        username.placeholder = "Benutzername"
        username.layer.borderColor = UIColor.lightGray.cgColor
        username.layer.borderWidth = 0.5
        username.borderStyle = .none
        return username
    }()
    
    let passwordTextField: CustomTextField = {
    let password = CustomTextField()
        password.placeholder = "Passwort"
        password.layer.borderColor = UIColor.lightGray.cgColor
        password.layer.borderWidth = 0.5
        password.isSecureTextEntry = true
    return password
    }()
    
    let loginButton: UIButton = {
    let loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .yellow
    return loginButton
    }()
    
    let seperator: UIView = {
    let seperator = UIView()
        seperator.backgroundColor = .black
    return seperator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLoginCell()
    }
    
    private func setUpLoginCell(){
    addSubview(usernameTextField)
    passwordTextField.addSubview(seperator)
    addSubview(passwordTextField)
    addSubview(loginButton)
    
    usernameTextField.addConstraintsWithConstants(top: topAnchor, right: rightAnchor, bottom: nil, left: leftAnchor, centerX: centerXAnchor, centerY: nil, topConstant: 50, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 40)
        
        
    passwordTextField.addConstraintsWithConstants(top: usernameTextField.bottomAnchor, right: rightAnchor, bottom: nil, left: leftAnchor, centerX: centerXAnchor, centerY: nil, topConstant: 20, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 40)
        
    loginButton.addConstraintsWithConstants(top: nil, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, centerX: centerXAnchor, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
