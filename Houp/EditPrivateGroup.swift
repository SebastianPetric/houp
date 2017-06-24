//
//  EditPrivateGroup.swift
//  Houp
//
//  Created by Sebastian on 23.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class EditPrivateGroup: UIViewController, UITextFieldDelegate{
    
    var privateGroup: PrivateGroup?
    private var errorMessage: String = ""
    
    let titleHeader = CustomViews.shared.getCustomLabel(text: "Was willst du gerne ändern?", fontSize: 20, numberOfLines: 2, isBold: true, textAlignment: .center, textColor: .black)
    let nameOfGroup = CustomViews.shared.getCustomTextField(placeholder: "", keyboardType: .default, isPasswordField: false, backgroundColor: UIColor().getSecondColor())
    let locationOfMeeting = CustomViews.shared.getCustomTextField(placeholder: "", keyboardType: .default, isPasswordField: false, backgroundColor: UIColor().getSecondColor())
    
    let dayOfMeeting = CustomViews.shared.getCustomTextField(placeholder: "", keyboardType: .default, isPasswordField: false, backgroundColor: UIColor().getSecondColor())
    
    let timeOfMeeting = CustomViews.shared.getCustomPickerViewWithTitle(title: GetString.timeOfMeeting.rawValue, titleColor: .black, pickerMode: .time)
    
    let editButton = CustomViews.shared.getCustomButton(title: "Gruppendetails updaten", borderColor: .black, textColor: .black)
    var positiveResponse = UIView()
    
    lazy var gestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        return recognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.nameOfGroup.delegate = self
        self.locationOfMeeting.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.cancel_icon.rawValue), style: .plain, target: self, action: #selector(handleCancel))
        view.addSubview(titleHeader)
        view.addSubview(nameOfGroup)
        view.addSubview(locationOfMeeting)
        view.addSubview(dayOfMeeting)
        view.addSubview(timeOfMeeting)
        view.addSubview(editButton)
        (self.timeOfMeeting.subviews[1] as! UIDatePicker).date = (self.privateGroup?.timeOfMeeting)!
        editButton.addTarget(self, action: #selector(handleRequest), for: .touchUpInside)
        nameOfGroup.text = self.privateGroup?.nameOfGroup
        locationOfMeeting.text = self.privateGroup?.location
        dayOfMeeting.text = self.privateGroup?.dayOfMeeting
        view.addGestureRecognizer(gestureRecognizer)
        addNotificationObserver()
        setUpSubViews()
    }
    
    private func setUpSubViews(){
        titleHeader.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 25, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 0)
        nameOfGroup.addConstraintsWithConstants(top: titleHeader.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        locationOfMeeting.addConstraintsWithConstants(top: nameOfGroup.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        dayOfMeeting.addConstraintsWithConstants(top: locationOfMeeting.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        timeOfMeeting.addConstraintsWithConstants(top: dayOfMeeting.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 65)
        editButton.addConstraintsWithConstants(top: timeOfMeeting.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    }

    func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .UIKeyboardDidHide , object: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameOfGroup.endEditing(true)
        self.locationOfMeeting.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkIfFieldsAreFilled()
    }
    
    func hideKeyboard(){
        self.nameOfGroup.endEditing(true)
        self.locationOfMeeting.endEditing(true)
    }

}
