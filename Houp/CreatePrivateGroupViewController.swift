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
    
    let nameOfGroup = CustomViews.shared.getCustomTextField(placeholder: GetString.nameOfGroup.rawValue, isPasswordField: false)
    
    let locationOfMeeting = CustomViews.shared.getCustomTextField(placeholder: GetString.locatonOfMeeting.rawValue, isPasswordField: false)
    
    let dayOfMeetingTextView : UITextView = {
        let dayOfMeetingTextView = UITextView()
        dayOfMeetingTextView.text = GetString.dayOfMeeting.rawValue
        dayOfMeetingTextView.isEditable = false
        return dayOfMeetingTextView
    }()
    
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
    
    
    
    
    
    
    
    
    
    let blackBackground = UIView()
    
    
    let responseContainer = { (hasErrorOccured: Bool) -> UIView in
        
        
        let responseTitle: UITextView = {
            let responseTitle = UITextView()
            responseTitle.text = "Header"
            responseTitle.textAlignment = .center
            responseTitle.font = UIFont.boldSystemFont(ofSize: 20)
            responseTitle.textColor = UIColor().getSecondColor()
            responseTitle.isEditable = false
            return responseTitle
        }()
        
        let responseMessage: UITextView = {
            let responseMessage = UITextView()
            responseMessage.textColor = UIColor().getSecondColor()
            responseTitle.font = UIFont.systemFont(ofSize: 20)
            responseMessage.textAlignment = .center
            responseMessage.text = "SecretID: 59IfwV22"
            responseMessage.isEditable = false
            return responseMessage
        }()
        
        let okButton = CustomViews.shared.getCustomButton(title: "Ok")
        let cancelButton = CustomViews.shared.getCustomButton(title: "Zurück zum Home")
        
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor().getSecondColor().cgColor
        view.layer.borderWidth = 1
        view.addSubview(responseTitle)
        view.addSubview(responseMessage)
        view.addSubview(okButton)
        view.addSubview(cancelButton)
        
        responseTitle.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 15, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 40)
        responseMessage.addConstraintsWithConstants(top: responseTitle.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 20, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 40)
        //        var widthOK: CGFloat?
        //        var widthCancel: CGFloat?
        //        var heightOK: CGFloat?
        //        var heightCancel: CGFloat = 40
        //
        //
        //        if(hasErrorOccured){
        //        widthOK = view.frame.width/2
        //        widthCancel = view.frame.width/2
        //        heightOK = 40
        //        }else{
        //        widthOK = 0
        //        widthCancel = view.frame.width
        //        heightOK = 0
        //        }
        //
        //        okButton.addConstraintsWithConstants(top: nil, right: nil, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: widthOK!, height: heightOK!)
        //
        //        cancelButton.addConstraintsWithConstants(top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, left: okButton.leftAnchor, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: widthCancel!, height: heightCancel)
        return view
    }

    
    
    func handleRequest(){
        
        if let window = UIApplication.shared.keyWindow{
            
            blackBackground.backgroundColor = UIColor(white: 0, alpha: 0.5)
            var selector: Selector?
            //Checken ob erfogreich war oder nicht
            
            if(false){
                selector = #selector(handleDismiss)
            }else{
                selector = #selector(handleErrorOccured)
            }
            blackBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
            blackBackground.frame = window.frame
            blackBackground.alpha = 0
            let response: UIView = responseContainer(true)
            blackBackground.addSubview(response)
            response.addConstraintsWithConstants(top: nil, right: blackBackground.rightAnchor, bottom: nil, left: blackBackground.leftAnchor, centerX: nil, centerY: blackBackground.centerYAnchor, topConstant: 0, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 150)
            
            window.addSubview(blackBackground)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackBackground.alpha = 1
            }, completion: nil)
            
        }
    }

    
    func handleDismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackBackground.alpha = 0
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }

    func handleErrorOccured(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackBackground.alpha = 0
        }, completion: nil)
    }

    
    
    
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
        //makeRequestToGroupButton.addTarget(self, action: #selector(handleMakeRequest), for: .touchUpInside)
        view.addSubview(nameOfGroup)
        view.addSubview(locationOfMeeting)
        view.addSubview(dayOfMeetingTextView)
        view.addSubview(dayOfMeeting)
        view.addSubview(timeOfMeeting)
        view.addSubview(createButton)
        createButton.addTarget(self, action: #selector(handleRequest), for: .touchUpInside)
        //view.addSubview(makeRequestToGroupButton)
        view.addGestureRecognizer(gestureRecognizer)
        addNotificationObserver()
        setUpSubViews()
    }

    
    private func setUpSubViews(){
        nameOfGroup.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        locationOfMeeting.addConstraintsWithConstants(top: nameOfGroup.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        dayOfMeetingTextView.addConstraintsWithConstants(top: locationOfMeeting.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 25)
        dayOfMeeting.addConstraintsWithConstants(top: dayOfMeetingTextView.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 0, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 80)
        timeOfMeeting.addConstraintsWithConstants(top: dayOfMeeting.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 65)
        createButton.addConstraintsWithConstants(top: timeOfMeeting.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 25, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        //makeRequestToGroupButton.addConstraintsWithConstants(top: createButton.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    }
    
    func handleCancel(){
    dismiss(animated: true, completion: nil)
    }
    
//    func handleMakeRequest(){
//    let controller = MakeRequestPrivateGroupViewController()
//        controller.navigationItem.title = GetString.makeRequestToPrivateGroup.rawValue
//    self.navigationController?.pushViewController(controller, animated: true)
//        
//    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerDataWeekDays.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerDataWeekDays[row]
    }
    private func addNotificationObserver(){
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
