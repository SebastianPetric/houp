//
//  CreatePrivateGroupComment.swift
//  Houp
//
//  Created by Sebastian on 05.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class CreateGroupThreadController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    let pickerGroups = ["Gruppe 1", "Gruppe 2", "Gruppe 3"]
    var heightOfPrivateContainer: NSLayoutConstraint?
    
    let titleThread = CustomViews.shared.getCustomTextField(placeholder: "Titel", keyboardType: .default, isPasswordField: false)
    let messageThread = CustomViews.shared.getCustomTextViewContainer(text: "", fontSize: 12, isBold: true, textAlignment: .left, textColor: .white, borderColor: .white, backgroundColor: UIColor().getSecondColor())
    let createButton = CustomViews.shared.getCustomButton(title: "Thread erstellen")
    let isPublicLabel = CustomViews.shared.getCustomLabel(text: "Öffentlich fragen?", fontSize: 16, isBold: true, textAlignment: .left, textColor: .black)
    let isPublicSwitch: UISwitch = {
    let switchButton = UISwitch()
        switchButton.isOn = false
    
    return switchButton
    }()
    
    lazy var privateContainer: UIView = {
    
            let picker = UIPickerView()
            picker.backgroundColor = .white
            picker.delegate = self
            picker.dataSource = self
            picker.reloadAllComponents()

            let sendToAllGroupsLabel = CustomViews.shared.getCustomLabel(text: "An alle deine Gruppen senden?", fontSize: 12, isBold: true, textAlignment: .left, textColor: .black)
    
            let sendToAllGroupsSwitch = UISwitch()
            sendToAllGroupsSwitch.isOn = false

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(picker)
        container.addSubview(sendToAllGroupsLabel)
        container.addSubview(sendToAllGroupsSwitch)
        
        picker.addConstraintsWithConstants(top: container.topAnchor, right: container.rightAnchor, bottom: nil, left: container.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 40)
        sendToAllGroupsLabel.addConstraintsWithConstants(top: picker.bottomAnchor, right: nil, bottom: nil, left: container.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 200, height: sendToAllGroupsSwitch.frame.height)
        sendToAllGroupsSwitch.addConstraintsWithConstants(top: picker.bottomAnchor, right: container.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 0)
        return container
    }()
    
    var positiveResponse = UIView()
    
    lazy var gestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        return recognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.cancel_icon.rawValue), style: .plain, target: self, action: #selector(handleCancel))
        view.addSubview(titleThread)
        view.addSubview(messageThread)
        titleThread.delegate = self
        messageThread.delegate = self
        view.addSubview(createButton)
        view.addSubview(isPublicLabel)
        view.addSubview(isPublicSwitch)
        view.addSubview(privateContainer)
        isPublicSwitch.addTarget(self, action: #selector(handlePublicSwitch), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
        let sendToAllGroupsSwitch = privateContainer.subviews[2] as! UISwitch
        sendToAllGroupsSwitch.addTarget(self, action: #selector(handleSendAllGroupsSwitch), for: .touchUpInside)
        view.addGestureRecognizer(gestureRecognizer)
        addNotificationObserver()
        setUpSubViews()
    }
    
    func setUpSubViews(){
        titleThread.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 34, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        messageThread.addConstraintsWithConstants(top: titleThread.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 100)
        isPublicLabel.addConstraintsWithConstants(top: messageThread.bottomAnchor, right: nil, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 50, width: 200, height: isPublicSwitch.frame.height)
        isPublicSwitch.addConstraintsWithConstants(top: messageThread.bottomAnchor, right: view.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 50, bottomConstant: 0, leftConstant: 0, width: 0, height: 0)
        
        privateContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        privateContainer.topAnchor.constraint(equalTo: isPublicSwitch.bottomAnchor, constant: 0).isActive = true
        privateContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        self.heightOfPrivateContainer = privateContainer.heightAnchor.constraint(equalToConstant: 100)
        self.heightOfPrivateContainer?.isActive = true
        
        createButton.addConstraintsWithConstants(top: privateContainer.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 15, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    }
    
    private func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .UIKeyboardDidHide , object: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerGroups.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerGroups[row]
    }

}
