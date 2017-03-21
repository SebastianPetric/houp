//
//  RegistrationEmailPassword.swift
//  Houp
//
//  Created by Sebastian on 21.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class RegistrationEmailPasswordController: UIViewController{

    let emailTextField: CustomTextField = {
        let emailTextField = CustomTextField()
        emailTextField.placeholder = "Email eingeben"
        emailTextField.layer.cornerRadius = 5
        emailTextField.layer.borderColor = UIColor().getTextViewBorderColor()
        emailTextField.layer.borderWidth = 1
        emailTextField.clearButtonMode = .always
        return emailTextField
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
    
    let passwordRepeatTextField: CustomTextField = {
        let passwordRepeatTextField = CustomTextField()
        passwordRepeatTextField.placeholder = "Passwort wiederholen"
        passwordRepeatTextField.layer.cornerRadius = 5
        passwordRepeatTextField.layer.borderColor = UIColor().getTextViewBorderColor()
        passwordRepeatTextField.layer.borderWidth = 1
        passwordRepeatTextField.isSecureTextEntry = true
        passwordRepeatTextField.clearButtonMode = .always
        return passwordRepeatTextField
    }()

    
    let registrationButton: UIButton = {
        let registrationButton = UIButton(type: .system)
        registrationButton.setTitle("Los geht's!", for: .normal)
        registrationButton.layer.cornerRadius = 5
        registrationButton.layer.borderColor = UIColor.lightGray.cgColor
        registrationButton.layer.borderWidth = 1
        registrationButton.tintColor = .black
        registrationButton.addTarget(self, action: #selector(handleRegsitration), for: .touchUpInside)
        return registrationButton
    }()

    let progressionView: UIProgressView = {
        let progresion = UIProgressView()
        //progresion.progressTintColor = .white
        progresion.trackTintColor = .white
        progresion.layer.borderColor = UIColor().getTextViewBorderColor()
        progresion.layer.borderWidth = 1
        progresion.layer.cornerRadius = 5
        progresion.progress = 1.0
        return progresion
    }()
    
    let progressionViewText: UITextView = {
        let progressionViewText = UITextView()
        progressionViewText.text = "4 von 4"
        progressionViewText.font = UIFont.systemFont(ofSize: 10)
        progressionViewText.textAlignment = .center
        progressionViewText.textColor = .black
        return progressionViewText
    }()

    lazy var gestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        return recognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(passwordRepeatTextField)
        view.addSubview(registrationButton)
        view.addSubview(progressionViewText)
        view.addSubview(progressionView)
        view.addGestureRecognizer(gestureRecognizer)
        addNotificationObserver()
        setUpSubViews()
    }
    
    func setUpSubViews(){
        
        emailTextField.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 95, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        passwordTextField.addConstraintsWithConstants(top: emailTextField.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        
        passwordRepeatTextField.addConstraintsWithConstants(top: passwordTextField.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        registrationButton.addConstraintsWithConstants(top: passwordRepeatTextField.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)

        progressionView.addConstraintsWithConstants(top: registrationButton.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 15, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 5)
        
        progressionViewText.addConstraintsWithConstants(top: progressionView.bottomAnchor, right: view.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 45, bottomConstant: 0, leftConstant: 0, width: 50, height: 20)

    }
    
    private func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .UIKeyboardDidHide , object: nil)
    }

    func showKeyboard(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            //Bewegt view um 64px nach oben (Navigationbar), wegen istranslusent = true
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    
    func hideKeyboard(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.emailTextField.endEditing(true)
            self.passwordTextField.endEditing(true)
            self.passwordRepeatTextField.endEditing(true)
            self.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
}
