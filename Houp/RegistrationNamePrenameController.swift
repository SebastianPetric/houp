//
//  RegistrationPersonalDataController.swift
//  Houp
//
//  Created by Sebastian on 21.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class RegistrationNamePrenameController: UIViewController{

    
    lazy var nameTextField: CustomTextField = {
        let nameTextField = CustomTextField()
        nameTextField.placeholder = "Name"
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.borderWidth = 1
        nameTextField.clearButtonMode = .always
        return nameTextField
    }()
    
    let prenameTextField: CustomTextField = {
        let prenameTextField = CustomTextField()
        prenameTextField.placeholder = "Vorname"
        prenameTextField.layer.cornerRadius = 5
        prenameTextField.layer.borderColor = UIColor.lightGray.cgColor
        prenameTextField.layer.borderWidth = 1
        prenameTextField.clearButtonMode = .always
        return prenameTextField
    }()
    
    let continueButton: UIButton = {
        let continueButton = UIButton(type: .system)
        continueButton.setTitle("Weiter", for: .normal)
        continueButton.layer.cornerRadius = 5
        continueButton.layer.borderColor = UIColor.lightGray.cgColor
        continueButton.layer.borderWidth = 1
        continueButton.tintColor = .black
        continueButton.addTarget(self, action: #selector(handleContinueButton), for: .touchUpInside)
        return continueButton
    }()

    
    let progressionView: UIProgressView = {
        let progresion = UIProgressView()
        //progresion.progressTintColor = .white
        progresion.trackTintColor = .white
        progresion.layer.borderColor = UIColor().getTextViewBorderColor()
        progresion.layer.borderWidth = 1
        progresion.layer.cornerRadius = 5
        progresion.progress = 0.5
        return progresion
    }()
    
    let progressionViewText: UITextView = {
        let progressionViewText = UITextView()
        progressionViewText.text = "2 von 4"
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
        view.addSubview(nameTextField)
        view.addSubview(prenameTextField)
        view.addSubview(continueButton)
        view.addSubview(progressionView)
        view.addSubview(progressionViewText)
        view.addGestureRecognizer(gestureRecognizer)
        setUpSubviews()
        addNotificationObserver()
    }
    
    func setUpSubviews(){
    
        nameTextField.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 160, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        prenameTextField.addConstraintsWithConstants(top: nameTextField.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        
        continueButton.addConstraintsWithConstants(top: prenameTextField.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        progressionView.addConstraintsWithConstants(top: continueButton.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 15, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 5)
        
        progressionViewText.addConstraintsWithConstants(top: progressionView.bottomAnchor, right: view.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 45, bottomConstant: 0, leftConstant: 0, width: 50, height: 20)

    }
    private func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .UIKeyboardDidHide , object: nil)
    }
    
    func showKeyboard(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            //Bewegt view um 64px nach oben (Navigationbar), wegen istranslusent = true
            self.view.frame = CGRect(x: 0, y: -40, width: self.view.frame.width, height: self.view.frame.height)
            self.nameTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 25).isActive = true
        }, completion: nil)
    }
    
    
    func hideKeyboard(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.nameTextField.endEditing(true)
            self.prenameTextField.endEditing(true)
            self.nameTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 160).isActive = true
            //self.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }

}
