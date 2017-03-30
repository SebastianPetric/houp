//
//  RegistrationEmailPassword.swift
//  Houp
//
//  Created by Sebastian on 21.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class RegistrationEmailPasswordController: UIViewController{

    
    let emailTextField = CustomViews.shared.getCustomTextField(placeholder: GetString.email.rawValue, isPasswordField: false)
    let passwordTextField = CustomViews.shared.getCustomTextField(placeholder: GetString.password.rawValue, isPasswordField: true)
    let passwordRepeatTextField = CustomViews.shared.getCustomTextField(placeholder: GetString.repeatPassword.rawValue, isPasswordField: true)
    let registrationButton = CustomViews.shared.getCustomButton(title: GetString.finishRegistrationButton.rawValue)
    let customProgressionView = CustomViews.shared.getCustomProgressionView(status: 1.0, statusText: "4 von 4")

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
        view.addSubview(customProgressionView)
        view.addGestureRecognizer(gestureRecognizer)
        registrationButton.addTarget(self, action: #selector(handleRegsitration), for: .touchUpInside)
        addNotificationObserver()
        setUpSubViews()
    }
    
    func setUpSubViews(){
        emailTextField.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 95, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        passwordTextField.addConstraintsWithConstants(top: emailTextField.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        
        passwordRepeatTextField.addConstraintsWithConstants(top: passwordTextField.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        customProgressionView.addConstraintsWithConstants(top: passwordRepeatTextField.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 25)
        
        registrationButton.addConstraintsWithConstants(top: customProgressionView.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 15, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    }
    
    private func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .UIKeyboardDidHide , object: nil)
    }

    func showKeyboard(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            //Bewegt view um 64px nach oben (Navigationbar), wegen istranslusent = true
            self.view.frame = CGRect(x: 0, y: -25, width: self.view.frame.width, height: self.view.frame.height)
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
