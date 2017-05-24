//
//  EditThread.swift
//  Houp
//
//  Created by Sebastian on 24.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class EditThread: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var privateGroupsList: [PrivateGroup]?
    var heightOfPrivateContainer: NSLayoutConstraint?
    var sendToAllGroupsSwitch: UISwitch?
    var groupPicker: UIPickerView?
    private var message: String = ""
    var groupID: String?
    var thread: Thread?
    
    let titleThread = CustomViews.shared.getCustomTextField(placeholder: "Titel", keyboardType: .default, isPasswordField: false, backgroundColor: UIColor().getSecondColor())
    let messageThread = CustomViews.shared.getCustomTextViewContainer(text: "", fontSize: 12, isBold: true, textAlignment: .left, textColor: .white, borderColor: .white, backgroundColor: UIColor().getSecondColor())
    let editButton = CustomViews.shared.getCustomButton(title: "Thread updaten")
 
    var positiveResponse = UIView()
    
    lazy var gestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        return recognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.privateGroupsList = DBConnection.shared.getAllPrivateGroups()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.cancel_icon.rawValue), style: .plain, target: self, action: #selector(handleCancel))
        view.addSubview(titleThread)
        view.addSubview(messageThread)
        titleThread.delegate = self
        messageThread.delegate = self
        view.addSubview(editButton)
        editButton.addTarget(self, action: #selector(handleUpdate), for: .touchUpInside)
        view.addGestureRecognizer(gestureRecognizer)
        self.titleThread.text = self.thread?.title
        self.messageThread.text = self.thread?.message
        
        addNotificationObserver()
        setUpSubViews()
    }
    
    func setUpSubViews(){
        titleThread.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 34, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        messageThread.addConstraintsWithConstants(top: titleThread.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 100)
        editButton.addConstraintsWithConstants(top: messageThread.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 15, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    }
    
    private func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .UIKeyboardDidHide , object: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.privateGroupsList!.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.privateGroupsList?[row].nameOfGroup
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
            self.view.endEditing(true)
            return false
        }
        return true
    }
    
    func hideKeyboard(){
        self.view.endEditing(true)
    }
}
