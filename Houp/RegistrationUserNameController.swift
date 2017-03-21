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
    
    lazy var profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.image = UIImage(named: "profile_default")
        profileImage.contentMode = .scaleAspectFit
        profileImage.clipsToBounds = true
        profileImage.backgroundColor = .red
        profileImage.layer.cornerRadius = self.profileImageWidthHeight/2
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        return profileImage
    }()
    
    let usernameTextField: CustomTextField = {
        let usernameTextField = CustomTextField()
        usernameTextField.placeholder = "Benutzername"
        usernameTextField.layer.cornerRadius = 5
        usernameTextField.layer.borderColor = UIColor.lightGray.cgColor
        usernameTextField.layer.borderWidth = 1
        usernameTextField.isSecureTextEntry = true
        usernameTextField.clearButtonMode = .always
        return usernameTextField
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
        progresion.layer.cornerRadius = 3
        progresion.progress = 0.25
    return progresion
    }()
    
    let progressionViewText: UITextView = {
    let progressionViewText = UITextView()
        progressionViewText.text = "1 von 4"
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
        //self.navigationController?.navigationBar.backItem?.title = ""
        view.backgroundColor = .white
        view.addSubview(profileImage)
        view.addSubview(usernameTextField)
        view.addSubview(continueButton)
        view.addSubview(progressionView)
        view.addSubview(progressionViewText)
        view.addGestureRecognizer(gestureRecognizer)
        setUpSubViews()
        addNotificationObserver()
    }

    private func setUpSubViews(){
        
        profileImage.addConstraintsWithConstants(top: view.topAnchor, right: nil, bottom: nil, left: nil, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: profileImageWidthHeight, height: self.profileImageWidthHeight)

        usernameTextField.addConstraintsWithConstants(top: profileImage.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 50, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        continueButton.addConstraintsWithConstants(top: usernameTextField.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        progressionView.addConstraintsWithConstants(top: continueButton.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 15, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 5)
        
        progressionViewText.addConstraintsWithConstants(top: progressionView.bottomAnchor, right: view.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 45, bottomConstant: 0, leftConstant: 0, width: 45, height: 20)
    }
    
    private func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .UIKeyboardDidHide , object: nil)
    }
    
    func showKeyboard(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            //Bewegt view um 64px nach oben (Navigationbar), wegen istranslusent = true
            self.view.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    
    func hideKeyboard(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.usernameTextField.endEditing(true)
            self.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
}
