//
//  CreateActivityWeekController.swift
//  Houp
//
//  Created by Sebastian on 09.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit


class CreateActivityWeekController: UIViewController, UITextFieldDelegate{
    
    var positiveResponse = UIView()
    let titleHeader = CustomViews.shared.getCustomLabel(text: "Was würdest du gerne morgen unternehmen?", fontSize: 20, numberOfLines: 2, isBold: true, textAlignment: .center, textColor: .black)
    let onlyForNextDay = CustomViews.shared.getCustomLabel(text: "Willst du nur für morgen planen? (Anstatt der ganzen Woche)", fontSize: 12, numberOfLines: 2, isBold: true, textAlignment: .left, textColor: .black)
    let isOnlyNextDaySwitch: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        return switchButton
    }()
    let activityText = CustomViews.shared.getCustomTextField(placeholder: "z.B. Schwimmen gehen", keyboardType: .default, isPasswordField: false, backgroundColor: UIColor().getSecondColor())
    let locationText = CustomViews.shared.getCustomTextField(placeholder: "Ort (freiwillig)", keyboardType: .default, isPasswordField: false, backgroundColor: UIColor().getSecondColor())
    let timeOfActivity = CustomViews.shared.getCustomPickerViewWithTitle(title: "Uhrzeit", pickerMode: .time)
    let dateActivity = CustomViews.shared.getCustomLabel(text: "Heute", fontSize: 12, numberOfLines: 1, isBold: true, textAlignment: .left, textColor: .black)
    let continueButton = CustomViews.shared.getCustomButton(title: "Weiter")
    lazy var gestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        return recognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        view.addSubview(dateActivity)
        view.addSubview(titleHeader)
        view.addSubview(onlyForNextDay)
        view.addSubview(isOnlyNextDaySwitch)
        isOnlyNextDaySwitch.addTarget(self, action: #selector(handlePublicSwitch), for: .touchUpInside)
        view.addSubview(activityText)
        activityText.delegate = self
        view.addSubview(locationText)
        locationText.delegate = self
        view.addSubview(timeOfActivity)
        view.addGestureRecognizer(gestureRecognizer)
        view.addSubview(continueButton)
        self.continueButton.layer.borderColor = UIColor().getLightGreyColor().cgColor
        self.continueButton.setTitleColor(UIColor().getLightGreyColor(), for: .normal)
        continueButton.addTarget(self, action: #selector(continBut), for: .touchUpInside)
        setUpSubViews()
    }
    
    func setUpSubViews(){
    titleHeader.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 25, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 0)
    isOnlyNextDaySwitch.addConstraintsWithConstants(top: titleHeader.bottomAnchor, right: activityText.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 25, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 50, height: 0)
    onlyForNextDay.addConstraintsWithConstants(top: nil, right: isOnlyNextDaySwitch.leftAnchor, bottom: nil, left: activityText.leftAnchor, centerX: nil, centerY: isOnlyNextDaySwitch.centerYAnchor, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 0)
    activityText.addConstraintsWithConstants(top: isOnlyNextDaySwitch.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    locationText.addConstraintsWithConstants(top: activityText.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    timeOfActivity.addConstraintsWithConstants(top: locationText.bottomAnchor, right: activityText.rightAnchor, bottom: nil, left: activityText.leftAnchor, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 65)
    continueButton.addConstraintsWithConstants(top: timeOfActivity.bottomAnchor, right: activityText.rightAnchor, bottom: nil, left: activityText.leftAnchor, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 40)
    }
    
    func handlePublicSwitch(){
        if(self.isOnlyNextDaySwitch.isOn){
            self.continueButton.setTitle("Aktivität erstellen", for: .normal)
        }else{
            self.continueButton.setTitle("Weiter", for: .normal)
        }
    }
    func continBut(){
        if(self.activityText.text! != ""){
        if(self.isOnlyNextDaySwitch.isOn){
        finishDay()
        }else{
        continueWeek()
        }
        }
    }
    
    func finishDay(){
            if (hasAnyErrors()){
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithDB.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                self.present(alert, animated: true, completion: nil)
            }else{
                if let window = UIApplication.shared.keyWindow{
                    self.positiveResponse = CustomViews.shared.getPositiveResponse(title: "Super!", message: "Morgen wird ein guter Tag!")
                    self.positiveResponse.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
                    self.positiveResponse.frame = window.frame
                    window.addSubview(positiveResponse)
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.positiveResponse.alpha = 1
                    }, completion: nil)
                }
            }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(self.activityText.text! != ""){
            self.continueButton.layer.borderColor = UIColor().getSecondColor().cgColor
            self.continueButton.setTitleColor(UIColor().getSecondColor(), for: .normal)
        }else{
            self.continueButton.layer.borderColor = UIColor().getLightGreyColor().cgColor
            self.continueButton.setTitleColor(UIColor().getLightGreyColor(), for: .normal)
        }
    }
    
    func hasAnyErrors() -> Bool{
        let timePicker = self.timeOfActivity.subviews[1] as! UIDatePicker
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        
        let activity = Activity(rev: nil, aid: nil, authorID: UserDefaults.standard.string(forKey: GetString.userID.rawValue), authorUsername: nil, groupID: nil, activity: self.activityText.text, activityText: nil, locationOfActivity: self.locationText.text, isInProcess: nil, status: nil, wellBeingState: nil, wellBeingText: nil, addictionState: nil, addictionText: nil, dateObject: tomorrow, timeObject: timePicker.date, commentIDs: nil, likeIDs: nil)
        if let error = DBConnection.shared.createActivityWithProperties(properties: activity){
            return true
        }else{
            return false
        }
        
    }
    
    func continueWeek(){
        if(self.continueButton.layer.borderColor == UIColor().getSecondColor().cgColor){
            if (hasAnyErrors()){
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithDB.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: {action in self.dismiss(animated: true, completion: nil)}, secondHandler: nil)
                self.present(alert, animated: true, completion: nil)
            }else{
                let tomorrow = Calendar.current.date(byAdding: .day, value: 2, to: Date())
                let controller = ActivityWeekForm2()
                controller.title = tomorrow?.getDatePart()
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    func handleDismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.positiveResponse.alpha = 0
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }
}
