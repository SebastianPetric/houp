//
//  CreateActivityWeekController.swift
//  Houp
//
//  Created by Sebastian on 09.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit


class ActivityWeekForm4: UIViewController, UITextFieldDelegate{
    
    var positiveResponse = UIView()
    let titleHeader = CustomViews.shared.getCustomLabel(text: "Was würdest du gerne unternehmen?", fontSize: 20, numberOfLines: 2, isBold: true, textAlignment: .center, textColor: .black)
    let activityText = CustomViews.shared.getCustomTextField(placeholder: "z.B. einen Film schauen", keyboardType: .default, isPasswordField: false, backgroundColor: UIColor().getSecondColor())
    let locationText = CustomViews.shared.getCustomTextField(placeholder: "Ort (freiwillig)", keyboardType: .default, isPasswordField: false, backgroundColor: UIColor().getSecondColor())
    let timeOfActivity = CustomViews.shared.getCustomPickerViewWithTitle(title: "Uhrzeit", pickerMode: .time)
    let dateActivity = CustomViews.shared.getCustomLabel(text: "Heute", fontSize: 12, numberOfLines: 1, isBold: true, textAlignment: .left, textColor: .black)
    let continueButton = CustomViews.shared.getCustomButton(title: "Weiter")
    let progressbar = CustomViews.shared.getCustomProgressionView(status: 0.5714285714, statusText: "4 von 7", progressColor: UIColor().getSecondColor())
    lazy var gestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        return recognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        view.backgroundColor = .white
        view.addSubview(dateActivity)
        view.addSubview(titleHeader)
        view.addSubview(activityText)
        activityText.delegate = self
        view.addSubview(locationText)
        locationText.delegate = self
        view.addSubview(timeOfActivity)
        view.addSubview(continueButton)
        self.continueButton.layer.borderColor = UIColor().getLightGreyColor().cgColor
        self.continueButton.setTitleColor(UIColor().getLightGreyColor(), for: .normal)
        view.addSubview(progressbar)
        view.addGestureRecognizer(gestureRecognizer)
        continueButton.addTarget(self, action: #selector(continueWeek), for: .touchUpInside)
        setUpSubViews()
    }
    
    func setUpSubViews(){
        titleHeader.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 25, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 0)
        activityText.addConstraintsWithConstants(top: titleHeader.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        locationText.addConstraintsWithConstants(top: activityText.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        timeOfActivity.addConstraintsWithConstants(top: locationText.bottomAnchor, right: activityText.rightAnchor, bottom: nil, left: activityText.leftAnchor, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 65)
        progressbar.addConstraintsWithConstants(top: timeOfActivity.bottomAnchor, right: continueButton.rightAnchor, bottom: nil, left: continueButton.leftAnchor, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 25)
        continueButton.addConstraintsWithConstants(top: progressbar.bottomAnchor, right: activityText.rightAnchor, bottom: nil, left: activityText.leftAnchor, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 40)
    }
    
    func hasAnyErrors() -> Bool{
        let timePicker = self.timeOfActivity.subviews[1] as! UIDatePicker
        let tomorrow = Calendar.current.date(byAdding: .day, value: 4, to: Date())
        
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
                let tomorrow = Calendar.current.date(byAdding: .day, value: 5, to: Date())
                let controller = ActivityWeekForm5()
                controller.title = tomorrow?.getDatePart()
                self.navigationController?.pushViewController(controller, animated: true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func hideKeyboard(){
        self.view.endEditing(true)
    }
}
