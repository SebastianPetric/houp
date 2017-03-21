//
//  RegistrationCell.swift
//  Houp
//
//  Created by Sebastian on 20.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class RegistrationUsernameCell: UICollectionViewCell{

    let usernameTextField: CustomTextField = {
        let username = CustomTextField()
        username.placeholder = "Benutzername"
        username.layer.borderColor = UIColor.lightGray.cgColor
        username.layer.borderWidth = 0.5
        username.borderStyle = .none
        return username
    }()

    let backToLoginButton: UIButton = {
        let backToLoginButton = UIButton(type: .system)
        backToLoginButton.setTitle("Zu Login", for: .normal)
        backToLoginButton.layer.borderColor = UIColor.black.cgColor
        backToLoginButton.layer.borderWidth = 0.5
        backToLoginButton.backgroundColor = .yellow
        return backToLoginButton
    }()

    let continueButton: UIButton = {
        let continueButton = UIButton(type: .system)
        continueButton.setTitle("Weiter", for: .normal)
        continueButton.layer.borderColor = UIColor.black.cgColor
        continueButton.layer.borderWidth = 0.5
        continueButton.backgroundColor = .yellow
        return continueButton
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpRegistrationUsernameCell()
    }
    
    func setUpRegistrationUsernameCell(){
    addSubview(usernameTextField)
    addSubview(backToLoginButton)
    addSubview(continueButton)
    
        usernameTextField.addConstraintsWithConstants(top: topAnchor, right: rightAnchor, bottom: nil, left: leftAnchor, centerX: centerXAnchor, centerY: nil, topConstant: 50, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 40)
        
        backToLoginButton.addConstraintsWithConstants(top: nil, right: nil, bottom: bottomAnchor, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: frame.width/2, height: 40)
        
        continueButton.addConstraintsWithConstants(top: nil, right: rightAnchor, bottom: bottomAnchor, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: frame.width/2, height: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
