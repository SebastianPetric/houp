//
//  ViewController.swift
//  Houp
//
//  Created by Sebastian on 17.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{

    let logoImageWidthHeight: CGFloat = 150
    let logoImage = CustomViews().getBigRoundImage(name: "logo_houp", cornerRadius: 75, isUserInteractionEnabled: false)
    let usernameTextField = CustomViews().getCustomTextField(placeholder: "Benutzername eingeben", isPasswordField: false)
    let passwordTextField = CustomViews().getCustomTextField(placeholder: "Passwort eingeben", isPasswordField: true)
    let loginButton = CustomViews().getCustomButton(title: "Login")
    
    let registrationButton: UIButton = {
        let registrationButton = UIButton(type: .system)
        registrationButton.setTitle("Registrieren", for: .normal)
        registrationButton.setTitleColor(UIColor(red: 41, green: 192, blue: 232, alphaValue: 1), for: .normal)
        registrationButton.addTarget(self, action: #selector(handleRegistrationButton), for: .touchUpInside)
        return registrationButton
    }()
    
    lazy var gestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    return recognizer
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(logoImage)
        view.addSubview(usernameTextField)
        usernameTextField.delegate = self
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registrationButton)
        view.addGestureRecognizer(gestureRecognizer)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        setUpSubViews()
        addNotificationObserver()
    }
   
    func setUpSubViews(){
        logoImage.addConstraintsWithConstants(top: view.topAnchor, right: nil, bottom: nil, left: nil, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: self.logoImageWidthHeight, height: self.logoImageWidthHeight)
        
        usernameTextField.addConstraintsWithConstants(top: logoImage.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        passwordTextField.addConstraintsWithConstants(top: usernameTextField.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        loginButton.addConstraintsWithConstants(top: passwordTextField.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        registrationButton.addConstraintsWithConstants(top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 0, rightConstant: 50, bottomConstant: 25, leftConstant: 50, width: 0, height: 40)
    }

    
    private func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .UIKeyboardDidHide , object: nil)
    }
    
    func showKeyboard(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
            //Bewegt view um 64px nach oben (Navigationbar), wegen istranslusent = true
            self.view.frame = CGRect(x: 0, y: -35, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    
    func hideKeyboard(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.usernameTextField.endEditing(true)
            self.passwordTextField.endEditing(true)
            self.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
}

