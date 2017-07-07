//
//  EditProfile.swift
//  Houp
//
//  Created by Sebastian on 07.07.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class EditProfile: UIViewController, UITextFieldDelegate{

    let profileImageWidthHeight: CGFloat = 150
    var positiveResponse = UIView()
    let profileImage = CustomViews.shared.getCustomImageView(imageName: GetString.defaultProfileImage.rawValue, cornerRadius: 75, isUserInteractionEnabled: true, imageColor: nil, borderColor: UIColor().getSecondColor())
    let nameTextField = CustomViews.shared.getCustomTextField(placeholder: GetString.name.rawValue, keyboardType: .default, isPasswordField: false, backgroundColor: UIColor().getSecondColor())
    let prenameTextField = CustomViews.shared.getCustomTextField(placeholder: GetString.prename.rawValue, keyboardType: .default, isPasswordField: false, backgroundColor: UIColor().getSecondColor())
    let birthdayPicker = CustomViews.shared.getCustomPickerViewWithTitle(title: GetString.birthday.rawValue, pickerMode: .date)
    let gender: UISegmentedControl = {
        let gender = UISegmentedControl(items: [GetString.male.rawValue, GetString.female.rawValue])
        gender.selectedSegmentIndex = -1
        gender.tintColor = UIColor().getSecondColor()
        return gender
    }()
    let continueButton = CustomViews.shared.getCustomButton(title: "Profildaten ändern", borderColor: .black, textColor: .black)
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.cancel_icon.rawValue), style: .plain, target: self, action: #selector(handleCancel))
        view.addSubview(profileImage)
        view.addSubview(nameTextField)
        nameTextField.delegate = self
        view.addSubview(prenameTextField)
        prenameTextField.delegate = self
        view.addSubview(gender)
        view.addSubview(birthdayPicker)
        view.addSubview(continueButton)
        continueButton.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGetProfileImage)))
        super.viewDidLoad()
        setUpSubViews()
    }
    
    func setUpSubViews(){
    profileImage.addConstraintsWithConstants(top: view.topAnchor, right: nil, bottom: nil, left: nil, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: profileImageWidthHeight, height: self.profileImageWidthHeight)
    nameTextField.addConstraintsWithConstants(top: profileImage.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    prenameTextField.addConstraintsWithConstants(top: nameTextField.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    birthdayPicker.addConstraintsWithConstants(top: prenameTextField.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 65)
    gender.addConstraintsWithConstants(top: birthdayPicker.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    continueButton.addConstraintsWithConstants(top: gender.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    }

}
