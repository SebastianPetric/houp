//
//  RegistrationEmailPasswordController.swift
//  Houp
//
//  Created by Sebastian on 21.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class RegistrationAgeGenderController: UIViewController{

    let agePicker = CustomViews.shared.getCustomPickerViewWithTitle(title: GetString.birthday.rawValue, pickerMode: .date)
    
    
    let gender: UISegmentedControl = {
        let gender = UISegmentedControl(items: [GetString.male.rawValue, GetString.female.rawValue])
        gender.selectedSegmentIndex = 0
        gender.tintColor = UIColor().getSecondColor()
        return gender
    }()
    
    
    let continueButton = CustomViews().getCustomButton(title: GetString.continueButton.rawValue)
    let customProgressionView = CustomViews().getCustomProgressionView(status: 0.75, statusText: "3 von 4")
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(agePicker)
        view.addSubview(gender)
        view.addSubview(continueButton)
        view.addSubview(customProgressionView)
        continueButton.addTarget(self, action: #selector(handleContinueButton), for: .touchUpInside)
        setUpSubviews()
    }
    
    func setUpSubviews(){
        
        agePicker.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 122.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 65)
        
        gender.addConstraintsWithConstants(top: agePicker.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        customProgressionView.addConstraintsWithConstants(top: gender.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 25)
        
        continueButton.addConstraintsWithConstants(top: customProgressionView.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 15, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    }
}
