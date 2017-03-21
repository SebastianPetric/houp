//
//  RegistrationPersonalDataCell.swift
//  Houp
//
//  Created by Sebastian on 20.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

//
//  RegistrationCell.swift
//  Houp
//
//  Created by Sebastian on 20.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class RegistrationPersonalDataCell: UICollectionViewCell{
    
    let nameTextField: CustomTextField = {
        let nameTextField = CustomTextField()
        nameTextField.placeholder = "Name"
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.borderWidth = 0.5
        nameTextField.borderStyle = .none
        return nameTextField
    }()
    
    let preNameTextField: CustomTextField = {
        let preNameTextField = CustomTextField()
        preNameTextField.placeholder = "Vorname"
        preNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        preNameTextField.layer.borderWidth = 0.5
        preNameTextField.borderStyle = .none
        return preNameTextField
    }()
    
    let agePicker: UIDatePicker = {
    let age = UIDatePicker()
        age.datePickerMode = .date
    return age
    }()
    
    let genderSegment: UISegmentedControl = {
    let gender = UISegmentedControl(items: ["Männlich", "Weiblich"])
        gender.selectedSegmentIndex = 0
    return gender
    }()

    
    let backButton: UIButton = {
        let backToLoginButton = UIButton(type: .system)
        backToLoginButton.setTitle("Zurück", for: .normal)
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
        addSubview(nameTextField)
        addSubview(backButton)
        addSubview(continueButton)
        addSubview(agePicker)
        addSubview(genderSegment)
        
        nameTextField.addConstraintsWithConstants(top: topAnchor, right: rightAnchor, bottom: nil, left: leftAnchor, centerX: centerXAnchor, centerY: nil, topConstant: 50, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 40)
        
        agePicker.addConstraintsWithConstants(top: nameTextField.bottomAnchor, right: rightAnchor, bottom: nil, left: leftAnchor, centerX: centerXAnchor, centerY: nil, topConstant: 20, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 40)
        
        genderSegment.addConstraintsWithConstants(top: agePicker.bottomAnchor, right: rightAnchor, bottom: nil, left: leftAnchor, centerX: centerXAnchor, centerY: nil, topConstant: 20, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 20)
        
        backButton.addConstraintsWithConstants(top: nil, right: nil, bottom: bottomAnchor, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: frame.width/2, height: 40)
        
        continueButton.addConstraintsWithConstants(top: nil, right: rightAnchor, bottom: bottomAnchor, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: frame.width/2, height: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
