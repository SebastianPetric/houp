//
//  EditActivity.swift
//  Houp
//
//  Created by Sebastian on 15.06.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class EditActivity: UIViewController, UITextFieldDelegate{

    var activityWeekCollection: ActivityWeekCollection?
    var activity: Activity?
    var positiveResponse = UIView()
    let titleHeader = CustomViews.shared.getCustomLabel(text: "Was willst du gerne ändern?", fontSize: 20, numberOfLines: 2, isBold: true, textAlignment: .center, textColor: .black)
    let activityText = CustomViews.shared.getCustomTextField(placeholder: "z.B. mit Freunden treffen", keyboardType: .default, isPasswordField: false, textColor: .black,  backgroundColor: UIColor().getFourthColor())
    let locationText = CustomViews.shared.getCustomTextField(placeholder: "Ort (freiwillig)", keyboardType: .default, isPasswordField: false, textColor: .black, backgroundColor: UIColor().getFourthColor())
    let timeOfActivity = CustomViews.shared.getCustomPickerViewWithTitle(title: "Uhrzeit",titleColor: .black, pickerMode: .time)
    let dateActivity = CustomViews.shared.getCustomLabel(text: "Heute", fontSize: 12, numberOfLines: 1, isBold: true, textAlignment: .left, textColor: .black)
    let continueButton = CustomViews.shared.getCustomButton(title: "Aufgabe bearbeiten", borderColor: .black, textColor: .black)
    lazy var gestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        return recognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.cancel_icon.rawValue), style: .plain, target: self, action: #selector(handleCancel))
        view.backgroundColor = .white
        view.addSubview(dateActivity)
        view.addSubview(titleHeader)
        view.addSubview(activityText)
        activityText.delegate = self
        view.addSubview(locationText)
        locationText.delegate = self
        view.addSubview(timeOfActivity)
        view.addSubview(continueButton)
        view.addGestureRecognizer(gestureRecognizer)
        continueButton.addTarget(self, action: #selector(editActivity), for: .touchUpInside)
        self.activityText.text = self.activity?.activity
        self.locationText.text = self.activity?.locationOfActivity
        (self.timeOfActivity.subviews[1] as! UIDatePicker).date = (self.activity?.timeObject)!
        checkIfFieldsAreFilled()
        setUpSubViews()
    }
    
    func setUpSubViews(){
        titleHeader.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 25, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 0)
        activityText.addConstraintsWithConstants(top: titleHeader.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        locationText.addConstraintsWithConstants(top: activityText.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        timeOfActivity.addConstraintsWithConstants(top: locationText.bottomAnchor, right: activityText.rightAnchor, bottom: nil, left: activityText.leftAnchor, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 65)
        continueButton.addConstraintsWithConstants(top: timeOfActivity.bottomAnchor, right: activityText.rightAnchor, bottom: nil, left: activityText.leftAnchor, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 40)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkIfFieldsAreFilled()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func hideKeyboard(){
        self.view.endEditing(true)
    }
}
