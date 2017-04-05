//
//  CreatePrivateGroupViewController.swift
//  Houp
//
//  Created by Sebastian on 29.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit


class CreatePrivateGroupViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{

    let pickerDataWeekDays = ["Montags", "Dienstags","Mittwochs", "Donnerstags", "Freitags", "Samstags", "Sonntags"]
    
    let nameOfGroup = CustomViews.shared.getCustomTextField(placeholder: GetString.nameOfGroup.rawValue, keyboardType: .default, isPasswordField: false)
    
    let locationOfMeeting = CustomViews.shared.getCustomTextField(placeholder: GetString.locatonOfMeeting.rawValue, keyboardType: .default, isPasswordField: false)
    
    let dayOfMeetingTitle = CustomViews.shared.getCustomLabel(text: GetString.dayOfMeeting.rawValue, fontSize: 16, isBold: true, textAlignment: .left, textColor: UIColor().getSecondColor())
    
    lazy var dayOfMeeting: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .white
        picker.dataSource = self
        picker.delegate = self
        picker.reloadAllComponents()
        return picker
    }()
    
    let timeOfMeeting = CustomViews.shared.getCustomPickerViewWithTitle(title: GetString.timeOfMeeting.rawValue, pickerMode: .time)
    
    let createButton = CustomViews.shared.getCustomButton(title: GetString.createPrivateGroup.rawValue)
    
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
        view.addSubview(nameOfGroup)
        view.addSubview(locationOfMeeting)
        view.addSubview(dayOfMeetingTitle)
        view.addSubview(dayOfMeeting)
        view.addSubview(timeOfMeeting)
        view.addSubview(createButton)
        createButton.addTarget(self, action: #selector(handleRequest), for: .touchUpInside)
        view.addGestureRecognizer(gestureRecognizer)
        addNotificationObserver()
        setUpSubViews()
    }

    
    private func setUpSubViews(){
        nameOfGroup.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        locationOfMeeting.addConstraintsWithConstants(top: nameOfGroup.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        dayOfMeetingTitle.addConstraintsWithConstants(top: locationOfMeeting.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 25)
        dayOfMeeting.addConstraintsWithConstants(top: dayOfMeetingTitle.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 0, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 80)
        timeOfMeeting.addConstraintsWithConstants(top: dayOfMeeting.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 65)
        createButton.addConstraintsWithConstants(top: timeOfMeeting.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    }
}
