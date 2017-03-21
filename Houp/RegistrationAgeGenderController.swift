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
        agePicker.layer.borderColor = UIColor.lightGray.cgColor
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
        return gender
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
        progresion.progress = 0.75
        return progresion
    }()
    
    let progressionViewText: UITextView = {
        let progressionViewText = UITextView()
        progressionViewText.text = "3 von 4"
        progressionViewText.font = UIFont.systemFont(ofSize: 10)
        progressionViewText.textAlignment = .center
        progressionViewText.textColor = .black
        return progressionViewText
    }()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(agePickerTextView)
        view.addSubview(agePicker)
        view.addSubview(gender)
        view.addSubview(continueButton)
        view.addSubview(progressionView)
        view.addSubview(progressionViewText)
        setUpSubviews()
    }
    
    func setUpSubviews(){
        agePickerTextView.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 75, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 25)
        
        agePicker.addConstraintsWithConstants(top: agePickerTextView.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 0, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 100)
        
        gender.addConstraintsWithConstants(top: agePicker.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        continueButton.addConstraintsWithConstants(top: gender.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        
        progressionView.addConstraintsWithConstants(top: continueButton.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 15, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 5)
        
        progressionViewText.addConstraintsWithConstants(top: progressionView.bottomAnchor, right: view.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 45, bottomConstant: 0, leftConstant: 0, width: 50, height: 20)
    }
}
