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
    
    let nameOfGroup = CustomViews.shared.getCustomTextField(placeholder: "", keyboardType: .default, isPasswordField: false, backgroundColor: UIColor().getSecondColor())
    
    
    let locationOfMeeting = CustomViews.shared.getCustomTextField(placeholder: "", keyboardType: .default, isPasswordField: false, backgroundColor: UIColor().getSecondColor())
    
    let dayOfMeeting = CustomViews.shared.getCustomTextField(placeholder: "", keyboardType: .default, isPasswordField: false, backgroundColor: UIColor().getSecondColor())
    
    let timeOfMeeting = CustomViews.shared.getCustomPickerViewWithTitle(title: GetString.timeOfMeeting.rawValue, pickerMode: .time)
    
    let editButton = CustomViews.shared.getCustomButton(title: "Gruppendetails updaten")
    
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
        view.addSubview(dayOfMeeting)
        view.addSubview(timeOfMeeting)
        view.addSubview(editButton)
        
        (self.timeOfMeeting.subviews[1] as! UIDatePicker).date = (self.privateGroup?.timeOfMeeting)!
        nameOfGroup.placeholder = self.privateGroup?.nameOfGroup
        locationOfMeeting.placeholder = self.privateGroup?.location
        dayOfMeeting.placeholder = self.privateGroup?.dayOfMeeting
        editButton.addTarget(self, action: #selector(handleRequest), for: .touchUpInside)
        view.addGestureRecognizer(gestureRecognizer)
        addNotificationObserver()
        setUpSubViews()
    }
    
    private func setUpSubViews(){
        nameOfGroup.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        locationOfMeeting.addConstraintsWithConstants(top: nameOfGroup.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        dayOfMeeting.addConstraintsWithConstants(top: locationOfMeeting.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        timeOfMeeting.addConstraintsWithConstants(top: dayOfMeeting.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 65)
        editButton.addConstraintsWithConstants(top: timeOfMeeting.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    }


    func handleRequest(){
        
        if let window = UIApplication.shared.keyWindow{
                let timePicker = self.timeOfMeeting.subviews[1] as! UIDatePicker
                
                if (self.nameOfGroup.text != ""){
                    self.privateGroup?.nameOfGroup = self.nameOfGroup.text
                }
                if (self.dayOfMeeting.text != ""){
                    self.privateGroup?.dayOfMeeting = self.dayOfMeeting.text
                }
                if (self.locationOfMeeting.text != ""){
                    self.privateGroup?.location = self.locationOfMeeting.text
                }
                self.privateGroup?.timeOfMeeting = timePicker.date
                
            
                if let error = DBConnection().updatePrivateGroup(properties: self.privateGroup!){
                    let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: GetString.errorNoButton.rawValue, firstHandler: nil, secondHandler: {(alert: UIAlertAction!) in  self.dismiss(animated: true, completion: nil)})
                    self.present(alert, animated: true, completion: nil)
                }else{
                    self.positiveResponse = CustomViews.shared.getPositiveResponse(title: GetString.successCreatePrivateGroup.rawValue, message: "Gruppe erfolgreich geupdated!")
                    self.positiveResponse.frame = window.frame
                    self.positiveResponse.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
                    window.addSubview(positiveResponse)
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.positiveResponse.alpha = 1
                    }, completion: nil)
                }
        }
    }
    
    func handleDismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.positiveResponse.alpha = 0
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }
    
    func handleErrorOccured(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.positiveResponse.alpha = 0
        }, completion: nil)
    }
    
    
    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .UIKeyboardDidHide , object: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameOfGroup.endEditing(true)
        self.locationOfMeeting.endEditing(true)
        return false
    }
    func hideKeyboard(){
        self.nameOfGroup.endEditing(true)
        self.locationOfMeeting.endEditing(true)
    }

}
