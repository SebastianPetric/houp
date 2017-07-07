//
//  RegistrationEmailPasswordController.swift
//  Houp
//
//  Created by Sebastian on 21.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class RegistrationAgeGenderController: UIViewController{

    
    let skipButton: UIButton = {
        let skipButton = UIButton(type: .system)
        skipButton.setTitle(GetString.skip.rawValue, for: .normal)
        skipButton.setTitleColor(UIColor().getSecondColor(), for: .normal)
        skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        return skipButton
    }()

    let birthdayPicker = CustomViews.shared.getCustomPickerViewWithTitle(title: GetString.birthday.rawValue, pickerMode: .date)
    
    let gender: UISegmentedControl = {
        let gender = UISegmentedControl(items: [GetString.male.rawValue, GetString.female.rawValue])
        gender.selectedSegmentIndex = 0
        gender.tintColor = UIColor().getSecondColor()
        return gender
    }()
    
    
    let continueButton = CustomViews().getCustomButton(title: GetString.continueButton.rawValue)
    let customProgressionView = CustomViews().getCustomProgressionView(status: 0.75, statusText: "3 von 4", progressColor: UIColor().getSecondColor())
 
    override func viewDidLoad() {
        self.title = "Gleich geschafft!"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(birthdayPicker)
        view.addSubview(gender)
        view.addSubview(continueButton)
        view.addSubview(customProgressionView)
        view.addSubview(skipButton)
        continueButton.addTarget(self, action: #selector(handleContinueButton), for: .touchUpInside)
        setUpSubviews()
    }
    
    func setUpSubviews(){
        
        birthdayPicker.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 122.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 65)
        
        gender.addConstraintsWithConstants(top: birthdayPicker.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        customProgressionView.addConstraintsWithConstants(top: gender.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 25)
        
        continueButton.addConstraintsWithConstants(top: customProgressionView.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 15, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        skipButton.addConstraintsWithConstants(top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 0, rightConstant: 50, bottomConstant: 25, leftConstant: 50, width: 0, height: 40)
    }
}
