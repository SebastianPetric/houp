//
//  RegistrationEmailPasswordController.swift
//  Houp
//
//  Created by Sebastian on 21.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class RegistrationAgeGenderController: UIViewController{

    let agePickerTextView : UITextView = {
        let agePickerTextView = UITextView()
        agePickerTextView.text = "Geburtstag"
        agePickerTextView.isEditable = false
        return agePickerTextView
    }()
    
    let agePicker: UIDatePicker = {
        let agePicker = UIDatePicker()
        agePicker.datePickerMode = .date
        agePicker.layer.cornerRadius = 5
        agePicker.layer.borderColor = UIColor(red: 229, green: 231, blue: 235, alphaValue: 1).cgColor
        agePicker.layer.borderWidth = 1
        var components = DateComponents()
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        agePicker.maximumDate = maxDate
        components.year = -100
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        agePicker.minimumDate = minDate
        return agePicker
    }()
    
    let gender: UISegmentedControl = {
        let gender = UISegmentedControl(items: ["Männlich", "Weiblich"])
        gender.selectedSegmentIndex = 0
        gender.tintColor = UIColor(red: 41, green: 192, blue: 232, alphaValue: 1)
        return gender
    }()
    
    
    let continueButton = CustomViews().getCustomButton(title: "Weiter")
    let customProgressionView = CustomViews().getCustomProgressionView(status: 0.75, statusText: "3 von 4")
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(agePickerTextView)
        view.addSubview(agePicker)
        view.addSubview(gender)
        view.addSubview(continueButton)
        view.addSubview(customProgressionView)
        continueButton.addTarget(self, action: #selector(handleContinueButton), for: .touchUpInside)
        setUpSubviews()
    }
    
    func setUpSubviews(){
        agePickerTextView.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 62.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 25)
        
        agePicker.addConstraintsWithConstants(top: agePickerTextView.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 0, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 100)
        
        gender.addConstraintsWithConstants(top: agePicker.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        customProgressionView.addConstraintsWithConstants(top: gender.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 25)
        
        continueButton.addConstraintsWithConstants(top: customProgressionView.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 15, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    }
}
