//
//  RegistrationUserNameController.swift
//  Houp
//
//  Created by Sebastian on 21.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class RegistrationUserNameController: UIViewController{

    let profileImageWidthHeight: CGFloat = 150
    let profileImage = CustomViews().getBigRoundImage(name: "profile_default", cornerRadius: 75)
    let usernameTextField = CustomViews().getCustomTextField(placeholder: "Benutzername", isPasswordField: false)
    let continueButton = CustomViews().getCustomButton(title: "Weiter")
    let customProgressionView = CustomViews().getCustomProgressionView(status: 0.25, statusText: "1 von 4")
    
    lazy var gestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        return recognizer
    }()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.backItem?.title = ""
        view.backgroundColor = .white
        view.addSubview(profileImage)
        view.addSubview(usernameTextField)
        view.addSubview(continueButton)
        view.addSubview(customProgressionView)
        view.addGestureRecognizer(gestureRecognizer)
        continueButton.addTarget(self, action: #selector(handleContinueButton), for: .touchUpInside)
        setUpSubViews()
        addNotificationObserver()
    }

    private func setUpSubViews(){
        profileImage.addConstraintsWithConstants(top: view.topAnchor, right: nil, bottom: nil, left: nil, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: profileImageWidthHeight, height: self.profileImageWidthHeight)

        usernameTextField.addConstraintsWithConstants(top: profileImage.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        customProgressionView.addConstraintsWithConstants(top: usernameTextField.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 25)
        
        continueButton.addConstraintsWithConstants(top: customProgressionView.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 15, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
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
            self.usernameTextField.endEditing(true)
            self.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
}
