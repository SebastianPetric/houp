//
//  ViewController.swift
//  Houp
//
//  Created by Sebastian on 17.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{

    let logoImageWidthHeight: CGFloat = 150
    
    lazy var logoImage: UIImageView = {
    let logoImage = UIImageView()
        logoImage.image = UIImage(named: "logo_houp")
        logoImage.contentMode = .scaleAspectFit
        logoImage.clipsToBounds = true
        logoImage.backgroundColor = .red
        logoImage.layer.cornerRadius = self.logoImageWidthHeight/2
        logoImage.translatesAutoresizingMaskIntoConstraints = false
    return logoImage
    }()
    
    
    let usernameTextField: CustomTextField = {
    let usernameTextField = CustomTextField()
        usernameTextField.placeholder = "Benutzername eingeben"
        usernameTextField.layer.cornerRadius = 5
        usernameTextField.layer.borderColor = UIColor().getTextViewBorderColor()
        usernameTextField.layer.borderWidth = 1
        usernameTextField.clearButtonMode = .always
    return usernameTextField
    }()
    
    let passwordTextField: CustomTextField = {
        let passwordTextField = CustomTextField()
        passwordTextField.placeholder = "Passwort eingeben"
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.borderColor = UIColor().getTextViewBorderColor()
        passwordTextField.layer.borderWidth = 1
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clearButtonMode = .always
        return passwordTextField
    }()
    
    let loginButton: UIButton = {
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderColor = UIColor.lightGray.cgColor
        loginButton.layer.borderWidth = 1
        loginButton.tintColor = .black
        return loginButton
    }()
    
    let registrationButton: UIButton = {
        let registrationButton = UIButton(type: .system)
        registrationButton.setTitle("Registrieren", for: .normal)
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
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registrationButton)
        view.addGestureRecognizer(gestureRecognizer)
        setUpSubViews()
        addNotificationObserver()
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

